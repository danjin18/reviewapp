//
//  RedeempViewController.m
//  iosreviewApp
//
//  Created by dan jin on 6/1/17.
//  Copyright © 2017 star. All rights reserved.
//

#import "RedeempViewController.h"
#import "SubmitRedeempViewController.h"
#import "ContactViewController.h"
#import "SearchViewController.h"
#import "ScanController.h"

#import "RedeempTableViewCell.h"

#import "Preference.h"
#import "Constants.h"

#import <AFNetworking.h>
#import "UIImageView+AFNetworking.h"
#import "ServerAPIPath.h"

#import "utility.h"
#import "AppDelegate.h"

#import "SWRevealViewController.h"
@interface RedeempViewController ()
{
    Preference *pref;
    NSInteger selected_row;
}
@end

@implementation RedeempViewController

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
    
    [_redeempTable registerNib:[UINib nibWithNibName:@"RedeempTableViewCell" bundle:nil] forCellReuseIdentifier:@"RedeempTableViewCell"];
    
    [self getRedeemp];
}

-(void)getRedeemp
{
    [utility showProgressDialog:self];
    
    NSURL *URL = [NSURL URLWithString:API_POST_GET_REDEEPTION];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:[pref getSharedPreference:nil :PREF_PARAM_USER_ID :@""], @"user_id",nil];
    
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
                _point.text = [json objectForKey:@"Point"];
                _arrRedeemption = [[redeempModel alloc] init:[json objectForKey:@"Data"]];
                [_redeempTable reloadData];
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
    RedeempTableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:@"RedeempTableViewCell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[RedeempTableViewCell alloc] init];
    }
    NSString *photoUrl = [self.arrRedeemption.photo objectAtIndex:indexPath.row];
    NSString *points = [self.arrRedeemption.point objectAtIndex:indexPath.row];
    
    [cell setPhotoCell:photoUrl];
    [cell setPointCell:points];
    
    cell.redeemp.tag = indexPath.row;
    [cell.redeemp addTarget:self action:@selector(redeempClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}
-(void)redeempClicked:(UIButton*)sender
{
    selected_row = sender.tag;
    [self performSegueWithIdentifier:@"redeempSegue" sender:self];

}
- (NSInteger)tableView:(UITableView *)_tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.arrRedeemption.id count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}
- (void)tableView:(UITableView *)_tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_tableView deselectRowAtIndexPath:indexPath animated:NO];
    //    selected_row = (int)indexPath.row;
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([[segue identifier] isEqualToString:@"redeempSegue"])
    {
        SubmitRedeempViewController *vc = [segue destinationViewController];
        vc.redeemid = [self.arrRedeemption.id objectAtIndex:selected_row];
    }
}


@end
