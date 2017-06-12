//
//  PromotionTableViewCell.h
//  iosreviewApp
//
//  Created by dan jin on 6/1/17.
//  Copyright © 2017 star. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PromotionTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *photo;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *start_date;
@property (weak, nonatomic) IBOutlet UILabel *end_date;
@property (weak, nonatomic) IBOutlet UILabel *others;

-(void)setPhotoCell:(NSString *)photo;
-(void)setTitleCell:(NSString *)title;
-(void)setStartDateCell:(NSString *)startdate;
-(void)setEndDateCell:(NSString *)enddate;
-(void)setCouponCell:(NSString *)other;
-(void)setFreestuffCell:(NSString *)other;
-(void)setLimitedtimeCell:(NSString *)other;
@end
