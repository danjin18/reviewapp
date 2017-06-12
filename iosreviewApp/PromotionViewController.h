//
//  PromotionViewController.h
//  iosreviewApp
//
//  Created by dan jin on 5/29/17.
//  Copyright © 2017 star. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PromotionViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *couponCount;
@property (weak, nonatomic) IBOutlet UILabel *FreeStuffCount;
@property (weak, nonatomic) IBOutlet UILabel *LimitedTimeCount;
@property (weak, nonatomic) IBOutlet UIView *couponView;
@property (weak, nonatomic) IBOutlet UIView *freestuffView;
@property (weak, nonatomic) IBOutlet UIView *LimitedTimeView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *rightbarButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *contactButton;

@end
