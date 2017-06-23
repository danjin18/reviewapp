//
//  RecentProductViewController.m
//  iosreviewApp
//
//  Created by dan jin on 6/2/17.
//  Copyright © 2017 star. All rights reserved.
//

#import "RecentProductViewController.h"
#import "SWRevealViewController.h"

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

#import "ProductTableViewCell.h"
#import "PriceAlertDialogViewController.h"

@interface RecentProductViewController ()
{
    NSInteger selectedCell, onlineCell, storeCell;
    NSString *selStore;
    NSString *selPhoto;
    NSMutableArray *searchText ;
    
    Preference *pref;
}
@end

@implementation RecentProductViewController

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
    [_recentTable registerNib:[UINib nibWithNibName:@"ProductTableViewCell" bundle:nil] forCellReuseIdentifier:@"ProductTableViewCell"];
    
    [self getRecentProductList];
}

-(void)getRecentProductList
{
    [utility showProgressDialog:self];
    
    
    NSURL *URL = [NSURL URLWithString:API_POST_GET_RECENT_VIEW];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:[pref getSharedPreference:nil :PREF_PARAM_USER_ID :@""], @"user_id", nil];
    
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
                    _productModel = [[productModel alloc] init:[json objectForKey:@"Data"]];
                    [_recentTable reloadData];
                    
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
    ProductTableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:@"ProductTableViewCell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[ProductTableViewCell alloc] init];
    }
    
    NSString *photoUrl = [self.productModel.product_photo objectAtIndex:indexPath.row];
    NSString *name = [self.productModel.product_title objectAtIndex:indexPath.row];
    NSString *rate = [self.productModel.product_rate objectAtIndex:indexPath.row];
    NSString *reviewcount = [self.productModel.review_count objectAtIndex:indexPath.row];
    NSString *sale_price = [self.productModel.sale_price objectAtIndex:indexPath.row];
    
    [cell setPhotoCell:photoUrl];
    [cell setTitleCell:name];
    [cell setRateCell:rate];
    [cell setcountCell:reviewcount];
    [cell setSaleCell:sale_price];
    
    cell.buyOnline.tag = indexPath.row;
    cell.buyStore.tag = indexPath.row;
    
    [cell.buyOnline addTarget:self action:@selector(buyOnline:)
             forControlEvents:UIControlEventTouchUpInside];
    [cell.buyStore addTarget:self action:@selector(buyStores:)
            forControlEvents:UIControlEventTouchUpInside];
    
    cell.product_photo.userInteractionEnabled = YES;
    cell.product_photo.tag = indexPath.row;
    
    UITapGestureRecognizer *tapped = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(myFunction:)];
    tapped.numberOfTapsRequired = 1;
    [cell.product_photo addGestureRecognizer:tapped];
    
    return cell;
}
-(void)myFunction :(id) sender
{
    UITapGestureRecognizer *gesture = (UITapGestureRecognizer *) sender;
    selPhoto = [self.productModel.product_photo objectAtIndex:gesture.view.tag];
    
    [self performSegueWithIdentifier:@"fullPhotoSegue" sender:self];
}
- (void) buyOnline:(UIButton *)sender {
    onlineCell = sender.tag;
    selStore = @"online";
    [self performSegueWithIdentifier:@"priceSegue" sender:self];
}

- (void) buyStores:(UIButton *)sender {
    storeCell = sender.tag;
    selStore = @"store";
    [self performSegueWithIdentifier:@"priceSegue" sender:self];
}

- (NSInteger)tableView:(UITableView *)_tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.productModel.product_id count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 130;
}
- (void)tableView:(UITableView *)_tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_tableView deselectRowAtIndexPath:indexPath animated:NO];
    selectedCell = indexPath.row;
    
    [self performSegueWithIdentifier:@"productdetailSegue" sender:self];
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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([[segue identifier] isEqualToString:@"priceSegue"])
    {
        PriceAlertDialogViewController *vc = [segue destinationViewController];
        vc.selStore = selStore;
        if([selStore isEqualToString:@"online"])
            vc.product_id = [_productModel.product_id objectAtIndex:onlineCell];
        else
            vc.product_id = [_productModel.product_id objectAtIndex:storeCell];
        
    }
}

@end
