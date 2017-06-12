//
//  RecentCategoryViewController.h
//  iosreviewApp
//
//  Created by star on 5/22/17.
//  Copyright © 2017 star. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "reviewModel.h"

@interface RecentCategoryViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *reviewTable;

@property (nonatomic, retain) reviewModel *arrReview;

@end
