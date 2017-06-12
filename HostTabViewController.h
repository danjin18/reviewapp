//
//  HostTabViewController.h
//  iosreviewApp
//
//  Created by dan jin on 6/3/17.
//  Copyright © 2017 star. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewPagerController.h"

@interface HostTabViewController : ViewPagerController
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *rightbarButton;

@end
