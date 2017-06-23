//
//  MenuTableViewController.m
//  pmpireApp
//
//  Created by star on 1/18/17.
//  Copyright © 2017 star. All rights reserved.
//

#import "MenuTableViewController.h"

#import "UIImageView+AFNetworking.h"
#import "Preference.h"
#import "Constants.h"

@implementation MenuTableViewController {
    NSArray *menuItems;
    Preference *pref;

}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    pref = [Preference getInstance];
    
    if([pref getLogin] == TRUE)
    {
        menuItems = [NSArray arrayWithObjects:@"profile", @"Home", @"Notifications", @"MyProfile", @"Friends", @"MyReviews", @"RecentVisit", @"RatetheApp", @"Settings", @"Redeemption", @"Promotion", @"FAQ", @"DailySurprised", @"Logout", nil];
    }
    else{
        menuItems = [NSArray arrayWithObjects: @"Home",  @"FAQ", @"Logout", nil];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [menuItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [menuItems objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0)
        return 150;
    return 50;
}
@end
