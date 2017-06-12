//
//  FindFriendViewController.h
//  iosreviewApp
//
//  Created by dan jin on 6/7/17.
//  Copyright © 2017 star. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyFriendModel.h"
#import <AddressBook/ABAddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

@interface FindFriendViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *facebookBtn;
@property (weak, nonatomic) IBOutlet UIView *contactBtn;
@property (weak, nonatomic) IBOutlet UITableView *friendTable;

@property (nonatomic, strong) UITapGestureRecognizer *tapRecognizer;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *rightbarButton;

@property (nonatomic, retain) MyFriendModel *myFriendModel;

@property (nonatomic, retain) NSMutableArray *contactList;

@end
