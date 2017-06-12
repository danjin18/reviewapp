//
//  AppDelegate.h
//  iosreviewApp
//
//  Created by star on 5/19/17.
//  Copyright © 2017 star. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
@import Firebase;
@import GoogleSignIn;

#import "MBProgressHUD.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, FIRMessagingDelegate, GIDSignInDelegate>

@property (strong, nonatomic) UIWindow *window;

-(void)showToastMessage:(NSString *)message;
+(AppDelegate *)sharedAppDelegate;

@end

