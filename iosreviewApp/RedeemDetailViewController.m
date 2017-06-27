//
//  RedeemDetailViewController.m
//  iosreviewApp
//
//  Created by dan jin on 6/2/17.
//  Copyright © 2017 star. All rights reserved.
//

#import "RedeemDetailViewController.h"
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

@interface RedeemDetailViewController ()
{
    NSTimer *timer;
    NSInteger globalTimer;
    NSInteger counter;
    NSInteger minutesLeft;
    NSInteger secondsLeft;
    UIRefreshControl *refreshControl;
    
    CircularProgressTimer *progressTimerView1;
    
    Preference *pref;
    NSInteger settingTimer;

}

@end

@implementation RedeemDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
/*    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.sidebarButton setTarget: self.revealViewController];
        [self.sidebarButton setAction: @selector( revealToggle: )];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
        
        [self.rightbarButton setTarget: self.revealViewController];
        [self.rightbarButton setAction: @selector( rightRevealToggle: )];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    */

    self.bannerView.adUnitID = @"ca-app-pub-3940256099942544/6300978111";//@"ca-app-pub-9760873818563949/5099241077";
    self.bannerView.rootViewController = self;
    
    GADRequest *request = [GADRequest request];
    request.testDevices = @[ kGADSimulatorID ];
    [self.bannerView loadRequest:request];
   // [self.bannerView loadRequest:[GADRequest request]];
/*
    GADRequest *request = [GADRequest request];
    // Requests test ads on devices you specify. Your test device ID is printed to the console when
    // an ad request is made. GADBannerView automatically returns test ads when running on a
    // simulator.
    request.testDevices = @[
                            @"2077ef9a63d2b398840261c8221a0c9a"  // Eric's iPod Touch
                            ];
    [self.bannerView loadRequest:request];
    */
    pref = [Preference getInstance];
    settingTimer = 60;
    globalTimer = settingTimer;
    [self startTimer];
}

// Draws the progress circles on top of the already painted backgroud
- (void)drawCircularProgressBarWithMinutesLeft:(NSInteger)minutes secondsLeft:(NSInteger)seconds
{
    // Removing unused view to prevent them from stacking up
    for (id subView in [self.view subviews]) {
        if ([subView isKindOfClass:[CircularProgressTimer class]]) {
            [subView removeFromSuperview];
        }
    }
    
    // Init our view and set current circular progress bar value
    CGRect progressBarFrame = CGRectMake(0, 0, 180, 180);
    progressTimerView1 = [[CircularProgressTimer alloc] initWithFrame:progressBarFrame];
    [progressTimerView1 setCenter:CGPointMake(self.view.center.x,300)];
    [progressTimerView1 setPercent:seconds];
    if (minutes == 0 && seconds == 0) {
        [progressTimerView1 setInstanceColor:[UIColor redColor]];
    }
    
    // Here, setting the minutes left before adding it to the parent view
    [progressTimerView1 setMinutesLeft:minutesLeft];
    [progressTimerView1 setSecondsLeft:secondsLeft];
    [self.view addSubview:progressTimerView1];
    progressTimerView1 = nil;
}

- (void)startTimer
{
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                             target:self
                                           selector:@selector(updateCircularProgressBar)
                                           userInfo:nil
                                            repeats:YES];
}

- (void)updateCircularProgressBar
{
    // Values to be passed on to Circular Progress Bar
    if (globalTimer > 0 && globalTimer <= settingTimer) {
        globalTimer--;
        minutesLeft = globalTimer / 60;
        secondsLeft = globalTimer % 60;
        
        [self drawCircularProgressBarWithMinutesLeft:minutesLeft secondsLeft:secondsLeft];
    } else {
        [self drawCircularProgressBarWithMinutesLeft:0 secondsLeft:0];
        [timer invalidate];
        
        [self setRedeemed];
    }
}
-(void)setRedeemed
{
    [utility showProgressDialog:self];
    
    
    NSURL *URL = [NSURL URLWithString:API_POST_SET_REDEEM];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:[pref getSharedPreference:nil :PREF_PARAM_USER_ID :@""], @"user_id",
                                _sid, @"sid",
                                nil];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST:URL.absoluteString parameters:parameters progress:nil success:^(NSURLSessionDataTask * task, id  responseObject) {
        
        [utility hideProgressDialog];
        if (responseObject == nil) {
            return;
        }
        else {
            [self dismissViewControllerAnimated:YES completion:nil];
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
    [self dismissViewControllerAnimated:YES completion:nil];

}
- (IBAction)barcodeClicked:(id)sender {
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ScanController * controller = (ScanController *)[storyboard instantiateViewControllerWithIdentifier:@"barcodeview"];
    [self.navigationController pushViewController: controller animated:YES];
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
