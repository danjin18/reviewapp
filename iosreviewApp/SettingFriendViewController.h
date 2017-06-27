//
//  SettingFriendViewController.h
//  iosreviewApp
//
//  Created by dan jin on 5/28/17.
//  Copyright © 2017 star. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FriendModel.h"

@interface SettingFriendViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *rightbarButton;

@property (nonatomic, retain) FriendModel *myFriendModel;
@property (weak, nonatomic) IBOutlet UITableView *friendTable;

@end
