//
//  HistoryViewController.m
//  iosreviewApp
//
//  Created by dan jin on 6/2/17.
//  Copyright © 2017 star. All rights reserved.
//

#import "HistoryViewController.h"
#import "HistoryTableViewCell.h"

#import "Preference.h"
#import "Constants.h"

#import <AFNetworking.h>
#import "UIImageView+AFNetworking.h"
#import "ServerAPIPath.h"

#import "utility.h"
#import "AppDelegate.h"

@interface HistoryViewController ()
{
    Preference *pref;
}
@end

@implementation HistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    pref = [Preference getInstance];
    
    [_myTable registerNib:[UINib nibWithNibName:@"HistoryTableViewCell" bundle:nil] forCellReuseIdentifier:@"HistoryTableViewCell"];
    
    [self getHistory];
}

-(void)getHistory
{
    [utility showProgressDialog:self];
    
    
    NSURL *URL = [NSURL URLWithString:API_POST_GET_HISTORY];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:[pref getSharedPreference:nil :PREF_PARAM_USER_ID :@""], @"userId",nil];
    
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
                    _arrSurprise = [[surpriseModel alloc] init:[json objectForKey:@"Data"]];
                    [_myTable reloadData];
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
- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HistoryTableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:@"HistoryTableViewCell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[HistoryTableViewCell alloc] init];
    }
    NSString *photoUrl = [self.arrSurprise.photo objectAtIndex:indexPath.row];
    NSString *name = [self.arrSurprise.title objectAtIndex:indexPath.row];
    NSString *expiry = [self.arrSurprise.expiry objectAtIndex:indexPath.row]; //rate
    NSString *review = [self.arrSurprise.review objectAtIndex:indexPath.row];
    
    [cell setPhotoCell:photoUrl];
    [cell setTitleCell:name];
    [cell setExpiryCell:expiry];
    [cell setReviewCell:review];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)_tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.arrSurprise.sid count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 235;
}
- (void)tableView:(UITableView *)_tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_tableView deselectRowAtIndexPath:indexPath animated:NO];
    //selected_row = (int)indexPath.row;
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
