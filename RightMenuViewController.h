//
//  RightMenuViewController.h
//  iosreviewApp
//
//  Created by dan jin on 6/2/17.
//  Copyright © 2017 star. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RightMenuViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *rightTable;
@property (nonatomic, retain) NSArray *arrCategory;
@end
