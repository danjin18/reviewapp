//
//  SubProductViewController.h
//  iosreviewApp
//
//  Created by star on 5/24/17.
//  Copyright © 2017 star. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "productModel.h"
#import "FYComboBox.h"

@interface SubProductViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) NSString *category_id;
@property (weak, nonatomic) IBOutlet UITableView *productTable;
@property (weak, nonatomic) IBOutlet FYComboBox *sortingBtn;
@property (weak, nonatomic) IBOutlet UILabel *sortLabel;

@property (nonatomic, retain) productModel *productModel;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *rightbarButton;

@end
