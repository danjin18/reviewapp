//
//  SendReviewViewController.h
//  iosreviewApp
//
//  Created by dan jin on 6/4/17.
//  Copyright © 2017 star. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "HCSStarRatingView.h"
#import "RadioButton.h"

@interface SendReviewViewController : UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet HCSStarRatingView *rate;
@property (weak, nonatomic) IBOutlet UIImageView *upload_photo;
@property (weak, nonatomic) IBOutlet UITextField *comment;
@property (nonatomic, retain) NSString *product_id;
@property (weak, nonatomic) IBOutlet RadioButton *yesBtn;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *rightbarButton;

@end
