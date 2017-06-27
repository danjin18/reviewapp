//
//  SubProductViewController.m
//  iosreviewApp
//
//  Created by star on 5/24/17.
//  Copyright © 2017 star. All rights reserved.
//

#import "SubProductViewController.h"

#import "ProductTableViewCell.h"
#import "PriceAlertDialogViewController.h"
#import "FullPhotoViewController.h"
#import "ProductDetailViewController.h"

#import <AFNetworking.h>
#import "ServerAPIPath.h"

#import "utility.h"
#import "AppDelegate.h"
#import "Preference.h"
#import "Constants.h"

#import "SWRevealViewController.h"

#import "ContactViewController.h"
#import "SearchViewController.h"
#import "ScanController.h"

@interface SubProductViewController ()
{
    NSInteger selectedCell, onlineCell, storeCell;
    NSString *selStore;
    NSString *selPhoto;
    NSMutableArray *searchText ;
    
    NSMutableArray *newProductModel;
    Preference *pref;
}
@end

@implementation SubProductViewController

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
    
    [_productTable registerNib:[UINib nibWithNibName:@"ProductTableViewCell" bundle:nil] forCellReuseIdentifier:@"ProductTableViewCell"];
    searchText = [[NSMutableArray alloc] initWithObjects:
                 @"Sort by Rating High",
                 @"Sort by Rating Low",
                 @"Sort by Price High",
                 @"Sort by Price Low",
                 nil];
    _sortLabel.text = [searchText objectAtIndex:0];
    [self getProductList];
}
-(void)getProductList
{
    [utility showProgressDialog:self];
    
    
    NSURL *URL = [NSURL URLWithString:API_POSTPRODUCT_LIST];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:_category_id, @"category_id", [pref getSharedPreference:nil :PREF_PARAM_COUNTRY :@""], @"country", nil];
    
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
                    [self makeNewArray];
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
    NSDictionary *curField = [newProductModel objectAtIndex:indexPath.row];
    
    NSString *photoUrl = [curField valueForKey:@"product_photo"];
    NSString *name = [curField valueForKey:@"product_title"];
    NSString *rate = [curField valueForKey:@"product_rate"];
    NSString *reviewcount = [curField valueForKey:@"review_count"];
    NSString *sale_price = [curField valueForKey:@"sale_price"];
    
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

- (NSInteger)comboBoxNumberOfRows:(FYComboBox *)comboBox
{
    if (comboBox == self.sortingBtn) {
        return self->searchText.count;
    }
    return 0;
}

- (NSString *)comboBox:(FYComboBox *)comboBox titleForRow:(NSInteger)row
{
    if (comboBox == self.sortingBtn) {
        return self->searchText[row];
    }
    return @"";
}

- (void)comboBox:(FYComboBox *)comboBox didSelectRow:(NSInteger)row
{
    _sortLabel.text = self->searchText[row];
    [self sortingTable:self->searchText[row]];
    
    [comboBox closeAnimated:YES];
}

- (void)comboBox:(FYComboBox *)comboBox willOpenAnimated:(BOOL)animated
{
}

- (void)comboBox:(FYComboBox *)comboBox didOpenAnimated:(BOOL)animated
{
}

- (void)comboBox:(FYComboBox *)comboBox willCloseAnimated:(BOOL)animated
{
}

- (void)comboBox:(FYComboBox *)comboBox didCloseAnimated:(BOOL)animated
{
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)makeNewArray
{
    newProductModel = [[NSMutableArray alloc] init];
    for(int cnt = 0; cnt < [self.productModel.product_id count]; cnt++)
    {
        NSMutableDictionary *model = [[NSMutableDictionary alloc] init];
        [model setValue:[self.productModel.product_id objectAtIndex:cnt] forKey:@"product_id"];
        [model setValue:[self.productModel.product_title objectAtIndex:cnt] forKey:@"product_title"];
        [model setValue:[self.productModel.product_rate objectAtIndex:cnt] forKey:@"product_rate"];
        [model setValue:[self.productModel.product_photo objectAtIndex:cnt] forKey:@"product_photo"];
        [model setValue:[self.productModel.product_title objectAtIndex:cnt] forKey:@"product_title"];
        [model setValue:[self.productModel.sale_price objectAtIndex:cnt] forKey:@"sale_price"];
        [model setValue:[self.productModel.category_id objectAtIndex:cnt] forKey:@"category_id"];
        [model setValue:[self.productModel.review_count objectAtIndex:cnt] forKey:@"review_count"];
        
        [newProductModel addObject:model];
        
    }
}
-(void)sortingTable:(NSString *)sortText
{
    if([sortText isEqualToString:@"Sort by Rating High"])
    {
 //       [self sortTheArray:@"orderNo":YES];
        
        NSSortDescriptor *sortDescriptor;
        sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"product_rate" ascending:NO];
        NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
        
        newProductModel = (NSMutableArray *)[newProductModel sortedArrayUsingDescriptors:sortDescriptors];
    }
    
    if([sortText isEqualToString:@"Sort by Rating Low"])
    {
        NSSortDescriptor *sortDescriptor;
        sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"product_rate" ascending:YES];
        NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
        
        newProductModel = (NSMutableArray *)[newProductModel sortedArrayUsingDescriptors:sortDescriptors];
    }
    
    if([sortText isEqualToString:@"Sort by Price High"])
    {
        NSSortDescriptor *sortDescriptor;
        sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"sale_price" ascending:NO];
        NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
        
        newProductModel = (NSMutableArray *)[newProductModel sortedArrayUsingDescriptors:sortDescriptors];
    }
    
    if([sortText isEqualToString:@"Sort by Price Low"])
    {
        NSSortDescriptor *sortDescriptor;
        sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"sale_price" ascending:YES];
        NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
        
        newProductModel = (NSMutableArray *)[newProductModel sortedArrayUsingDescriptors:sortDescriptors];
    }
    
    [self.productTable reloadData];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
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
        [SubProductViewController setPresentationStyleForSelfController:self presentingController:vc];
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
    // Pass the selected object to the new view controller.
}
- (IBAction)searchClicked:(id)sender {
    
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SearchViewController * controller = (SearchViewController *)[storyboard instantiateViewControllerWithIdentifier:@"searchview"];
    [self.navigationController pushViewController: controller animated:YES];
}
- (IBAction)contactClicked:(id)sender {
    [[self navigationController] popViewControllerAnimated:YES];
}
- (IBAction)barcodeClicked:(id)sender {
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ScanController * controller = (ScanController *)[storyboard instantiateViewControllerWithIdentifier:@"barcodeview"];
    [self.navigationController pushViewController: controller animated:YES];
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

@end
