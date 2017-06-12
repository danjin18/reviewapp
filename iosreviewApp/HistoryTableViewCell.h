//
//  HistoryTableViewCell.h
//  iosreviewApp
//
//  Created by dan jin on 6/2/17.
//  Copyright © 2017 star. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HistoryTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *expiry;
@property (weak, nonatomic) IBOutlet UILabel *review;

-(void)setPhotoCell:(NSString *)photoURL;
-(void)setTitleCell:(NSString *)title;
-(void)setExpiryCell:(NSString *)expiry;
-(void)setReviewCell:(NSString *)review;

@end
