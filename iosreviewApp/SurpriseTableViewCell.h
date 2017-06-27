//
//  SurpriseTableViewCell.h
//  iosreviewApp
//
//  Created by dan jin on 6/2/17.
//  Copyright © 2017 star. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SurpriseTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UIImageView *photo;
@property (weak, nonatomic) IBOutlet UILabel *expiry;
@property (weak, nonatomic) IBOutlet UILabel *review;
@property (weak, nonatomic) IBOutlet UIButton *redeemBtn;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
@property (weak, nonatomic) IBOutlet UIButton *redeemedBtn;

-(void)setPhotoCell:(NSString *)photoURL;
-(void)setTitleCell:(NSString *)title;
-(void)setExpiryCell:(NSString *)expiry;
-(void)setReviewCell:(NSString *)review;
-(void)setRedeemed:(NSString *)status;
@end
