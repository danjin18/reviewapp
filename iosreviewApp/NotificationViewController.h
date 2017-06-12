//
//  NotificationViewController.h
//  iosreviewApp
//
//  Created by star on 5/24/17.
//  Copyright © 2017 star. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UICheckbox;

@interface NotificationViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *rightbarButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *contactButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *searchButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *barcodeButton;

@property (weak, nonatomic) IBOutlet UICheckbox *FollowFriend;
@property (weak, nonatomic) IBOutlet UICheckbox *product;
@property (weak, nonatomic) IBOutlet UICheckbox *surprise;

@end
