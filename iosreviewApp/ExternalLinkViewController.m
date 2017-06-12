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

@interface ExternalLinkViewController ()
{
    Preference *pref;
    
    NSTimer *timer;
    int countTime;
}
@end

@implementation ExternalLinkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    pref = [Preference getInstance];
    
    countTime = 0;
    [self startTimer];
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
}
- (IBAction)forwardBtn:(id)sender {
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
