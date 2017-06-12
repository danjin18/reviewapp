//
//  HistoryTableViewCell.m
//  iosreviewApp
//
//  Created by dan jin on 6/2/17.
//  Copyright © 2017 star. All rights reserved.
//

#import "HistoryTableViewCell.h"
#import "UIImageView+AFNetworking.h"

@implementation HistoryTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)setPhotoCell:(NSString *)photoURL
{
    _image.image = nil;
    NSURL *url = [NSURL URLWithString:photoURL];
    [_image setImageWithURL:url];
}
-(void)setTitleCell:(NSString *)title
{
    _title.text = title;
}
-(void)setExpiryCell:(NSString *)expiry
{
    _expiry.text = expiry;
}
-(void)setReviewCell:(NSString *)review
{
    _review.text = [NSString stringWithFormat:@"%@  %@", _review.text, review];
}

@end
