//
//  MyFriendViewController.h
//  iosreviewApp
//
//  Created by dan jin on 5/31/17.
//  Copyright © 2017 star. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyFriendModel.h"

@interface MyFriendViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *myTable;
@property (nonatomic, retain) MyFriendModel *myFriendModel;
@property (nonatomic, retain) NSString *userid;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *rightbarButton;

@end
