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

#import "RecentProductTableViewCell.h"

#import <AFNetworking.h>
#import "ServerAPIPath.h"

#import "utility.h"
#import "AppDelegate.h"
#import "Preference.h"
#import "Constants.h"

#import "ContactViewController.h"
#import "SearchViewController.h"
#import "ScanController.h"

@interface RecentCategoryViewController ()
{
    int selected_row;
    NSString *selPhoto;
    Preference *pref;
}
@end

@implementation RecentCategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [_reviewTable registerNib:[UINib nibWithNibName:@"RecentProductTableViewCell" bundle:nil] forCellReuseIdentifier:@"RecentProductTableViewCell"];
    
    self.view.backgroundColor = [UIColor clearColor];

    pref = [Preference getInstance];
    [self getFeautrueReviewList];
}

-(void)getFeautrueReviewList {

    
    NSString *userid;
    userid = [pref getSharedPreference:nil :PREF_PARAM_USER_ID :@""];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:userid,@"user_id",
                                nil];
    if([userid isEqualToString:@""])
        return;
    
    [utility showProgressDialog:self];
    NSURL *URL = [NSURL URLWithString:API_POST_GET_MY_REVIEWS];
    
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
    RecentProductTableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:@"RecentProductTableViewCell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[RecentProductTableViewCell alloc] init];
    }
    NSString *photoUrl = [self.arrReview.primary_photos objectAtIndex:indexPath.row];
    NSString *name = [self.arrReview.name objectAtIndex:indexPath.row];
    NSString *review = [self.arrReview.review objectAtIndex:indexPath.row]; //rate
    NSString *price = [self.arrReview.sale_price objectAtIndex:indexPath.row];
    NSString *comment = [self.arrReview.comment objectAtIndex:indexPath.row];
    
    [cell setPhotoCell:photoUrl];
    [cell setTitleCell:name];
    [cell setRateCell:review];
    [cell setSaleCell:price];
    [cell setReviewCell:comment];
    
    cell.product_photo.userInteractionEnabled = YES;
    cell.product_photo.tag = indexPath.row;
    
    UITapGestureRecognizer *tapped = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fullPhoto:)];
    tapped.numberOfTapsRequired = 1;
    [cell.product_photo addGestureRecognizer:tapped];
    
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
    if([self.arrReview.product_id count] > 8)
        return 8;
    
    return [self.arrReview.product_id count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 150;
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
