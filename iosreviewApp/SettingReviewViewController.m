//
//  SettingReviewViewController.m
//  iosreviewApp
//
//  Created by dan jin on 5/31/17.
//  Copyright © 2017 star. All rights reserved.
//

#import "SettingReviewViewController.h"
#import "FullPhotoViewController.h"
#import "MyReviewDetailViewController.h"

#import "Preference.h"
#import "Constants.h"

#import <AFNetworking.h>
#import "UIImageView+AFNetworking.h"
#import "ServerAPIPath.h"

#import "utility.h"
#import "AppDelegate.h"

#import "SettingReviewTableViewCell.h"

#import "SWRevealViewController.h"
#import "ContactViewController.h"
#import "SearchViewController.h"
#import "ScanController.h"

@interface SettingReviewViewController ()
{
    int selected_row; long selected_photo;
    Preference *pref;
}
@end

@implementation SettingReviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    pref = [Preference getInstance];
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
    
    [_reviewTable registerNib:[UINib nibWithNibName:@"SettingReviewTableViewCell" bundle:nil] forCellReuseIdentifier:@"SettingReviewTableViewCell"];
    
    [self getReviewList];
}
-(void)getReviewList {
    
    [utility showProgressDialog:self];
    
    
    NSURL *URL = [NSURL URLWithString:API_POST_GET_FEATURE_REVIEW];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:[pref getSharedPreference:nil :PREF_PARAM_USER_ID :@""], @"user_id", nil];
    
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
            if([json objectForKey:@"status"]) {
                @try {
                    _arrAllReview = [[reviewModel alloc] init:[json objectForKey:@"Data"]];
                    [_reviewTable reloadData];
                    
                }
                @catch (NSException *e) {
                    NSLog(@"responseInvoiceList - JSONException : %@", e.reason);
                }
            }
            else
                [[AppDelegate sharedAppDelegate] showToastMessage:NSLocalizedString(@"request failed", @"")];
        }
        
        
    } failure:^(NSURLSessionDataTask  *task, NSError  *error) {
        
        [utility hideProgressDialog];
        NSLog(@"Push-sendPush = %@" , error.localizedDescription);
        
    }];
    
}

- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SettingReviewTableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:@"SettingReviewTableViewCell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[SettingReviewTableViewCell alloc] init];
    }
    NSString *photoUrl = [self.arrAllReview.primary_photos objectAtIndex:indexPath.row];
    NSString *name = [self.arrAllReview.name objectAtIndex:indexPath.row];
    NSString *review = [self.arrAllReview.review objectAtIndex:indexPath.row]; //rate
    NSString *totalReviewCount = [self.arrAllReview.totalReviewCount objectAtIndex:indexPath.row];
    NSString *comment = [self.arrAllReview.comment objectAtIndex:indexPath.row];
    
    [cell setPhotoCell:photoUrl];
    [cell setNameCell:name];
    [cell setReviewCell:comment];
    [cell setcountCell:totalReviewCount];
    [cell setRateCell:review];
    
    cell.product_photo.userInteractionEnabled = YES;
    cell.product_photo.tag = indexPath.row;
    
    UITapGestureRecognizer *tapped = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fullPhoto:)];
    tapped.numberOfTapsRequired = 1;
    [cell.product_photo addGestureRecognizer:tapped];
    
    return cell;
}
-(void)fullPhoto:(id)sender
{
    UITapGestureRecognizer *gesture = (UITapGestureRecognizer *) sender;
    selected_photo = gesture.view.tag;
    
    [self performSegueWithIdentifier:@"photoSegue" sender:self];
}
- (NSInteger)tableView:(UITableView *)_tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.arrAllReview.product_id count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 150;
}
- (void)tableView:(UITableView *)_tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_tableView deselectRowAtIndexPath:indexPath animated:NO];
    selected_row = (int)indexPath.row;
    
    [self performSegueWithIdentifier:@"detailSegue" sender:self];
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
    if([[segue identifier] isEqualToString:@"photoSegue"])
    {
        FullPhotoViewController *vc = [segue destinationViewController];
        vc.photoURL = [_arrAllReview.primary_photos objectAtIndex:selected_photo];
    }
    if([[segue identifier] isEqualToString:@"detailSegue"])
    {
        MyReviewDetailViewController *vc = [segue destinationViewController];
        vc.product_id = [_arrAllReview.product_id objectAtIndex:selected_row];
        vc.review = [_arrAllReview.comment objectAtIndex:selected_row];
        vc.product_photo = [_arrAllReview.primary_photos objectAtIndex:selected_row];
    }
}

- (IBAction)searchClicked:(id)sender {
    
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SearchViewController * controller = (SearchViewController *)[storyboard instantiateViewControllerWithIdentifier:@"searchview"];
    [self presentViewController:controller animated:NO completion:nil];
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
    [self presentViewController:controller animated:NO completion:nil];
}
@end
