//
//  MyEditorPickViewController.h
//  iosreviewApp
//
//  Created by dan jin on 5/29/17.
//  Copyright © 2017 star. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "productModel.h"

@interface MyEditorPickViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *myTable;

@property (nonatomic, retain) productModel *productModel;
@property (nonatomic, retain) NSString *userid;

@end
