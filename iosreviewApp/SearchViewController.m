//
//  SearchViewController.m
//  iosreviewApp
//
//  Created by dan jin on 6/2/17.
//  Copyright © 2017 star. All rights reserved.
//

#import "SearchViewController.h"

#import "ProductTableViewCell.h"
#import "PriceAlertDialogViewController.h"
#import "FullPhotoViewController.h"
#import "ProductDetailViewController.h"
#import "SubProductViewController.h"

#import <AFNetworking.h>
#import "ServerAPIPath.h"

#import "utility.h"
#import "AppDelegate.h"
#import "Preference.h"
#import "Constants.h"

#import "ContactViewController.h"
#import "SearchViewController.h"
#import "ScanController.h"
#import "SWRevealViewController.h"


@interface SearchViewController ()
{
    Preference *pref;
    NSInteger selectedCell, onlineCell, storeCell;
    NSString *selStore;
    NSString *selPhoto;
}
@end

@implementation SearchViewController

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
    
    [_productTable registerNib:[UINib nibWithNibName:@"ProductTableViewCell" bundle:nil] forCellReuseIdentifier:@"ProductTableViewCell"];
    
    [_searchText setLeftViewMode:UITextFieldViewModeAlways];
    _searchText.leftView= [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"search.png"]];
}
- (IBAction)searchTextChanging:(id)sender {
    [self searchProductList:_searchText.text barcodeParameter:FALSE];
}
- (IBAction)searchTextChanged:(id)sender {
    [self searchProductList:_searchText.text barcodeParameter:FALSE];
}
-(void)searchProductList:(NSString *)searchText barcodeParameter:(BOOL)barcode
{
    NSURL *URL;
    NSDictionary *parameters;
    if(barcode == FALSE)
    {
        parameters = [NSDictionary dictionaryWithObjectsAndKeys:searchText, @"search",[pref getSharedPreference:nil :PREF_PARAM_USER_ID :@""], @"user_id",  nil];
        
        URL = [NSURL URLWithString:API_POST_SEARCH_CONNECT];
    }
    else
    {
        parameters = [NSDictionary dictionaryWithObjectsAndKeys:searchText, @"barcode", [pref getSharedPreference:nil :PREF_PARAM_USER_ID :@""], @"user_id", nil];
        
        URL = [NSURL URLWithString:API_POST_BARCODE_SRARCH];
    }
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST:URL.absoluteString parameters:parameters progress:nil success:^(NSURLSessionDataTask * task, id  responseObject) {
        
        if (responseObject == nil) {
            return;
        }
        else {
            NSError *error = nil;
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];
            if([json objectForKey:@"status"]) {
                @try {
                    _productModel = [[productModel alloc] init:[json objectForKey:@"Data"]];
                    [_productTable reloadData];
                    
                }
                @catch (NSException *e) {
                    NSLog(@"responseInvoiceList - JSONException : %@", e.reason);
                }
            }
            else
                [[AppDelegate sharedAppDelegate] showToastMessage:NSLocalizedString(@"request failed", @"")];
        }
        
        
    } failure:^(NSURLSessionDataTask  *task, NSError  *error) {
        
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
    NSString *rate = [self.productModel.product_rate objectAtIndex:indexPath.row]; //rate
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    if([[segue identifier] isEqualToString:@"fullPhotoSegue"]) {
        FullPhotoViewController *vc = [segue destinationViewController];
        vc.photoURL = selPhoto;
    }
    if([[segue identifier] isEqualToString:@"priceSegue"]) {
        PriceAlertDialogViewController *vc = [segue destinationViewController];
        vc.product_id = [self.productModel.product_id objectAtIndex:selectedCell];
        vc.selStore = selStore;
        [SearchViewController setPresentationStyleForSelfController:self presentingController:vc];
    }
    if([[segue identifier] isEqualToString:@"productdetailSegue"]) {
        ProductDetailViewController *vc = [segue destinationViewController];
        vc.product_id = [self.productModel.product_id objectAtIndex:selectedCell];
        vc.category_id = [self.productModel.category_id objectAtIndex:selectedCell];
        vc.product_title = [self.productModel.product_title objectAtIndex:selectedCell];
        vc.product_rateval = [self.productModel.product_rate objectAtIndex:selectedCell];
        vc.product_photoval = [self.productModel.product_photo objectAtIndex:selectedCell];
        vc.review_count = [self.productModel.review_count objectAtIndex:selectedCell];
    }
}

+ (void)setPresentationStyleForSelfController:(UIViewController *)selfController presentingController:(UIViewController *)presentingController
{
    if ([NSProcessInfo instancesRespondToSelector:@selector(isOperatingSystemAtLeastVersion:)])
    {
        //iOS 8.0 and above
        presentingController.providesPresentationContextTransitionStyle = YES;
        presentingController.definesPresentationContext = YES;
        
        [presentingController setModalPresentationStyle:UIModalPresentationOverCurrentContext];
    }
    else
    {
        [selfController setModalPresentationStyle:UIModalPresentationCurrentContext];
        [selfController.navigationController setModalPresentationStyle:UIModalPresentationCurrentContext];
    }
}

- (IBAction)contactClicked:(id)sender {
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ContactViewController * controller = (ContactViewController *)[storyboard instantiateViewControllerWithIdentifier:@"contactview"];
    
    controller.modalPresentationStyle =  UIModalPresentationOverCurrentContext;
    
    [self presentViewController:controller animated:YES completion:nil];
}
- (IBAction)barcodeClicked:(id)sender {
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ScanController * controller = (ScanController *)[storyboard instantiateViewControllerWithIdentifier:@"barcodeview"];
    [self presentViewController:controller animated:YES completion:nil];
}


@end
