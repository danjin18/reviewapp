//
//  RecentProductTableViewCell.m
//  iosreviewApp
//
//  Created by ymamsMacOSX on 6/27/17.
//  Copyright © 2017 star. All rights reserved.
//

#import "RecentProductTableViewCell.h"
#import "UIImageView+AFNetworking.h"

@implementation RecentProductTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)setTitleCell:(NSString *)title
{
    _product_title.text = title;
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
-(void)setReviewCell:(NSString *)review
{
    _product_review.text = review;
}
-(void)setSaleCell:(NSString *)sale_price
{
    _product_price.text = [NSString stringWithFormat:@"$%@", sale_price];
}

@end
