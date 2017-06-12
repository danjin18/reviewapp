//
//  MyEditProfileViewController.m
//  iosreviewApp
//
//  Created by dan jin on 5/29/17.
//  Copyright © 2017 star. All rights reserved.
//

#import "MyEditProfileViewController.h"

#import "Preference.h"
#import "Constants.h"

#import <AFNetworking.h>
#import "UIImageView+AFNetworking.h"
#import "ServerAPIPath.h"

#import "utility.h"
#import "AppDelegate.h"
#import "SWRevealViewController.h"

@interface MyEditProfileViewController ()
{
    Preference *pref;
}
@end

@implementation MyEditProfileViewController

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
    [self initialText];
}

- (IBAction)editprofileClicked:(id)sender {
    [utility showProgressDialog:self];
    
    
    NSURL *URL = [NSURL URLWithString:API_POST_EDIT_PROFILE];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:[pref getSharedPreference:nil :PREF_PARAM_USER_ID :@""], @"user_id",
                                _firstname.text, @"firstname",
                                _lastname.text, @"lastname",
                                _phonenumber.text, @"phone",
                                _age.text, @"age",
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
            if([json objectForKey:@"status"]) {
                @try {
                    [pref putSharedPreference:nil :PREF_PARAM_USER_FIRSTNAME:_firstname.text];
                    [pref putSharedPreference:nil :PREF_PARAM_USER_LASTNAME:_lastname.text];
//                    [pref putSharedPreference:nil :PREF_PARAM_USER_IMAGE :[userinfo objectForKey:@"user_image"]];
                    [pref putSharedPreference:nil :PREF_PARAM_USER_AGE :_age.text];
                    [pref putSharedPreference:nil :PREF_PARAM_USER_PHONE :_phonenumber.text];
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

-(void)initialText
{
    _firstname.text = [pref getSharedPreference:nil :PREF_PARAM_USER_FIRSTNAME :@""];
    _lastname.text = [pref getSharedPreference:nil :PREF_PARAM_USER_LASTNAME :@""];
    _email.text = [pref getSharedPreference:nil :PREF_PARAM_USER_EMAIL :@""];
    _phonenumber.text = [pref getSharedPreference:nil :PREF_PARAM_USER_PHONE :@""];
    _age.text = [pref getSharedPreference:nil :PREF_PARAM_USER_AGE :@""];
    
    _user_photo.image = nil;
    NSURL *url = [NSURL URLWithString:[pref getSharedPreference:nil :PREF_PARAM_USER_IMAGE :@""]];
    [_user_photo setImageWithURL:url];
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
