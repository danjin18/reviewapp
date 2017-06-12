//
//  NotificationViewController.m
//  iosreviewApp
//
//  Created by star on 5/24/17.
//  Copyright © 2017 star. All rights reserved.
//

#import "NotificationViewController.h"
#import "UICheckbox.h"

#import "Preference.h"
#import "Constants.h"

#import <AFNetworking.h>
#import "ServerAPIPath.h"

#import "utility.h"
#import "AppDelegate.h"

#import "SWRevealViewController.h"

#import "ContactViewController.h"
#import "SearchViewController.h"
#import "ScanController.h"
@interface NotificationViewController ()
{
    NSString *friend_checked;
    NSString *product_checked;
    NSString *surprise_checked;
    
    Preference *pref;
    
}
@end

@implementation NotificationViewController

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
    
    
    _FollowFriend.checked = true;
    _FollowFriend.disabled = false;
    _FollowFriend.text = @"Follow Friends";
    
    _product.checked = true;
    _product.disabled = false;
    _product.text = @"Product Notification";
    
    _surprise.checked = true;
    _surprise.disabled = false;
    _surprise.text = @"Daily Surprised";
    
    pref = [Preference getInstance];
    
    UITapGestureRecognizer *followFriendTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(followFriendTap:)];
    [self.FollowFriend addGestureRecognizer:followFriendTap];
    
    UITapGestureRecognizer *productTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(productTap:)];
    [self.FollowFriend addGestureRecognizer:productTap];
    
    UITapGestureRecognizer *surprisedTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(surpriseTap:)];
    [self.FollowFriend addGestureRecognizer:surprisedTap];
    

}
//The event handling method
- (void)followFriendTap:(UITapGestureRecognizer *)recognizer
{
    if(_FollowFriend.checked)
        friend_checked = @"1";
    else
        friend_checked = @"0";
    
    [self sendInfo];
    //Do stuff here...
}
- (void)productTap:(UITapGestureRecognizer *)recognizer
{
    if(_product.checked) {
        product_checked = @"1";
    }
    else
        product_checked = @"0";
    
    [self sendInfo];
}
- (void)surpriseTap:(UITapGestureRecognizer *)recognizer
{
    if(_surprise.checked) {
        surprise_checked = @"1";
    }
    else
        surprise_checked = @"0";
    
    [self sendInfo];
}

-(void)sendInfo {
    [utility showProgressDialog:self];
    
    NSURL *URL = [NSURL URLWithString:API_POST_EDIT_NOTIFICATION];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:[pref getSharedPreference:nil :PREF_PARAM_USER_ID :@""],@"userId",
                                friend_checked, @"follow_friends",
                                product_checked, @"product_notification",
                                surprise_checked, @"daily_surprised",
                                @"0", @"newsletter",
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
            if(json == nil) {
                [[AppDelegate sharedAppDelegate] showToastMessage:@"request failed"];
            }
        }
        
        
    } failure:^(NSURLSessionDataTask  *task, NSError  *error) {
        
        [utility hideProgressDialog];
        [[AppDelegate sharedAppDelegate] showToastMessage:error.localizedDescription];
        
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
