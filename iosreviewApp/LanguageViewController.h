//
//  LanguageViewController.h
//  iosreviewApp
//
//  Created by star on 5/19/17.
//  Copyright © 2017 star. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FYComboBox.h"

@interface LanguageViewController : UIViewController {

}

@property (weak, nonatomic) IBOutlet UIButton *countryBtn;
@property (weak, nonatomic) IBOutlet UIButton *langBtn;
@property (weak, nonatomic) IBOutlet FYComboBox *fyLangBtn;
@property (weak, nonatomic) IBOutlet UILabel *langLabel;
@property (weak, nonatomic) IBOutlet FYComboBox *fyCountryBtn;
@property (weak, nonatomic) IBOutlet UILabel *countryLabel;

@end
