//
//  RecentFeaturedViewController.h
//  iosreviewApp
//
//  Created by ymamsMacOSX on 6/27/17.
//  Copyright © 2017 star. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "reviewModel.h"

@interface RecentFeaturedViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *myTable;
@property (nonatomic, retain) reviewModel *arrReview;
@end
