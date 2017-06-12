//
//  categoryTableViewCell.h
//  iosreviewApp
//
//  Created by star on 5/22/17.
//  Copyright © 2017 star. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HCSStarRatingView.h"
@interface categoryTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet HCSStarRatingView *ratevalue;
@property (weak, nonatomic) IBOutlet UILabel *count;
@property (weak, nonatomic) IBOutlet UIImageView *category_image;

-(void)setTitleCell:(NSString *)title;
-(void)setCategory_imageCell:(NSString *)photoUrl;
-(void)setRatevalueCell:(NSString *)ratevalue;
-(void)setCountCell:(NSString *)count;
@end
