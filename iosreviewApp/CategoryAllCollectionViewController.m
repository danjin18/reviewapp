//
//  CategoryAllCollectionViewController.m
//  iosreviewApp
//
//  Created by star on 5/23/17.
//  Copyright © 2017 star. All rights reserved.
//

#import "CategoryAllCollectionViewController.h"
#import "PhotoCollectionViewCell.h"

#import "SubCategoryViewController.h"
#import "SWRevealViewController.h"
#import "ContactViewController.h"
#import "SearchViewController.h"
#import "ScanController.h"
@interface CategoryAllCollectionViewController ()
{
    NSInteger selectedCell;
}
@end

@implementation CategoryAllCollectionViewController

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
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    [flowLayout setMinimumInteritemSpacing:0.0f];
    [flowLayout setMinimumLineSpacing:10.0f];
    
    [flowLayout setItemSize:CGSizeMake(self.view.frame.size.width/2, self.view.frame.size.width/2*2)];
    [_category setPagingEnabled:YES];
    [_category setCollectionViewLayout:flowLayout];
    
    [_category setDelegate:self];
    [_category setDataSource:self];
    [_category.collectionViewLayout invalidateLayout];
    
    [_category registerNib:[UINib nibWithNibName:DEF_PHOTO_COLLECTION_CELL_INDETIFIER bundle:nil] forCellWithReuseIdentifier:DEF_PHOTO_COLLECTION_CELL_INDETIFIER];
}
#pragma mark- UICollectionView Delegate And DataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:DEF_PHOTO_COLLECTION_CELL_INDETIFIER forIndexPath:indexPath];
    
    NSString *photoUrl = [self.categoryAllModel.photos objectAtIndex:indexPath.row];
    NSString *name = [self.categoryAllModel.name objectAtIndex:indexPath.row];
    
    [cell setPhoto:photoUrl];
    [cell setName:name];
    
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.categoryAllModel.category_id.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = collectionView.frame.size.width / 2.0f - 5;
    
    return CGSizeMake(width,width - 25);
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    //[collectionView deselectItemAtIndexPath:indexPath animated:NO];
    selectedCell = indexPath.row;
    [self performSegueWithIdentifier:@"subcategorySegue" sender:self];
    
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"subcategorySegue"]) {
        SubCategoryViewController *subcategory = [segue destinationViewController];
        subcategory.category_id = [self.categoryAllModel.category_id objectAtIndex:selectedCell];
    }
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
