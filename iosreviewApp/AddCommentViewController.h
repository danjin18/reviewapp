//
//  AddCommentViewController.h
//  iosreviewApp
//
//  Created by dan jin on 6/19/17.
//  Copyright © 2017 star. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentModel.h"

@interface AddCommentViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *rightbarButton;
@property (weak, nonatomic) IBOutlet UITableView *commentTable;
@property (weak, nonatomic) IBOutlet UITextView *commentText;

@property (nonatomic, retain) CommentModel *commentModel;
@property (nonatomic, retain) NSString *commentCount;
@property (nonatomic, retain) NSString *reviewID;
@property (nonatomic, retain) NSString *productID;

@end
