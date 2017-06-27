//
//  FriendTableViewCell.h
//  iosreviewApp
//
//  Created by ymamsMacOSX on 6/27/17.
//  Copyright © 2017 star. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FriendTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *user_photo;
@property (weak, nonatomic) IBOutlet UILabel *user_name;
@property (weak, nonatomic) IBOutlet UILabel *user_id;
@property (weak, nonatomic) IBOutlet UILabel *user_phone;
@property (weak, nonatomic) IBOutlet UIImageView *user_follow;

-(void)setPhotoCell:(NSString *)photoURL;
-(void)setNameCell:(NSString *)name;
-(void)setIdCell:(NSString *)id;
-(void)setFollowCell:(NSString *)follow;
-(void)setPhoneCell:(NSString *)phone;

@end
