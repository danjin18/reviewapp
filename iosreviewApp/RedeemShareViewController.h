//
//  RedeemShareViewController.h
//  iosreviewApp
//
//  Created by dan jin on 6/2/17.
//  Copyright © 2017 star. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <FBSDKLoginKit/FBSDKLoginKit.h>

#import <FBSDKShareKit/FBSDKShareKit.h>

@interface RedeemShareViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *rightbarButton;
@property (weak, nonatomic) IBOutlet FBSDKLoginButton *loginButton;

@property (nonatomic, retain) NSString *imageURL;
@property (nonatomic, retain) NSString *text;
@property (weak, nonatomic) IBOutlet UIImageView *shareImage;

@end
