//
//  PriceAlertDialogViewController.h
//  iosreviewApp
//
//  Created by star on 5/25/17.
//  Copyright © 2017 star. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PriceAlertDialogViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *store;
@property (weak, nonatomic) IBOutlet UILabel *price;

@property (nonatomic, retain) NSMutableArray *pricevalue;
@property (nonatomic, retain) NSMutableArray *site;
@property (nonatomic, retain) NSMutableArray *product;

@property (nonatomic, retain) NSString *product_id;
@property (nonatomic, retain) NSString *selStore;

@property (weak, nonatomic) IBOutlet UITableView *priceTable;
@property (weak, nonatomic) IBOutlet UILabel *notFoundLabel;
@property (weak, nonatomic) IBOutlet UIView *noProductView;
@property (weak, nonatomic) IBOutlet UIView *alertView;


@end
