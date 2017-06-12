//
//  ProductDetailViewController.h
//  iosreviewApp
//
//  Created by star on 5/26/17.
//  Copyright © 2017 star. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HCSStarRatingView.h"
#import "reviewDetailModel.h"
#import "productModel.h"

@interface ProductDetailViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *product_name;
@property (weak, nonatomic) IBOutlet UIImageView *product_photo;
@property (weak, nonatomic) IBOutlet HCSStarRatingView *product_rate;
@property (weak, nonatomic) IBOutlet UITableView *product_reviewTable;
@property (weak, nonatomic) IBOutlet UITextView *infoTextView;
@property (weak, nonatomic) IBOutlet UITableView *product_recommendTable;
@property (weak, nonatomic) IBOutlet UILabel *reviewCount;
@property (weak, nonatomic) IBOutlet UIButton *reviewBtn;
@property (weak, nonatomic) IBOutlet UIButton *recommendBtn;
@property (weak, nonatomic) IBOutlet UIButton *infoBtn;

@property (nonatomic, retain) NSString *product_id;
@property (nonatomic, retain) NSString *category_id;
@property (nonatomic, retain) NSString *product_title;
@property (nonatomic, retain) NSString *product_rateval;
@property (nonatomic, retain) NSString *product_photoval;
@property (nonatomic, retain) NSString *review_count;

@property (nonatomic, retain) reviewDetailModel *reviewDetailModel;
@property (nonatomic, retain) productModel *productModel;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *rightbarButton;

@end
