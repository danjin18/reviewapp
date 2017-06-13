//
//  ExternalLinkViewController.h
//  iosreviewApp
//
//  Created by dan jin on 6/8/17.
//  Copyright © 2017 star. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExternalLinkViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIWebView *website;

@property (nonatomic, retain) NSMutableArray *site;
@property (nonatomic) NSInteger curPos;
@property (nonatomic) NSString *product_id;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *rightbarButton;

@end
