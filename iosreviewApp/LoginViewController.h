//
//  LoginViewController.h
//  iosreviewApp
//
//  Created by star on 5/19/17.
//  Copyright © 2017 star. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
@import Firebase;
@import GoogleSignIn;

@interface LoginViewController : UIViewController<GIDSignInUIDelegate>
@property (weak, nonatomic) IBOutlet UITextField *email;

@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet GIDSignInButton *googleLoginBtn;

@property (nonatomic, retain) NSString *country;
@end
