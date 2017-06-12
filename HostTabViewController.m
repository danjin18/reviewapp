//
//  HostTabViewController.m
//  iosreviewApp
//
//  Created by dan jin on 6/3/17.
//  Copyright © 2017 star. All rights reserved.
//

#import "HostTabViewController.h"
#import "SurpriseViewController.h"
#import "HistoryViewController.h"

#import "ContactViewController.h"
#import "SearchViewController.h"
#import "ScanController.h"

#import "SWRevealViewController.h"

@interface HostTabViewController ()

@property(nonatomic) NSUInteger numberOfTabs;

@property(nonatomic, strong) NSMutableArray * titlesLabels;

@end

@implementation HostTabViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.dataSource = self;
    self.delegate = self;
    
    self.titlesLabels = [[NSMutableArray alloc] init];
    // Keeps tab bar below navigation bar on iOS 7.0+
    // if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
    //     self.edgesForExtendedLayout = UIRectEdgeNone;
    // }
    
    self.indicatorColor = [[UIColor redColor] colorWithAlphaComponent:0.64];
    self.tabsViewBackgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.32];
    self.contentViewBackgroundColor = [[UIColor darkGrayColor] colorWithAlphaComponent:0.32];
    self.dividerColor = [UIColor blackColor];
    
    self.startFromSecondTab = NO;
    self.centerCurrentTab = NO;
    self.tabLocation = ViewPagerTabLocationTop;
    self.tabHeight = 49;
    self.tabOffset = 36;
    self.tabWidth = UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation]) ? 128.0f : 205.0f;
    self.fixFormerTabsPositions = NO;
    self.fixLatterTabsPositions = NO;
    self.shouldShowDivider = YES;
    self.shouldAnimateIndicator = ViewPagerIndicatorAnimationWhileScrolling;
    
    self.numberOfTabs = 2;
    
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

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self performSelector:@selector(loadContent) withObject:nil afterDelay:3.0];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Setters


- (void)setNumberOfTabs:(NSUInteger)numberOfTabs
{
    
    // Set numberOfTabs
    _numberOfTabs = numberOfTabs;
    
    // Reload data
    [self reloadData];
    
}


#pragma mark - Helpers


- (void)selectTabWithNumberFive
{
    [self selectTabAtIndex:5];
}


- (void)loadContent
{
    self.numberOfTabs = 2;
}


#pragma mark - Interface Orientation Changes


- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    
    // Update changes after screen rotates
    [self performSelector:@selector(setNeedsReloadOptions) withObject:nil afterDelay:duration];
}


#pragma mark - ViewPagerDataSource


- (NSUInteger)numberOfTabsForViewPager:(ViewPagerController *)viewPager
{
    return self.numberOfTabs;
}


- (UIView *)viewPager:(ViewPagerController *)viewPager viewForTabAtIndex:(NSUInteger)index
{
    UILabel *label = [UILabel new];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:12.0];
    if(index == 0)
        label.text = @"SURPRISED WALLET";
    else if(index == 1)
        label.text = @"HISTORY";
    else
        label.text = @"TAB";
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor blackColor];
    [label sizeToFit];
    
    [self.titlesLabels insertObject:label atIndex:index];
    
    return label;
}


- (UIViewController *)viewPager:(ViewPagerController *)viewPager contentViewControllerForTabAtIndex:(NSUInteger)index
{
    if(index == 0)
    {
        SurpriseViewController *cvc = [self.storyboard instantiateViewControllerWithIdentifier:@"surpriseviewcontroller"];
    
        return cvc;
    }
    if(index == 1)
    {
        SurpriseViewController *cvc = [self.storyboard instantiateViewControllerWithIdentifier:@"historyviewcontroller"];
        
        return cvc;
    }
    return nil;
}

- (void)viewPager:(ViewPagerController *)viewPager didChangeTabToIndex:(NSUInteger)index
{
/*    NSLog(@"index1 = %lu", (unsigned long)index);
    for (UILabel *label in self.titlesLabels){
        label.textColor = [UIColor grayColor];
    }
    UILabel *label = self.titlesLabels[index];
    label.textColor = [UIColor blueColor];*/
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
