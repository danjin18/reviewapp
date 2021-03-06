//
//  RedeemDetailViewController.h
//  iosreviewApp
//
//  Created by dan jin on 6/2/17.
//  Copyright © 2017 star. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CircularProgressTimer.h"
@import GoogleMobileAds;

@interface RedeemDetailViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIBarButtonItem *rightbarButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;

@property (weak, nonatomic) IBOutlet GADBannerView *bannerView;

@property (nonatomic, retain) NSString *sid;

@end
