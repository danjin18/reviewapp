//
//  PriceDialogViewController.h
//  iosreviewApp
//
//  Created by star on 5/25/17.
//  Copyright © 2017 star. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PriceDialogViewController;
@protocol AddrCellDelegate <NSObject>
//- (void) FromAddrDialog: (PriceDialogViewController *)vc didClickAddrCell:(AddrModel*) model;
@end

@interface PriceDialogViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *price_table;
@property (weak, nonatomic) IBOutlet UIButton *close_btn;

@property (nonatomic,weak) id <AddrCellDelegate> delegate;
@end
