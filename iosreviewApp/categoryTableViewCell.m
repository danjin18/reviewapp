//
//  categoryTableViewCell.m
//  iosreviewApp
//
//  Created by star on 5/22/17.
//  Copyright © 2017 star. All rights reserved.
//

#import "categoryTableViewCell.h"
#import "UIImageView+AFNetworking.h"

@implementation categoryTableViewCell

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
    _title.text = title;
}
-(void)setCategory_imageCell:(NSString *)photoUrl
{
    _category_image.image = nil;
    NSURL *url = [NSURL URLWithString:photoUrl];
    [_category_image setImageWithURL:url];
}
-(void)setRatevalueCell:(NSString *)ratevalue
{
    CGFloat strRate = (CGFloat)[ratevalue floatValue];
    
    [_ratevalue setValue:strRate];
    [_ratevalue setEnabled:false];
}
-(void)setCountCell:(NSString *)count
{
    _count.text = [NSString stringWithFormat:@"(%@)", count];
}

@end
