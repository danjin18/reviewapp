//
//  SettingReviewTableViewCell.h
//  iosreviewApp
//
//  Created by dan jin on 5/31/17.
//  Copyright © 2017 star. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HCSStarRatingView.h"

@interface SettingReviewTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *product_name;
@property (weak, nonatomic) IBOutlet UILabel *product_review;
@property (weak, nonatomic) IBOutlet UILabel *reviwcnt;
@property (weak, nonatomic) IBOutlet HCSStarRatingView *product_rate;
@property (weak, nonatomic) IBOutlet UIImageView *product_photo;

-(void)setNameCell:(NSString *)name;
-(void)setReviewCell:(NSString *)review;
-(void)setPhotoCell:(NSString *)photoURL;
-(void)setRateCell:(NSString *)rate;
-(void)setcountCell:(NSString *)count;

@end
