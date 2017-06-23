//
//  RecentCategoryViewController.m
//  iosreviewApp
//
//  Created by star on 5/22/17.
//  Copyright © 2017 star. All rights reserved.
//

#import "RecentCategoryViewController.h"
#import "ReviewAllTableViewController.h"
#import "ProductDetailViewController.h"
#import "FullPhotoViewController.h"
#import "SWRevealViewController.h"

#import "categoryTableViewCell.h"

#import <AFNetworking.h>
#import "ServerAPIPath.h"

#import "utility.h"
#import "AppDelegate.h"

#import "ContactViewController.h"
#import "SearchViewController.h"
#import "ScanController.h"

@interface RecentCategoryViewController ()
{
    int selected_row;
    NSString *selPhoto;
}
@end

@implementation RecentCategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [_reviewTable registerNib:[UINib nibWithNibName:@"categoryTableViewCell" bundle:nil] forCellReuseIdentifier:@"categoryTableViewCell"];
    
    self.view.backgroundColor = [UIColor clearColor];

    [self getReviewList];
}

-(void)getReviewList {

    [utility showProgressDialog:self];

    
    NSURL *URL = [NSURL URLWithString:API_POST_GET_FEATURE_REVIEW];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST:URL.absoluteString parameters:nil progress:nil success:^(NSURLSessionDataTask * task, id  responseObject) {
        
        [utility hideProgressDialog];
        if (responseObject == nil) {
            return;
        }
        else {
            NSError *error = nil;
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];
            if([json objectForKey:@"status"]) {
                @try {
                    _arrReview = [[reviewModel alloc] init:[json objectForKey:@"Data"]];
                    [_reviewTable reloadData];

                }
                @catch (NSException *e) {
                    NSLog(@"responseInvoiceList - JSONException : %@", e.reason);
                }
            }
            else
                [[AppDelegate sharedAppDelegate] showToastMessage:NSLocalizedString(@"request failed", @"")];
        }

        
    } failure:^(NSURLSessionDataTask  *task, NSError  *error) {
        
        [utility hideProgressDialog];
        NSLog(@"Push-sendPush = %@" , error.localizedDescription);
        
    }];

}
- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    categoryTableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:@"categoryTableViewCell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[categoryTableViewCell alloc] init];
    }
    NSString *photoUrl = [self.arrReview.primary_photos objectAtIndex:indexPath.row];
    NSString *name = [self.arrReview.name objectAtIndex:indexPath.row];
    NSString *review = [self.arrReview.review objectAtIndex:indexPath.row]; //rate
    NSString *totalReviewCount = [self.arrReview.totalReviewCount objectAtIndex:indexPath.row];
    
    [cell setCategory_imageCell:photoUrl];
    [cell setTitleCell:name];
    [cell setRatevalueCell:review];
    [cell setCountCell:totalReviewCount];
    
    cell.category_image.userInteractionEnabled = YES;
    cell.category_image.tag = indexPath.row;
    
    UITapGestureRecognizer *tapped = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fullPhoto:)];
    tapped.numberOfTapsRequired = 1;
    [cell.category_image addGestureRecognizer:tapped];
    
    return cell;
}
-(void)fullPhoto :(id) sender
{
    UITapGestureRecognizer *gesture = (UITapGestureRecognizer *) sender;
    selPhoto = [self.arrReview.primary_photos objectAtIndex:gesture.view.tag];
    
    [self performSegueWithIdentifier:@"fullPhotoSegue" sender:self];
}
- (NSInteger)tableView:(UITableView *)_tableView numberOfRowsInSection:(NSInteger)section
{
    return 8;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}
- (void)tableView:(UITableView *)_tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_tableView deselectRowAtIndexPath:indexPath animated:NO];
    selected_row = (int)indexPath.row;
    
    [self performSegueWithIdentifier:@"detailSegue" sender:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([[segue identifier] isEqualToString:@"reviewSegue"]) {
        //UINavigationController *navController = [segue destinationViewController];
        //ReviewAllTableViewController *reviewTable = (ReviewAllTableViewController *)([navController viewControllers][0]);
        
        ReviewAllTableViewController *reviewTable = [segue destinationViewController];
        reviewTable.arrAllReview = self.arrReview;
    }
    if([[segue identifier] isEqualToString:@"detailSegue"])
    {
        ProductDetailViewController *vc = [segue destinationViewController];
        vc.product_id = [_arrReview.product_id objectAtIndex:selected_row];
        vc.category_id = [_arrReview.category_id objectAtIndex:selected_row];
        vc.product_photoval = [_arrReview.primary_photos objectAtIndex:selected_row];
        vc.product_title = [_arrReview.name objectAtIndex:selected_row];
        vc.product_rateval = [_arrReview.review objectAtIndex:selected_row];
        vc.review_count = [_arrReview.totalReviewCount objectAtIndex:selected_row];
    }
    if([[segue identifier] isEqualToString:@"fullPhotoSegue"])
    {
        FullPhotoViewController *vc = [segue destinationViewController];
        vc.photoURL = selPhoto;
    }
}
- (IBAction)ReviewViewAllClicked:(id)sender {
    
    [self performSegueWithIdentifier:@"reviewSegue" sender:self];
}

-(int)tablesize
{
    return 440;
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
