//
//  ExternalLinkViewController.m
//  iosreviewApp
//
//  Created by dan jin on 6/8/17.
//  Copyright © 2017 star. All rights reserved.
//

#import "ExternalLinkViewController.h"

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

@interface ExternalLinkViewController ()
{
    Preference *pref;
    
    NSTimer *timer;
    int countTime;
    int currentPosition;
}
@end

@implementation ExternalLinkViewController

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
    
    countTime = 0;
    [self startTimer];
    
    NSString *urlString = [_site objectAtIndex:_curPos];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [_website loadRequest:urlRequest];
    
    currentPosition = (int)_curPos;
}
-(void)sendStayTime
{
    [utility showProgressDialog:self];
    
    
    NSURL *URL = [NSURL URLWithString:API_POST_ADD_CLICK];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:[pref getSharedPreference:nil :PREF_PARAM_USER_ID :@""], @"user_id",
                                URL, @"url",
                                _product_id, @"product_id",
                                [NSString stringWithFormat:@"%d", countTime], @"duration",
                                nil];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST:URL.absoluteString parameters:parameters progress:nil success:^(NSURLSessionDataTask * task, id  responseObject) {
        
        [utility hideProgressDialog];
        if (responseObject == nil) {
            return;
        }
        else {
            countTime = 0;
        }
        
        
    } failure:^(NSURLSessionDataTask  *task, NSError  *error) {
        
        [utility hideProgressDialog];
        [[AppDelegate sharedAppDelegate] showToastMessage:error.localizedDescription];
        
    }];
}

- (IBAction)backBtn:(id)sender {
    if(currentPosition == 0)
    {
        return;
    }
    else
        currentPosition--;
    
    NSString *urlString = [_site objectAtIndex:currentPosition];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [_website loadRequest:urlRequest];
}
- (IBAction)forwardBtn:(id)sender {
    if([_site count] <= (currentPosition + 1))
    {
        return;
    }
    else
        currentPosition++;
    NSString *urlString = [_site objectAtIndex:currentPosition];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [_website loadRequest:urlRequest];
}
- (IBAction)exitBtn:(id)sender {
    
    if(countTime >= 45)
    {
        [self sendStayTime];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)startTimer
{
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                             target:self
                                           selector:@selector(counterTimer)
                                           userInfo:nil
                                            repeats:YES];
}

-(void)counterTimer
{
    countTime++;
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.

}


@end
