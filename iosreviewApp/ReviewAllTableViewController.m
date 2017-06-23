//
//  ReviewAllTableViewController.m
//  iosreviewApp
//
//  Created by star on 5/23/17.
//  Copyright © 2017 star. All rights reserved.
//

#import "ReviewAllTableViewController.h"
#import "SWRevealViewController.h"
#import "FullPhotoViewController.h"
#import "ContactViewController.h"
#import "SearchViewController.h"
#import "ScanController.h"

#import "categoryTableViewCell.h"

#import "ProductDetailViewController.h"
@interface ReviewAllTableViewController ()
{
    int selected_row;
    NSString *selPhoto;
}
@end

@implementation ReviewAllTableViewController

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
    
    [_reviewAllTable registerNib:[UINib nibWithNibName:@"categoryTableViewCell" bundle:nil] forCellReuseIdentifier:@"categoryTableViewCell"];
}
- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    categoryTableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:@"categoryTableViewCell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[categoryTableViewCell alloc] init];
    }
    NSString *photoUrl = [self.arrAllReview.primary_photos objectAtIndex:indexPath.row];
    NSString *name = [self.arrAllReview.name objectAtIndex:indexPath.row];
    NSString *review = [self.arrAllReview.review objectAtIndex:indexPath.row]; //rate
    NSString *totalReviewCount = [self.arrAllReview.totalReviewCount objectAtIndex:indexPath.row];
    
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
    selPhoto = [self.arrAllReview.primary_photos objectAtIndex:gesture.view.tag];
    
    [self performSegueWithIdentifier:@"fullPhotoSegue" sender:self];
}

- (NSInteger)tableView:(UITableView *)_tableView numberOfRowsInSection:(NSInteger)section
{
    if([self.arrAllReview.product_id count] < 8)
        return [self.arrAllReview.product_id count];
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
    
    if([[segue identifier] isEqualToString:@"detailSegue"])
    {
        ProductDetailViewController *vc = [segue destinationViewController];
        vc.product_id = [_arrAllReview.product_id objectAtIndex:selected_row];
        vc.category_id = [_arrAllReview.category_id objectAtIndex:selected_row];
        vc.product_photoval = [_arrAllReview.primary_photos objectAtIndex:selected_row];
        vc.product_title = [_arrAllReview.name objectAtIndex:selected_row];
        vc.product_rateval = [_arrAllReview.review objectAtIndex:selected_row];
        vc.review_count = [_arrAllReview.totalReviewCount objectAtIndex:selected_row];
    }
    if([[segue identifier] isEqualToString:@"fullPhotoSegue"])
    {
        FullPhotoViewController *vc = [segue destinationViewController];
        vc.photoURL = selPhoto;
    }
}


@end
