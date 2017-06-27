//
//  RecentProductTableViewCell.h
//  iosreviewApp
//
//  Created by ymamsMacOSX on 6/27/17.
//  Copyright © 2017 star. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HCSStarRatingView.h"
@interface RecentProductTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *product_photo;
@property (weak, nonatomic) IBOutlet UILabel *product_title;
@property (weak, nonatomic) IBOutlet UILabel *product_price;
@property (weak, nonatomic) IBOutlet HCSStarRatingView *product_rate;
@property (weak, nonatomic) IBOutlet UILabel *product_review;

-(void)setTitleCell:(NSString *)title;
-(void)setPhotoCell:(NSString *)photURL;
-(void)setRateCell:(NSString *)rate;
-(void)setReviewCell:(NSString *)review;
-(void)setSaleCell:(NSString *)sale_price;

@end
