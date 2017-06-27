//
//  MyReviewViewController.h
//  iosreviewApp
//
//  Created by dan jin on 5/28/17.
//  Copyright © 2017 star. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "myReviewModel.h"

@interface MyReviewViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *myTable;

@property (nonatomic, retain) myReviewModel *productModel;
@property (nonatomic, retain) NSString *userid;
@end
