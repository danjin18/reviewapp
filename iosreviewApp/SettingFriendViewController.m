//
//  SettingFriendViewController.m
//  iosreviewApp
//
//  Created by dan jin on 5/28/17.
//  Copyright © 2017 star. All rights reserved.
//

#import "SettingFriendViewController.h"
#import "FriendTableViewCell.h"
#import "EditProfileViewController.h"

#import "SWRevealViewController.h"
#import "ContactViewController.h"
#import "SearchViewController.h"
#import "ScanController.h"

#import "Preference.h"
#import "Constants.h"

#import <AFNetworking.h>
#import "UIImageView+AFNetworking.h"
#import "ServerAPIPath.h"

#import "utility.h"
#import "AppDelegate.h"

@interface SettingFriendViewController ()
{
    Preference *pref;
    NSInteger selected_row;
}
@end

@implementation SettingFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.sidebarButton setTarget: self.revealViewController];
        [self.sidebarButton setAction: @selector( revealToggle: )];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
        
        [self.rightbarButton setTarget: self.revealViewController];
        [self.rightbarButton setAction: @selector( rightRevealToggle: )];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    
    pref = [Preference getInstance];
    
    [_friendTable registerNib:[UINib nibWithNibName:@"FriendTableViewCell" bundle:nil] forCellReuseIdentifier:@"FriendTableViewCell"];
    
    [self getFriend];
}

-(void)getFriend
{
    [utility showProgressDialog:self];
    
    NSURL *URL = [NSURL URLWithString:API_POST_MENU_FIND_FRIENDS];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:[pref getSharedPreference:nil :PREF_PARAM_USER_ID :@""], @"user_id",
                                nil];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST:URL.absoluteString parameters:parameters progress:nil success:^(NSURLSessionDataTask * task, id  responseObject) {
        
        [utility hideProgressDialog];
        if (responseObject == nil) {
            return;
        }
        else {
            NSError *error = nil;
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];
            long status = [[json objectForKey:@"status"] longValue];
            if(status == 1) {
                @try {
                    _myFriendModel = [[FriendModel alloc] init:[json objectForKey:@"Data"]];
                    [self.friendTable reloadData];
                }
                @catch (NSException *e) {
                    NSLog(@"responseInvjson	NSDictionary *	0x7fff5b3465f8	0x00007fff5b3465f8oiceList - JSONException : %@", e.reason);
                }
            }
            else
                [[AppDelegate sharedAppDelegate] showToastMessage:NSLocalizedString(@"not fild friend.", @"")];
        }
        
        
    } failure:^(NSURLSessionDataTask  *task, NSError  *error) {
        
        [utility hideProgressDialog];
        [[AppDelegate sharedAppDelegate] showToastMessage:error.localizedDescription];
        
    }];
}
-(void)setFriend:(NSString *)friendid status:(NSString *)userstatus{
    [utility showProgressDialog:self];

    NSURL *URL = [NSURL URLWithString:API_POST_ADD_NEWFRIENDS];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:[pref getSharedPreference:nil :PREF_PARAM_USER_ID :@""], @"user_id",
                                friendid, @"friend_id",
                                userstatus,@"status",
                                nil];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST:URL.absoluteString parameters:parameters progress:nil success:^(NSURLSessionDataTask * task, id  responseObject) {
        
        [utility hideProgressDialog];
        if (responseObject == nil) {
            return;
        }
        else {
            NSError *error = nil;
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];
            long status = [[json objectForKey:@"status"] longValue];
            if(status == 1) {
                @try {
                    [self.friendTable reloadData];
                }
                @catch (NSException *e) {
                    NSLog(@"responseInvjson	NSDictionary *	0x7fff5b3465f8	0x00007fff5b3465f8oiceList - JSONException : %@", e.reason);
                }
            }
            else
                [[AppDelegate sharedAppDelegate] showToastMessage:NSLocalizedString(@"not fild friend.", @"")];
        }
        
        
    } failure:^(NSURLSessionDataTask  *task, NSError  *error) {
        
        [utility hideProgressDialog];
        [[AppDelegate sharedAppDelegate] showToastMessage:error.localizedDescription];
        
    }];
}
- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FriendTableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:@"FriendTableViewCell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[FriendTableViewCell alloc] init];
    }
    NSString *photoUrl = [self.myFriendModel.user_photo objectAtIndex:indexPath.row];
    NSString *name = [self.myFriendModel.user_name objectAtIndex:indexPath.row];
    NSString *id = [self.myFriendModel.user_id objectAtIndex:indexPath.row];
    NSString *phone = [self.myFriendModel.user_phone objectAtIndex:indexPath.row];
    NSString *status = [self.myFriendModel.user_status objectAtIndex:indexPath.row];
    [cell setPhotoCell:photoUrl];
    [cell setNameCell:name];
    [cell setIdCell:id];
    [cell setPhoneCell:phone];
    [cell setFollowCell:status];
    // make round friend image.
    cell.user_photo.layer.cornerRadius = cell.user_photo.frame.size.width / 2;
    cell.user_photo.clipsToBounds = YES;
    //image click event
    cell.user_follow.userInteractionEnabled = YES;
    cell.user_follow.tag = indexPath.row;
    UITapGestureRecognizer *tapped = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(followClicked:)];
    [cell.user_follow addGestureRecognizer:tapped];

    return cell;
}
-(void)followClicked:(id)sender
{
    UITapGestureRecognizer *gesture = (UITapGestureRecognizer *)sender;
    
    if([[self.myFriendModel.user_status objectAtIndex:gesture.view.tag] isEqualToString:@"Approved"])
    {
        [self.myFriendModel.user_status replaceObjectAtIndex:gesture.view.tag withObject:@"Rejected"];
    }
    else {
        [self.myFriendModel.user_status replaceObjectAtIndex:gesture.view.tag withObject:@"Approved"];
    }
    
    [self setFriend:[self.myFriendModel.user_id objectAtIndex:gesture.view.tag] status:[self.myFriendModel.user_status objectAtIndex:gesture.view.tag]];
}
- (NSInteger)tableView:(UITableView *)_tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.myFriendModel.user_name count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}
- (void)tableView:(UITableView *)_tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_tableView deselectRowAtIndexPath:indexPath animated:NO];
    selected_row = (int)indexPath.row;
    
    [self performSegueWithIdentifier:@"profileSegue" sender:self];
}

- (IBAction)searchClicked:(id)sender {
    
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SearchViewController * controller = (SearchViewController *)[storyboard instantiateViewControllerWithIdentifier:@"searchview"];
    [self.navigationController pushViewController: controller animated:YES];
}
- (IBAction)contactClicked:(id)sender {
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ContactViewController * controller = (ContactViewController *)[storyboard instantiateViewControllerWithIdentifier:@"contactview"];
    
    controller.modalPresentationStyle =  UIModalPresentationOverCurrentContext;
    
    [self presentViewController:controller animated:NO completion:nil];
}
- (IBAction)barcodeClicked:(id)sender {
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ScanController * controller = (ScanController *)[storyboard instantiateViewControllerWithIdentifier:@"barcodeview"];
    [self.navigationController pushViewController: controller animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([[segue identifier] isEqualToString:@"profileSegue"])
    {
        EditProfileViewController *vc = [segue destinationViewController];
        vc.user_photo = [self.myFriendModel.user_photo objectAtIndex:selected_row];
        vc.userid = [self.myFriendModel.user_id objectAtIndex:selected_row];
        vc.username = [self.myFriendModel.user_name objectAtIndex:selected_row];
    }
}


@end
