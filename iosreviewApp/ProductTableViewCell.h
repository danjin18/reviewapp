//
//  ProductTableViewCell.h
//  iosreviewApp
//
//  Created by star on 5/24/17.
//  Copyright © 2017 star. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HCSStarRatingView.h"

@interface ProductTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *product_photo;
@property (weak, nonatomic) IBOutlet UILabel *product_title;
@property (weak, nonatomic) IBOutlet HCSStarRatingView *product_rate;
@property (weak, nonatomic) IBOutlet UILabel *count;
@property (weak, nonatomic) IBOutlet UIButton *buyOnline;
@property (weak, nonatomic) IBOutlet UIButton *buyStore;

-(void)setTitleCell:(NSString *)title;
-(void)setPhotoCell:(NSString *)photURL;
-(void)setRateCell:(NSString *)rate;
-(void)setcountCell:(NSString *)reviewCount;
-(void)setSaleCell:(NSString *)sale_price;

@end
