//
//  MyFriendTableViewCell.h
//  iosreviewApp
//
//  Created by dan jin on 5/31/17.
//  Copyright © 2017 star. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyFriendTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *user_photo;

@property (weak, nonatomic) IBOutlet UILabel *user_name;

-(void)setNameCell:(NSString *)name;
-(void)setPhotoCell:(NSString *)photURL;
-(void)setFollowCell:(NSString *)follow;
@property (weak, nonatomic) IBOutlet UIImageView *followImage;

@end
