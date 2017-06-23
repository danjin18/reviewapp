//
//  LoginViewController.m
//  iosreviewApp
//
//  Created by star on 5/19/17.
//  Copyright © 2017 star. All rights reserved.
//

#import "LoginViewController.h"
#import "FacebookUtils.h"
#import "Constants.h"

#import <AFNetworking.h>
#import "ServerAPIPath.h"
#import "utility.h"
#import "AppDelegate.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UIButton *facebookLoginButton;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [self.googleLoginBtn addTarget:self action:@selector(googleButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    
    [_email setLeftViewMode:UITextFieldViewModeAlways];
    _email.leftView= [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"leftusername.png"]];
    
    [_password setLeftViewMode:UITextFieldViewModeAlways];
    _password.leftView= [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"leftpassword.png"]];
    
//    [self googleButtonPressed];
    
    /// facebook login button configuration
    [self.facebookLoginButton addTarget:self
                                 action:@selector(facebookLoginButton)
                       forControlEvents:UIControlEventTouchUpInside];
    _email.text = @"aa@a.com";
    _password.text = @"aaaaa";
    
    Preference* pref = [Preference getInstance];
    [pref removeSharedPreference];
    [pref settedLogin:FALSE];
    
    [[NSNotificationCenter defaultCenter]
        addObserver:self
        selector:@selector(receiveGoogleLogin:)
        name:@"googleLogin"
        object:nil];
    
    [GIDSignIn sharedInstance].uiDelegate = self;

}
- (void) receiveGoogleLogin:(NSNotification *) notification {
    if ([notification.name isEqualToString:@"googleLogin"]) {
        NSString *firstname = [notification.userInfo objectForKey:@"firstname"];
        NSString *lastname = [notification.userInfo objectForKey:@"lastname"];
        NSString *fullname = [notification.userInfo objectForKey:@"fullname"];
        NSString *userid = [notification.userInfo objectForKey:@"userid"];
        NSString *token = [notification.userInfo objectForKey:@"token"];
        NSString *email = [notification.userInfo objectForKey:@"email"];
        NSString *photo = [notification.userInfo objectForKey:@"photo"];
        
        Preference* pref = [Preference getInstance];
        [pref putSharedPreference:nil :PREF_PARAM_USER_FIRSTNAME:firstname];
        [pref putSharedPreference:nil :PREF_PARAM_USER_LASTNAME:lastname];
        [pref putSharedPreference:nil :PREF_PARAM_USER_IMAGE :photo];
        [pref putSharedPreference:nil :PREF_PARAM_USER_EMAIL :email];
        [pref putSharedPreference:nil :PREF_PARAM_TOKEN :token];
        
        [self siteGoogleLogin:firstname last:lastname fb_id:userid fullname:fullname email:email];
    }
}

-(void)siteGoogleLogin:(NSString *)firstname last:(NSString *)lastname fb_id:(NSString *)fbid fullname:(NSString *)fullname email:(NSString *)useremail
{
    [utility showProgressDialog:self];
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:@"mobile",@"type",
                                @"googleplus",@"connect",
                                fbid,@"g_id",
                                firstname,@"fst_name",
                                lastname, @"last_name",
                                useremail, @"emailID",
                                useremail,@"g_username",
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
                NSDictionary *info = [json objectForKey:@"Data"];
                
                NSArray *arrinfo = (NSArray *)info;
                NSDictionary *userinfo = [arrinfo objectAtIndex:0];
                
                Preference* pref = [Preference getInstance];
                
                [pref putSharedPreference:nil :PREF_PARAM_USER_ID :[userinfo objectForKey:@"id"]];
                [pref putSharedPreference:nil :PREF_PARAM_USER_POINT :[userinfo objectForKey:@"point"]];
                [pref putSharedPreference:nil :PREF_PARAM_COUNTRY :_country];
                
                [pref settedLogin:TRUE];
                
                [self performSegueWithIdentifier:@"signinSegue" sender:nil];
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

- (IBAction)facebookLoginClicked:(id)sender {
    Preference* pref = [Preference getInstance];
    [pref putSharedPreference:nil :PREF_PARAM_COUNTRY :_country];
    
    [[FacebookUtils getInstance] connectToFacebook:self];
 }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)customLogin:(id)sender {
    Preference* pref = [Preference getInstance];
    
    [utility showProgressDialog:self];
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:@"mobile",@"type",
                                @"custom",@"connect",
                                _password.text,@"password",
                                _email.text,@"emailID",
                                @"iphone",@"device_type",
                                @"", @"device_token",
                                _country, @"country",
                                nil];
    
    NSURL *URL = [NSURL URLWithString:API_POST_LOGIN];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST:URL.absoluteString parameters:parameters progress:nil success:^(NSURLSessionDataTask * task, id  responseObject) {
        
        [utility hideProgressDialog];
        if (responseObject != nil) {
            NSError *error = nil;
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];
            
            if([json objectForKey:@"status"]) {
                NSDictionary *info = [json objectForKey:@"info"];
                
                NSArray *arrinfo = (NSArray *)info;
                NSDictionary *userinfo = [arrinfo objectAtIndex:0];
                
                [pref putSharedPreference:nil :PREF_PARAM_USER_ID :[userinfo objectForKey:@"id"]];
                [pref putSharedPreference:nil :PREF_PARAM_USER_EMAIL :[userinfo objectForKey:@"emailID"]];
                [pref putSharedPreference:nil :PREF_PARAM_USER_NAME :[NSString stringWithFormat:@"%@ %@", [userinfo objectForKey:@"firstname"], [userinfo objectForKey:@"lastname"]]];
                [pref putSharedPreference:nil :PREF_PARAM_USER_FIRSTNAME:[userinfo objectForKey:@"firstname"]];
                [pref putSharedPreference:nil :PREF_PARAM_USER_LASTNAME:[userinfo objectForKey:@"lastname"]];
                [pref putSharedPreference:nil :PREF_PARAM_USER_IMAGE :[userinfo objectForKey:@"user_image"]];
                [pref putSharedPreference:nil :PREF_PARAM_USER_AGE :[userinfo objectForKey:@"age"]];
                [pref putSharedPreference:nil :PREF_PARAM_USER_PHONE :[userinfo objectForKey:@"phone"]];
                [pref putSharedPreference:nil :PREF_PARAM_USER_POINT :[userinfo objectForKey:@"point"]];
                [pref putSharedPreference:nil :PREF_PARAM_USER_PASSWORD :_password.text];
                [pref putSharedPreference:nil :PREF_PARAM_COUNTRY :_country];
                
                [pref settedLogin:TRUE];
                [self performSegueWithIdentifier:@"signinSegue" sender:nil];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
