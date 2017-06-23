//
//  LanguageViewController.m
//  iosreviewApp
//
//  Created by star on 5/19/17.
//  Copyright © 2017 star. All rights reserved.
//

#import "LanguageViewController.h"
#import "LoginViewController.h"
#import "LanguageManager.h"
#import "AppDelegate.h"

#import "Constants.h"

@interface LanguageViewController ()
{
    NSMutableArray *langNames;
    NSMutableArray *countryNames ;
}

@end

@implementation LanguageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    countryNames = [[NSMutableArray alloc] initWithObjects:
                                  @"Singapore",
                                  @"Malaysia",
                                  @"Philippines",
                                  @"Australia",
                                  @"China",
                                  nil];
    
    langNames = [[NSMutableArray alloc] initWithObjects:
                                 @"English",
                                 @"tagalog",
                                 @"Melayu",
                                 @"Chinese",
                                 nil];
    _langLabel.text = [langNames objectAtIndex:[LanguageManager currentLanguageIndex]];
    _countryLabel.text = [countryNames objectAtIndex:[LanguageManager currentLanguageIndex]];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [[self navigationController] setNavigationBarHidden:YES animated:NO];
}
#pragma mark FYComboBoxDelegate

- (NSInteger)comboBoxNumberOfRows:(FYComboBox *)comboBox
{
    if (comboBox == self.fyLangBtn) {
        return self->langNames.count;
        
    } else if (comboBox == self.fyCountryBtn) {
        return self->countryNames.count;
    }
    
    return 0;
}

- (NSString *)comboBox:(FYComboBox *)comboBox titleForRow:(NSInteger)row
{
    if (comboBox == self.fyLangBtn) {
        return self->langNames[row];
        
    } else if (comboBox == self.fyCountryBtn) {
        return self->countryNames[row];
    }
    
    return 0;
}

- (void)comboBox:(FYComboBox *)comboBox didSelectRow:(NSInteger)row
{
    if (comboBox == self.fyLangBtn) {
        self.langLabel.text = self->langNames[row];
        
    } else if (comboBox == self.fyCountryBtn) {
        self.countryLabel.text = self->countryNames[row];
    }
    
    [comboBox closeAnimated:YES];
    
    if (comboBox == self.fyLangBtn) {
        [LanguageManager saveLanguageByIndex:row];
        [self reloadRootViewController];
    }
    
}

- (void)comboBox:(FYComboBox *)comboBox willOpenAnimated:(BOOL)animated
{
}

- (void)comboBox:(FYComboBox *)comboBox didOpenAnimated:(BOOL)animated
{
}

- (void)comboBox:(FYComboBox *)comboBox willCloseAnimated:(BOOL)animated
{
}

- (void)comboBox:(FYComboBox *)comboBox didCloseAnimated:(BOOL)animated
{
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onNext:(id)sender {
    [self performSegueWithIdentifier:@"languageSegue" sender:nil];
}
- (void)reloadRootViewController
{
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSString *storyboardName = @"Main";
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
    delegate.window.rootViewController = [storyboard instantiateInitialViewController];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([[segue identifier] isEqualToString:@"languageSegue"])
    {
        LoginViewController *vc = [segue destinationViewController];
        vc.country = self.countryLabel.text;
    }
}


@end
