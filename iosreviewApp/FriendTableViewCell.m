//
//  FriendTableViewCell.m
//  iosreviewApp
//
//  Created by ymamsMacOSX on 6/27/17.
//  Copyright © 2017 star. All rights reserved.
//

#import "FriendTableViewCell.h"
#import "UIImageView+AFNetworking.h"

@implementation FriendTableViewCell

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
    if((photoURL == nil) || ([photoURL isEqualToString:@""]))
        return;
    _user_photo.image = nil;
    NSURL *url = [NSURL URLWithString:photoURL];
    [_user_photo setImageWithURL:url];
}
-(void)setNameCell:(NSString *)name
{
    _user_name.text = name;
}
-(void)setIdCell:(NSString *)id
{
    _user_id.text = id;
}
-(void)setFollowCell:(NSString *)follow
{
    if([follow isEqualToString:@"Rejected"])
        _user_follow.image = [UIImage imageNamed: @"user1.png"];
    else
        _user_follow.image = [UIImage imageNamed: @"user2.png"];
}
-(void)setPhoneCell:(NSString *)phone
{
    _user_phone.text = phone;
}
@end
