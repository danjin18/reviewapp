//
//  MenuProfileTableViewCell.h
//  iosreviewApp
//
//  Created by dan jin on 6/2/17.
//  Copyright © 2017 star. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuProfileTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *userphoto;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UILabel *userpoint;

@end
