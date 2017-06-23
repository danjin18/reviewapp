//
//  AddImageViewController.h
//  iosreviewApp
//
//  Created by dan jin on 6/19/17.
//  Copyright © 2017 star. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddImageViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *rightbarButton;
@property (weak, nonatomic) IBOutlet UIImageView *photo;

@property (nonatomic, retain) NSString *photoURL;
@end
