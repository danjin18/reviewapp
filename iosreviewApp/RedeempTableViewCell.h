//
//  RedeempTableViewCell.h
//  iosreviewApp
//
//  Created by dan jin on 6/1/17.
//  Copyright © 2017 star. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RedeempTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *photo;
@property (weak, nonatomic) IBOutlet UILabel *point;
@property (weak, nonatomic) IBOutlet UIButton *redeemp;

-(void)setPhotoCell:(NSString *)photoURL;
-(void)setPointCell:(NSString *)point;

@end
