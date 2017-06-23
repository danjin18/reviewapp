//
//  SubmitRedeempViewController.h
//  iosreviewApp
//
//  Created by dan jin on 6/2/17.
//  Copyright © 2017 star. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FYComboBox.h"

@interface SubmitRedeempViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *mobile;
@property (weak, nonatomic) IBOutlet UITextField *Address;
@property (weak, nonatomic) IBOutlet UITextField *city;
@property (weak, nonatomic) IBOutlet UITextField *pincode;

@property (weak, nonatomic) IBOutlet FYComboBox *fyCountryBtn;

@property (weak, nonatomic) IBOutlet UILabel *countryLabel;
@property (nonatomic, retain) NSString *redeemid;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *rightbarButton;

@end
