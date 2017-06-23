//
//  MyReviewDetailViewController.m
//  iosreviewApp
//
//  Created by dan jin on 5/28/17.
//  Copyright © 2017 star. All rights reserved.
//

#import "MyReviewDetailViewController.h"

#import "Preference.h"
#import "Constants.h"

#import <AFNetworking.h>
#import "UIImageView+AFNetworking.h"
#import "ServerAPIPath.h"

#import "utility.h"
#import "AppDelegate.h"

#import "SWRevealViewController.h"

#import "ContactViewController.h"
#import "SearchViewController.h"
#import "ScanController.h"
@interface MyReviewDetailViewController ()
{
    Preference *pref;
}
@end

@implementation MyReviewDetailViewController

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
    
    _photo_label.text = _review;
    
    _photo.image = nil;
    NSURL *url = [NSURL URLWithString:_product_photo];
    [_photo setImageWithURL:url];
    
    CGFloat strRate = (CGFloat)[_ratevalue floatValue];
    
    [_rate setValue:strRate];
    
}

- (IBAction)postClicked:(id)sender {
    NSString *recommend;
    if(_yesButton.selected)
        recommend = @"YES";
    else
        recommend = @"NO";
    
    [utility showProgressDialog:self];
    
    
    NSURL *URL = [NSURL URLWithString:API_POST_ADD_REVIEWS];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:[pref getSharedPreference:nil :PREF_PARAM_USER_ID :@""], @"user_id",
                                [NSString stringWithFormat:@"%.1f", [_rate value]], @"review",
                                _photo_label.text, @"comment",
                                _product_id, @"product_id",
                                recommend, @"recommended",
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
            if(json == nil) return;
            if([json objectForKey:@"status"]) {
                @try {
                    
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
        [[AppDelegate sharedAppDelegate] showToastMessage:error.localizedDescription];
    }];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
