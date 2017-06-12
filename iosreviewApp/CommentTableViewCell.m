//
//  CommentTableViewCell.m
//  iosreviewApp
//
//  Created by dan jin on 5/29/17.
//  Copyright © 2017 star. All rights reserved.
//

#import "CommentTableViewCell.h"
#import "UIImageView+AFNetworking.h"
@implementation CommentTableViewCell


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setTitleCell:(NSString *)title
{
    _title.text = title;
}
-(void)setPhotoCell:(NSString *)photoURL
{
    _photo.image = nil;
    NSURL *url = [NSURL URLWithString:photoURL];
    [_photo setImageWithURL:url];
}

-(void)setCommentCell:(NSString *)comment
{
    _comment.text = comment;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
