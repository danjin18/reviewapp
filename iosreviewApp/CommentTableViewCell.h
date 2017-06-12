//
//  CommentTableViewCell.h
//  iosreviewApp
//
//  Created by dan jin on 5/29/17.
//  Copyright © 2017 star. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *photo;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *comment;

-(void)setTitleCell:(NSString *)title;
-(void)setPhotoCell:(NSString *)photoURL;
-(void)setCommentCell:(NSString *)comment;

@end
