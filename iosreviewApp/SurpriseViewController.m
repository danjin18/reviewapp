//
//  SurpriseViewController.m
//  iosreviewApp
//
//  Created by dan jin on 6/2/17.
//  Copyright © 2017 star. All rights reserved.
//

#import "SurpriseViewController.h"
#import "RedeemDetailViewController.h"
#import "RedeemShareViewController.h"

#import "SearchViewController.h"
#import "ContactViewController.h"
#import "ScanController.h"

#import "SurpriseTableViewCell.h"

#import "Preference.h"
#import "Constants.h"

#import <AFNetworking.h>
#import "UIImageView+AFNetworking.h"
#import "ServerAPIPath.h"

#import "utility.h"
#import "AppDelegate.h"

#import "SWRevealViewController.h"

@interface SurpriseViewController ()
{
    Preference *pref;
    NSInteger share_row, redeem_row;
}
@end

@implementation SurpriseViewController

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
    
    [_myTable registerNib:[UINib nibWithNibName:@"SurpriseTableViewCell" bundle:nil] forCellReuseIdentifier:@"SurpriseTableViewCell"];
    
    [self getSurprise];
}

-(void)getSurprise
{
    [utility showProgressDialog:self];
    
    
    NSURL *URL = [NSURL URLWithString:API_POST_GET_SURPRISE];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:[pref getSharedPreference:nil :PREF_PARAM_USER_ID :@""], @"userId",nil];
    
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

                @try {
                    _arrSurprise = [[surpriseModel alloc] init:[json objectForKey:@"Data"]];
                    [_myTable reloadData];
                }
                @catch (NSException *e) {
                    NSLog(@"responseInvoiceList - JSONException : %@", e.reason);
                }

        }
        
        
    } failure:^(NSURLSessionDataTask  *task, NSError  *error) {
        
        [utility hideProgressDialog];
        [[AppDelegate sharedAppDelegate] showToastMessage:error.localizedDescription];
        
    }];
}
- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SurpriseTableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:@"SurpriseTableViewCell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[SurpriseTableViewCell alloc] init];
    }
    NSString *photoUrl = [self.arrSurprise.photo objectAtIndex:indexPath.row];
    NSString *name = [self.arrSurprise.title objectAtIndex:indexPath.row];
    NSString *expiry = [self.arrSurprise.expiry objectAtIndex:indexPath.row]; //rate
    NSString *review = [self.arrSurprise.review objectAtIndex:indexPath.row];
    NSString *status = [self.arrSurprise.status objectAtIndex:indexPath.row];
    
    [cell setPhotoCell:photoUrl];
    [cell setTitleCell:name];
    [cell setExpiryCell:expiry];
    [cell setReviewCell:review];
    [cell setRedeemed:status];
    
    cell.redeemBtn.tag = indexPath.row;
    [cell.redeemBtn addTarget:self action:@selector(redeemClicked:) forControlEvents:UIControlEventTouchUpInside];
    
//    cell.redeemBtn.tag = indexPath.row;
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longredeemClicked:)];
    [cell.redeemBtn addGestureRecognizer:longPress];
    
    cell.shareBtn.tag = indexPath.row;
    [cell.shareBtn addTarget:self action:@selector(shareClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

-(void)redeemClicked:(UIButton*)sender
{
    redeem_row = sender.tag;
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.myTable];
    NSIndexPath *indexPath = [self.myTable indexPathForRowAtPoint:buttonPosition];
    
    SurpriseTableViewCell *cell = (SurpriseTableViewCell *)[self.myTable cellForRowAtIndexPath:indexPath];
    [cell setRedeemed:@"1"];
    [self setRedeemed:[self.arrSurprise.sid objectAtIndex:indexPath.row]];
    [self performSegueWithIdentifier:@"redeemSegue" sender:self];
}
-(void)longredeemClicked:(UILongPressGestureRecognizer*)gestureRecognizer
{
    CGPoint p = [gestureRecognizer locationInView:self.myTable];
    
    NSIndexPath *indexPath = [self.myTable indexPathForRowAtPoint:p];
    if (indexPath == nil) {
        NSLog(@"long press on table view but not on a row");
    }
    else if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        SurpriseTableViewCell *cell = (SurpriseTableViewCell *)[self.myTable cellForRowAtIndexPath:indexPath];
        [cell setRedeemed:@"1"];
        [self setRedeemed:[self.arrSurprise.sid objectAtIndex:indexPath.row]];
    }
    
}
-(void)setRedeemed:(NSString *)sid
{
    [utility showProgressDialog:self];
    
    
    NSURL *URL = [NSURL URLWithString:API_POST_SET_REDEEM];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:[pref getSharedPreference:nil :PREF_PARAM_USER_ID :@""], @"user_id",
                                sid, @"sid",
                                nil];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST:URL.absoluteString parameters:parameters progress:nil success:^(NSURLSessionDataTask * task, id  responseObject) {
        
        [utility hideProgressDialog];
        if (responseObject == nil) {
            return;
        }
        else {

        }
        
        
    } failure:^(NSURLSessionDataTask  *task, NSError  *error) {
        
        [utility hideProgressDialog];
        [[AppDelegate sharedAppDelegate] showToastMessage:error.localizedDescription];
        
    }];
}
-(void)shareClicked:(UIButton*)sender
{
    if (sender.tag == 0)
    {
        // Your code here
    }
    share_row = sender.tag;
    [self performSegueWithIdentifier:@"shareSegue" sender:self];
}

- (NSInteger)tableView:(UITableView *)_tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.arrSurprise.sid count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 260;
}
- (void)tableView:(UITableView *)_tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_tableView deselectRowAtIndexPath:indexPath animated:NO];
    //selected_row = (int)indexPath.row;
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
    if([[segue identifier] isEqualToString:@"redeemSegue"])
    {
        UINavigationController *navController = [segue destinationViewController];
        RedeemDetailViewController *vc = (RedeemDetailViewController *)navController.topViewController;
        vc.sid = [self.arrSurprise.sid objectAtIndex:redeem_row];
    }
    
    if([[segue identifier] isEqualToString:@"shareSegue"])
    {
        UINavigationController *navController = [segue destinationViewController];RedeemShareViewController *vc = (RedeemShareViewController *)navController.topViewController;
        vc.imageURL = [_arrSurprise.photo objectAtIndex:share_row];
    }
}
- (IBAction)searchClicked:(id)sender {
    
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SearchViewController * controller = (SearchViewController *)[storyboard instantiateViewControllerWithIdentifier:@"searchview"];
    [self presentViewController:controller animated:NO completion:nil];
}
- (IBAction)contactClicked:(id)sender {
    [[self navigationController] popViewControllerAnimated:YES];
}
- (IBAction)barcodeClicked:(id)sender {
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ScanController * controller = (ScanController *)[storyboard instantiateViewControllerWithIdentifier:@"barcodeview"];
    [self presentViewController:controller animated:NO completion:nil];
}


@end
