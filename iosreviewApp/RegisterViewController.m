//
//  RegisterViewController.m
//  iosreviewApp
//
//  Created by star on 5/23/17.
//  Copyright © 2017 star. All rights reserved.
//

#import "RegisterViewController.h"

#import <AFNetworking.h>
#import "ServerAPIPath.h"

#import "utility.h"
#import "AppDelegate.h"
@interface RegisterViewController ()

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)register:(id)sender {
    if([_firstname.text isEqualToString:@""]) {
        [utility alertDialog:NSLocalizedString(@"first name is empty", @"")];
        return;
    }
    
    if([_lastname.text isEqualToString:@""]) {
        [utility alertDialog:NSLocalizedString(@"last name is empty", @"")];
        return;
    }
    
    if([_email.text isEqualToString:@""]) {
        [utility alertDialog:NSLocalizedString(@"please your email is empty", @"")];
        return;
    }
    
    if([utility isValidEmail:_email.text]) {
        [utility alertDialog:NSLocalizedString(@"please type correct email", @"")];
        return;
    }
    
    if([_password.text isEqualToString:@""]) {
        [utility alertDialog:NSLocalizedString(@"please type password", @"")];
        return;
    }
    
    if(![_password.text isEqualToString:_confirmpassword.text]) {
        [utility alertDialog:NSLocalizedString(@"please type password again", @"")];
        return;
    }
    
    if([_phonenumber.text isEqualToString:@""]) {
        [utility alertDialog:NSLocalizedString(@"please type phone number", @"")];
        return;
    }
    
    [utility showProgressDialog:self];
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:API_POST_REGISTERATION, @"url",
                                @"mobile",@"type",
                                @"connect",@"custom",
                                _password.text, @"password",
                                _email.text,@"emailID",
                                _firstname.text, @"fst_name",
                                _lastname.text, @"last_name",
                                _phonenumber.text, @"phone",
                                @"iphone",@"device_type",
                                @"testing_abc", @"device_token",
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
                 [self performSegueWithIdentifier:@"registerSegue" sender:nil];
                [utility alertDialog:NSLocalizedString(@"You are registered", @"")];
                
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
