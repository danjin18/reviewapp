//
//  ReviewTableViewCell.m
//  iosreviewApp
//
//  Created by dan jin on 5/30/17.
//  Copyright © 2017 star. All rights reserved.
//

#import "ReviewTableViewCell.h"
#import "UIImageView+AFNetworking.h"

@implementation ReviewTableViewCell

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
-(void)setcountCell:(NSString *)reviewCount
{
    _count.text = reviewCount;
}
-(void)setSaleCell:(NSString *)sale_price
{
    NSString *title = [NSString stringWithFormat:@"$%@ Buy Online >", sale_price];
    [_buyOnline setTitle:title forState:UIControlStateNormal];
}

@end
