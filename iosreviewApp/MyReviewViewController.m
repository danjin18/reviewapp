//
//  MyReviewViewController.m
//  iosreviewApp
//
//  Created by dan jin on 5/28/17.
//  Copyright © 2017 star. All rights reserved.
//

#import "MyReviewViewController.h"

#import "Preference.h"
#import "Constants.h"

#import <AFNetworking.h>
#import "UIImageView+AFNetworking.h"
#import "ServerAPIPath.h"

#import "utility.h"
#import "AppDelegate.h"

#import "ReviewTableViewCell.h"

#import "SWRevealViewController.h"

@interface MyReviewViewController ()
{
    Preference *pref;
    int selected_row;
}
@end

@implementation MyReviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    pref = [Preference getInstance];
    [_myTable registerNib:[UINib nibWithNibName:@"ReviewTableViewCell" bundle:nil] forCellReuseIdentifier:@"ReviewTableViewCell"];
    if(_userid == nil)
        _userid = [pref getSharedPreference:nil :PREF_PARAM_USER_ID :@""];
    [self getMyReview];
}


-(void)getMyReview
{
    [utility showProgressDialog:self];
    
    NSURL *URL = [NSURL URLWithString:API_POST_GET_MY_REVIEWS];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:_userid, @"user_id", nil];
    
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
                    _productModel= [[myReviewModel alloc] init:[json objectForKey:@"Data"]];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"ReviewCount" object:self userInfo:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%lu", (unsigned long)[_productModel.product_id count]] forKey:@"reviewcnt"]];
                    
                    [_myTable reloadData];
                    
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
        [[AppDelegate sharedAppDelegate] showToastMessage:error.localizedDescription];
        
    }];

}

- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ReviewTableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:@"ReviewTableViewCell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[ReviewTableViewCell alloc] init];
    }
    NSString *photoUrl = [self.productModel.product_photo objectAtIndex:indexPath.row];
    NSString *name = [self.productModel.product_title objectAtIndex:indexPath.row];
    NSString *rate = [self.productModel.product_rate objectAtIndex:indexPath.row];
    NSString *count = [self.productModel.review_count objectAtIndex:indexPath.row];
    
    [cell setPhotoCell:photoUrl];
    [cell setTitleCell:name];
    [cell setRateCell:rate];
    [cell setcountCell:count];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)_tableView numberOfRowsInSection:(NSInteger)section
{
    if(self.productModel == nil)
        return 0;
    return [self.productModel.product_title count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}
- (void)tableView:(UITableView *)_tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_tableView deselectRowAtIndexPath:indexPath animated:NO];
    selected_row = (int)indexPath.row;
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
