//
//  MyFriendTableViewCell.m
//  iosreviewApp
//
//  Created by dan jin on 5/31/17.
//  Copyright © 2017 star. All rights reserved.
//

#import "MyFriendTableViewCell.h"
#import "UIImageView+AFNetworking.h"

@implementation MyFriendTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.user_photo.layer.cornerRadius = self.user_photo.frame.size.width / 2;
    self.user_photo.clipsToBounds = YES;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setNameCell:(NSString *)name
{
    _user_name.text = name;
}

-(void)setPhotoCell:(NSString *)photoURL
{
    if((photoURL == nil) || ([photoURL isEqualToString:@""]))
        return;
    _user_photo.image = nil;
    NSURL *url = [NSURL URLWithString:photoURL];
    [_user_photo setImageWithURL:url];
}

-(void)setFollowCell:(NSString *)follow
{
    if([follow isEqualToString:@"1"])
        _followImage.image = [UIImage imageNamed: @"user2.png"];
    else
        _followImage.image = [UIImage imageNamed: @"user1.png"];
        
}
@end
