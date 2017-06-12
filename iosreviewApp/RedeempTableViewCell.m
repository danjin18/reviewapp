//
//  RedeempTableViewCell.m
//  iosreviewApp
//
//  Created by dan jin on 6/1/17.
//  Copyright © 2017 star. All rights reserved.
//

#import "RedeempTableViewCell.h"
#import "UIImageView+AFNetworking.h"

@implementation RedeempTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setPointCell:(NSString *)points
{
    _point.text = [NSString stringWithFormat:@"%@ points", points];
}
-(void)setPhotoCell:(NSString *)photoURL
{
    _photo.image = nil;
    NSURL *url = [NSURL URLWithString:photoURL];
    [_photo setImageWithURL:url];
}

@end
