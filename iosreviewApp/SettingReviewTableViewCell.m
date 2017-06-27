//
//  SettingReviewTableViewCell.m
//  iosreviewApp
//
//  Created by dan jin on 5/31/17.
//  Copyright © 2017 star. All rights reserved.
//

#import "SettingReviewTableViewCell.h"
#import "UIImageView+AFNetworking.h"

@implementation SettingReviewTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setNameCell:(NSString *)name
{
    _product_name.text = name;
}
-(void)setReviewCell:(NSString *)review
{
    _product_review.text = review;
}
-(void)setPhotoCell:(NSString *)photoURL
{
    if((photoURL == nil) || ([photoURL isEqualToString:@""]))
        return;
    _product_photo.image = nil;
    NSURL *url = [NSURL URLWithString:photoURL];
    [_product_photo setImageWithURL:url];
}
-(void)setRateCell:(NSString *)rate
{
    NSString *curRate;
    
    if ([rate isEqual:[NSNull null]])
        curRate = @"0";
    else
        curRate = rate;
    CGFloat strRate = (CGFloat)[curRate floatValue];
    
    [_product_rate setValue:strRate];
    [_product_rate setEnabled:false];
}
-(void)setcountCell:(NSString *)count
{
    _reviwcnt.text = count;
}
@end
