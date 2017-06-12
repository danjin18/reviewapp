//
//  MenuProfileTableViewCell.m
//  iosreviewApp
//
//  Created by dan jin on 6/2/17.
//  Copyright © 2017 star. All rights reserved.
//

#import "MenuProfileTableViewCell.h"
#import "Preference.h"
#import "Constants.h"
#import "UIImageView+AFNetworking.h"

@implementation MenuProfileTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    Preference *pref;
     pref = [Preference getInstance];
    
    self.userphoto.layer.cornerRadius = self.userphoto.frame.size.width / 2;
    self.userphoto.clipsToBounds = YES;

    self.username.text = [pref getSharedPreference:nil :PREF_PARAM_USER_NAME :@""];
    _userpoint.text = [NSString stringWithFormat:@"%@ POINTS", [pref getSharedPreference:nil :PREF_PARAM_USER_POINT :@""]];
    
    _userphoto.image = nil;
    NSURL *url = [NSURL URLWithString:[pref getSharedPreference:nil :PREF_PARAM_USER_IMAGE :@""]];
    [_userphoto setImageWithURL:url];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
