//
//  ForgetViewController.m
//  iosreviewApp
//
//  Created by star on 5/19/17.
//  Copyright © 2017 star. All rights reserved.
//

#import "ForgetViewController.h"

#import <AFNetworking.h>
#import "ServerAPIPath.h"

#import "utility.h"
#import "AppDelegate.h"

@interface ForgetViewController ()

@end

@implementation ForgetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [_email setLeftViewMode:UITextFieldViewModeAlways];
    _email.leftView= [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"leftusername.png"]];
}
- (IBAction)next:(id)sender {
    if(![utility isValidEmail:_email.text]) {
        [utility alertDialog:NSLocalizedString(@"please type your email", @"")];
        return;
    }
    
    [utility showProgressDialog:self];
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:  API_POST_FORGOT_PASSWORD, @"url",
                                @"mobile",@"type",
                                _email.text,@"emailID",
                                nil];
    
    NSURL *URL = [NSURL URLWithString:API_POST_REGISTERATION];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST:URL.absoluteString parameters:parameters progress:nil success:^(NSURLSessionDataTask * task, id  responseObject) {
        
        [utility hideProgressDialog];
        if (responseObject != nil) {
            NSError *error = nil;
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];
            
            if([json objectForKey:@"status"]) {
                [[AppDelegate sharedAppDelegate] showToastMessage:NSLocalizedString(@"success", @"")];
                
                UINavigationController *navigationController = self.navigationController;
                [navigationController popViewControllerAnimated:YES];
            }
            else {
                [[AppDelegate sharedAppDelegate] showToastMessage:NSLocalizedString(@"request failed", @"")];
            }
            
        }
        
    } failure:^(NSURLSessionDataTask  *task, NSError  *error) {
        [utility hideProgressDialog];
        [[AppDelegate sharedAppDelegate] showToastMessage:error.localizedDescription];
        
    }];
}
- (IBAction)calcelClicked:(id)sender {
    UINavigationController *navigationController = self.navigationController;
    [navigationController popViewControllerAnimated:YES];
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
