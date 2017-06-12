//
//  PromotionTableViewCell.m
//  iosreviewApp
//
//  Created by dan jin on 6/1/17.
//  Copyright © 2017 star. All rights reserved.
//

#import "PromotionTableViewCell.h"
#import "UIImageView+AFNetworking.h"

@implementation PromotionTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setPhotoCell:(NSString *)photo
{
    _photo.image = nil;
    NSURL *url = [NSURL URLWithString:photo];
    [_photo setImageWithURL:url];
}
-(void)setTitleCell:(NSString *)title
{
    _title.text = title;
}
-(void)setStartDateCell:(NSString *)startdate
{
    _start_date.text = startdate;
}
-(void)setEndDateCell:(NSString *)enddate
{
    _end_date.text = enddate;
}
-(void)setCouponCell:(NSString *)other
{
    _others.text = [NSString stringWithFormat:@"percent: %@%%", other];
}
-(void)setFreestuffCell:(NSString *)other
{
    _others.text = [NSString stringWithFormat:@"count: %@", other];
}
-(void)setLimitedtimeCell:(NSString *)other
{
    _others.text = [NSString stringWithFormat:@"time: %@%%", other];
}
@end
