//
//  CategoryViewController.m
//  iosreviewApp
//
//  Created by star on 5/21/17.
//  Copyright © 2017 star. All rights reserved.
//

#import "CategoryViewController.h"
#import "PhotoCollectionViewCell.h"
#import "CategoryAllCollectionViewController.h"
#import "SubCategoryViewController.h"

#import <AFNetworking.h>
#import "ServerAPIPath.h"

#import "utility.h"
#import "AppDelegate.h"
#import "Constants.h"
#import "Preference.h"

#import "SWRevealViewController.h"
@interface CategoryViewController ()
{
    int selectedCell;
    Preference *pref;
}
@end

@implementation CategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor clearColor];
    
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
    [self getCategoryList];
}
#pragma mark- UICollectionView Delegate And DataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:DEF_PHOTO_COLLECTION_CELL_INDETIFIER forIndexPath:indexPath];
    
    NSString *photoUrl = [self.categoryModel.photos objectAtIndex:indexPath.row];
    NSString *name = [self.categoryModel.name objectAtIndex:indexPath.row];
    
    [cell setPhoto:photoUrl];
    [cell setName:name];
    
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 8;//self.categoryModel.category_id.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = collectionView.frame.size.width / 2.0f - 5;

    return CGSizeMake(width,width - 25);
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    //[collectionView deselectItemAtIndexPath:indexPath animated:NO];
    selectedCell = (int)indexPath.row;
    [self performSegueWithIdentifier:@"subcategorySegue" sender:self];
    
}


-(void)getCategoryList
{
    [utility showProgressDialog:self];
    
    NSURL *URL = [NSURL URLWithString:API_POST_GET_TOP_CATEGOTY];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST:URL.absoluteString parameters:nil progress:nil success:^(NSURLSessionDataTask * task, id  responseObject) {
        
        [utility hideProgressDialog];
        if(responseObject == nil) {
            
            return;
        }
        else {
            NSError *error = nil;
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];
            @try {
                _categoryModel = [[categoryModel alloc] init:[json objectForKey:@"data"]];
                [_category reloadData];
                
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                [userDefaults setObject:_categoryModel.name forKey:PREF_PARAM_CATEGORY];
                [userDefaults setObject:_categoryModel.category_id forKey:PREF_PARAM_CATEGORY_ID];
                [userDefaults synchronize];
                //CGRect newFrame = CGRectMake( self.view.frame.origin.x, self.view.frame.origin.y, 400, 900);
                
                //self.view.frame = newFrame;
            }
            @catch (NSException *e) {
                NSLog(@"responseInvoiceList - JSONException : %@", e.reason);
            }
            
        }
        
    } failure:^(NSURLSessionDataTask  *task, NSError  *error) {
        [utility hideProgressDialog];
        NSLog(@"Push-sendPush = %@" , error.localizedDescription);
        
    }];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([[segue identifier] isEqualToString:@"categorySegue"]) { // view All category
        //UINavigationController *navController = [segue destinationViewController];
        //CategoryAllCollectionViewController *viewAll = (CategoryAllCollectionViewController *)([navController viewControllers][0]);

        CategoryAllCollectionViewController *viewAll = [segue destinationViewController];
        viewAll.categoryAllModel = self.categoryModel;
    }
    if([[segue identifier] isEqualToString:@"subcategorySegue"]) { // view subcategory
        //UINavigationController *navController = [segue destinationViewController];
        //SubCategoryViewController *subcategory = (SubCategoryViewController *)([navController viewControllers][0]);
        SubCategoryViewController *subcategory = [segue destinationViewController];
        subcategory.category_id = [self.categoryModel.category_id objectAtIndex:selectedCell];
    }
}
- (IBAction)categoryViewAllClicked:(id)sender {
    [self performSegueWithIdentifier:@"categorySegue" sender:self];
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
