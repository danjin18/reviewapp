//
//  SendReviewViewController.h
//  iosreviewApp
//
//  Created by dan jin on 6/4/17.
//  Copyright © 2017 star. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "HCSStarRatingView.h"

@interface SendReviewViewController : UIViewController
@property (weak, nonatomic) IBOutlet HCSStarRatingView *rate;
@property (weak, nonatomic) IBOutlet UIImageView *upload_photo;
@property (weak, nonatomic) IBOutlet UITextField *comment;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *rightbarButton;

@end
