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

@interface RedeemDetailViewController ()
{
    NSTimer *timer;
    NSInteger globalTimer;
    NSInteger counter;
    NSInteger minutesLeft;
    NSInteger secondsLeft;
    UIRefreshControl *refreshControl;
    
    CircularProgressTimer *progressTimerView1;
}

@end

@implementation RedeemDetailViewController

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
    
    globalTimer = 120;
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
    if (globalTimer > 0 && globalTimer <= 120) {
        globalTimer--;
        minutesLeft = globalTimer / 60;
        secondsLeft = globalTimer % 60;
        
        [self drawCircularProgressBarWithMinutesLeft:minutesLeft secondsLeft:secondsLeft];
    } else {
        [self drawCircularProgressBarWithMinutesLeft:0 secondsLeft:0];
        [timer invalidate];
    }
}
- (IBAction)searchClicked:(id)sender {
    
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SearchViewController * controller = (SearchViewController *)[storyboard instantiateViewControllerWithIdentifier:@"searchview"];
    [self.navigationController pushViewController: controller animated:YES];
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
