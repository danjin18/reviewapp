//
//  SubmitRedeempViewController.m
//  iosreviewApp
//
//  Created by dan jin on 6/2/17.
//  Copyright © 2017 star. All rights reserved.
//

#import "SubmitRedeempViewController.h"
#import "ContactViewController.h"
#import "SearchViewController.h"
#import "ScanController.h"
#import "SWRevealViewController.h"

#import "Preference.h"
#import "Constants.h"

#import <AFNetworking.h>
#import "UIImageView+AFNetworking.h"
#import "ServerAPIPath.h"

#import "utility.h"
#import "AppDelegate.h"

@interface SubmitRedeempViewController ()
{
    Preference *pref;
    NSMutableArray *countryNames ;
}
@end

@implementation SubmitRedeempViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
    
    pref = [Preference getInstance];
    [self getCountry];
}

-(void)getCountry
{
    [utility showProgressDialog:self];
    
    NSURL *URL = [NSURL URLWithString:API_POST_GET_COUNTRY];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:[pref getSharedPreference:nil :PREF_PARAM_USER_ID :@""], @"userId",
                                nil];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST:URL.absoluteString parameters:parameters progress:nil success:^(NSURLSessionDataTask * task, id  responseObject) {
        
        [utility hideProgressDialog];
        if (responseObject == nil) {
            return;
        }
        else {
            NSError *error = nil;
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];
            @try {
                NSArray *countryInfo = [json objectForKey:@"data"];
                NSArray *countries = [countryInfo[0] objectForKey:@"category"];
                
                countryNames = [[NSMutableArray alloc] init];
                
                for(NSDictionary *country in countries)
                {
//                    NSString *country_data = [country objectForKey:@"country"];
                    [countryNames addObject:[country objectForKey:@"country"]];
                }
                if([countryNames count] == 0)
                    return;
                
                if(![[countryNames objectAtIndex:0] isEqualToString:@""])
                    _countryLabel.text = [countryNames objectAtIndex:0];
            }
            @catch (NSException *e) {
                NSLog(@"responseInvoiceList - JSONException : %@", e.reason);
            }
            
        }
    } failure:^(NSURLSessionDataTask  *task, NSError  *error) {
        
        [utility hideProgressDialog];
        [[AppDelegate sharedAppDelegate] showToastMessage:error.localizedDescription];
        
    }];
    
    
}

- (IBAction)submitClicked:(id)sender {

    // phone number validateion
    if([utility isNumeric:_mobile.text] == false)
    {
        return;
    }
    
    // address validation
    if([_Address.text length] == 0)
        return;
    // pincode validation
    if([_pincode.text length] < 5)
        return;
    if([utility isNumeric:_pincode.text] == false)
    {
        return;
    }
    
    [self sendinfo];
    
}

-(void)sendinfo
{
    [utility showProgressDialog:self];
    
    NSURL *URL = [NSURL URLWithString:API_POST_ADDRESS];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:[pref getSharedPreference:nil :PREF_PARAM_USER_ID :@""], @"userId",
                                _redeemid, @"redeemId",
                                [pref getSharedPreference:nil :PREF_PARAM_USER_NAME :@""], @"name",
                                [pref getSharedPreference:nil :PREF_PARAM_USER_EMAIL :@""], @"email",
                                _mobile.text, @"mobile",
                                _Address.text, @"address",
                                _city.text, @"city",
                                _pincode.text, "pincode",
                                _countryLabel.text, @"country",
                                nil];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];

    [manager POST:URL.absoluteString parameters:parameters progress:nil success:^(NSURLSessionDataTask * task, id  responseObject) {
        
        [utility hideProgressDialog];
        if (responseObject == nil) {
            return;
        }
        else {
            NSString *response = [NSString stringWithFormat:@"%@", responseObject];
            if([response isEqualToString:@"<6f6b0a0a>"]) // Ok string.
            {
                 [[AppDelegate sharedAppDelegate] showToastMessage:NSLocalizedString(@"success", @"")];
                /// go to the previous page.
                [self.navigationController popViewControllerAnimated:YES];
            }
           
        }
    } failure:^(NSURLSessionDataTask  *task, NSError  *error) {
        
        [utility hideProgressDialog];
        [[AppDelegate sharedAppDelegate] showToastMessage:error.localizedDescription];
        
    }];
    

}

- (IBAction)searchClicked:(id)sender {
    
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SearchViewController * controller = (SearchViewController *)[storyboard instantiateViewControllerWithIdentifier:@"searchview"];
    [self.navigationController pushViewController: controller animated:YES];
}

- (IBAction)contactClicked:(id)sender {
    [[self navigationController] popViewControllerAnimated:YES];
}

- (IBAction)barcodeClicked:(id)sender {
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ScanController * controller = (ScanController *)[storyboard instantiateViewControllerWithIdentifier:@"barcodeview"];
    [self.navigationController pushViewController: controller animated:YES];
}
#pragma mark FYComboBoxDelegate

- (NSInteger)comboBoxNumberOfRows:(FYComboBox *)comboBox
{
    if (comboBox == self.fyCountryBtn) {
        return self->countryNames.count;
    }
    
    return 0;
}

- (NSString *)comboBox:(FYComboBox *)comboBox titleForRow:(NSInteger)row
{
    if (comboBox == self.fyCountryBtn) {
        return self->countryNames[row];
    }
    
    return 0;
}

- (void)comboBox:(FYComboBox *)comboBox didSelectRow:(NSInteger)row
{
    if (comboBox == self.fyCountryBtn) {
        self.countryLabel.text = self->countryNames[row];
    }
    
    [comboBox closeAnimated:YES];
    
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
