//
//  PromotionViewController.m
//  iosreviewApp
//
//  Created by dan jin on 5/29/17.
//  Copyright © 2017 star. All rights reserved.
//

#import "PromotionViewController.h"
#import "ContactViewController.h"
#import "SearchViewController.h"
#import "ScanController.h"

#import "Preference.h"
#import "Constants.h"

#import <AFNetworking.h>
#import "UIImageView+AFNetworking.h"
#import "ServerAPIPath.h"

#import "utility.h"
#import "AppDelegate.h"

#import "SWRevealViewController.h"
@interface PromotionViewController ()
{
    Preference *pref;
}
@end

@implementation PromotionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    pref = [Preference getInstance];
    
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.sidebarButton setTarget: self.revealViewController];
        [self.sidebarButton setAction: @selector( revealToggle: )];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
        
        [self.rightbarButton setTarget: self.revealViewController];
        [self.rightbarButton setAction: @selector( rightRevealToggle: )];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startPromotion:) name:@"PromotionCount" object:nil];
    _couponView.hidden = NO;
    _freestuffView.hidden = YES;
    _LimitedTimeView.hidden = YES;

}

- (void)startPromotion:(NSNotification *)notification {
    
    NSDictionary *dict = [notification userInfo];
    _couponCount.text = [NSString stringWithFormat:@"%@", [dict objectForKey:@"coupon"]];
    _FreeStuffCount.text = [NSString stringWithFormat:@"%@", [dict objectForKey:@"freestuff"]];
    _LimitedTimeCount.text = [NSString stringWithFormat:@"%@", [dict objectForKey:@"limitedtime"]];
}

- (IBAction)couponClicked:(id)sender {
    _couponView.hidden = NO;
    _freestuffView.hidden = YES;
    _LimitedTimeView.hidden = YES;

}
- (IBAction)FreeStuffClicked:(id)sender {
    _couponView.hidden = YES;
    _freestuffView.hidden = NO;
    _LimitedTimeView.hidden = YES;

}
- (IBAction)LimitedTimeClicked:(id)sender {
    _couponView.hidden = YES;
    _freestuffView.hidden = YES;
    _LimitedTimeView.hidden = NO;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)searchClicked:(id)sender {
    
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SearchViewController * controller = (SearchViewController *)[storyboard instantiateViewControllerWithIdentifier:@"searchview"];
    [self presentViewController:controller animated:NO completion:nil];
}
- (IBAction)contactClicked:(id)sender {
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ContactViewController * controller = (ContactViewController *)[storyboard instantiateViewControllerWithIdentifier:@"contactview"];
    
    controller.modalPresentationStyle =  UIModalPresentationOverCurrentContext;
    
    [self presentViewController:controller animated:NO completion:nil];
}
- (IBAction)barcodeClicked:(id)sender {
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ScanController * controller = (ScanController *)[storyboard instantiateViewControllerWithIdentifier:@"barcodeview"];
    [self presentViewController:controller animated:NO completion:nil];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
