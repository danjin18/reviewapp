//
//  ReviewDetailTableViewCell.h
//  iosreviewApp
//
//  Created by star on 5/26/17.
//  Copyright © 2017 star. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HCSStarRatingView.h"

@interface ReviewDetailTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *product_photo;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *poing;
@property (weak, nonatomic) IBOutlet UILabel *product_description;
@property (weak, nonatomic) IBOutlet UILabel *LikeCount;
@property (weak, nonatomic) IBOutlet UILabel *CommentCount;
@property (weak, nonatomic) IBOutlet UILabel *DislikeCount;
@property (weak, nonatomic) IBOutlet UILabel *ImageCount;
@property (weak, nonatomic) IBOutlet HCSStarRatingView *rate;
@property (weak, nonatomic) IBOutlet UIButton *LikeBtn;
@property (weak, nonatomic) IBOutlet UIButton *DislikeBtn;
@property (weak, nonatomic) IBOutlet UIButton *CommentBtn;
@property (weak, nonatomic) IBOutlet UIButton *ImageBtn;

-(void)setProductPhotoCell:(NSString *)photoURL;
-(void)setNameCell:(NSString *)name;
-(void)setPointCell:(NSString *)point;
-(void)setDescriptionCell:(NSString *)description;
-(void)setLikeCountCell:(NSString *)LikeCount;
-(void)setCommentCountCell:(NSString *)CommentCount;
-(void)setDislikeCountCell:(NSString *)DislikeCount;
-(void)setImageCountCell:(NSString *)ImageCount;
-(void)setRateCell:(NSString *)rate;

@end
