//
//  ReviewDetailTableViewCell.m
//  iosreviewApp
//
//  Created by star on 5/26/17.
//  Copyright © 2017 star. All rights reserved.
//

#import "ReviewDetailTableViewCell.h"
#import "UIImageView+AFNetworking.h"

@implementation ReviewDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setProductPhotoCell:(NSString *)photoURL
{
    _product_photo.image = nil;
    NSURL *url = [NSURL URLWithString:photoURL];
    [_product_photo setImageWithURL:url];
}
-(void)setNameCell:(NSString *)name
{
    _name.text = name;
}

-(void)setPointCell:(NSString *)point
{
    _poing.text = point;
}
-(void)setDescriptionCell:(NSString *)description
{
    _product_description.text = description;
}
-(void)setLikeCountCell:(NSString *)LikeCount
{
    _LikeCount.text = LikeCount;
}
-(void)setCommentCountCell:(NSString *)CommentCount
{
    _CommentCount.text = CommentCount;
}
-(void)setDislikeCountCell:(NSString *)DislikeCount
{
    _DislikeCount.text = DislikeCount;
}
-(void)setImageCountCell:(NSString *)ImageCount
{
    _ImageCount.text = ImageCount;
}
-(void)setRateCell:(NSString *)rate
{
    NSString *curRate;
    
    if ([rate isEqual:[NSNull null]])
        curRate = @"0";
    else
        curRate = rate;
    CGFloat strRate = (CGFloat)[curRate floatValue];
    
    [_rate setValue:strRate];
    [_rate setEnabled:false];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
