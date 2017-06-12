//
//  MyReviewDetailViewController.h
//  iosreviewApp
//
//  Created by dan jin on 5/28/17.
//  Copyright © 2017 star. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HCSStarRatingView.h"
#import "RadioButton.h"
@interface MyReviewDetailViewController : UIViewController
@property (weak, nonatomic) IBOutlet HCSStarRatingView *rate;

@property (weak, nonatomic) IBOutlet UIImageView *photo;
@property (weak, nonatomic) IBOutlet UILabel *photo_label;
@property (weak, nonatomic) IBOutlet RadioButton *yesButton;
@property (weak, nonatomic) IBOutlet RadioButton *noButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *contactButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *searchButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *barcodeButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *rightbarButton;

@property (nonatomic, retain) NSString *product_id;
@property (nonatomic, retain) NSString *review;
@property (nonatomic, retain) NSString *product_photo;


@end
