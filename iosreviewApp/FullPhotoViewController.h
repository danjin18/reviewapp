//
//  FullPhotoViewController.h
//  iosreviewApp
//
//  Created by star on 5/26/17.
//  Copyright © 2017 star. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FullPhotoViewController : UIViewController

@property (nonatomic, retain) NSString *photoURL;
@property (weak, nonatomic) IBOutlet UIImageView *productPhoto;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *contactButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *searchButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *barcodeButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *rightbarButton;
@end
