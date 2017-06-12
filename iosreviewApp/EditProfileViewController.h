//
//  EditProfileViewController.h
//  iosreviewApp
//
//  Created by dan jin on 5/28/17.
//  Copyright © 2017 star. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "productModel.h"
#import "CommentModel.h"
#import "myReviewModel.h"

@interface EditProfileViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *user_photo;

@property (weak, nonatomic) IBOutlet UILabel *first_name;
@property (weak, nonatomic) IBOutlet UILabel *last_name;
@property (weak, nonatomic) IBOutlet UILabel *reviewCnt;
@property (weak, nonatomic) IBOutlet UILabel *pointCnt;
@property (weak, nonatomic) IBOutlet UILabel *friendCnt;
@property (weak, nonatomic) IBOutlet UIView *reviewTable;
@property (weak, nonatomic) IBOutlet UIView *commentTable;
@property (weak, nonatomic) IBOutlet UIView *editorpickTable;
@property (weak, nonatomic) IBOutlet UIView *friendTable;
@property (weak, nonatomic) IBOutlet UIView *reviewView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *rightbarButton;

@property (nonatomic, retain) myReviewModel *reviewModel;
@property (nonatomic, retain) CommentModel *commentModel;
@property (nonatomic, retain) productModel *editorPickerModel;
@end
