//
//  ProductDetailViewController.m
//  iosreviewApp
//
//  Created by star on 5/26/17.
//  Copyright © 2017 star. All rights reserved.
//

#import "ProductDetailViewController.h"
#import "ReviewDetailTableViewCell.h"
#import "ContactViewController.h"
#import "SearchViewController.h"
#import "ScanController.h"

#import "ProductTableViewCell.h"
#import "PriceAlertDialogViewController.h"
#import "FullPhotoViewController.h"

#import <AFNetworking.h>

#import "UIImageView+AFNetworking.h"
#import "ServerAPIPath.h"

#import "utility.h"
#import "Preference.h"
#import "Constants.h"
#import "AppDelegate.h"

#import "SWRevealViewController.h"
@interface ProductDetailViewController ()
{
    NSString *selStore;
    NSInteger selectedCell, onlineCell, storeCell;
    NSString *selPhoto;
    
    int selectTable;
    Preference *pref;
    
    int reviewTag;
    BOOL bLike;
}
@end

@implementation ProductDetailViewController

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
    
    [self initValue];
    
    [_product_reviewTable registerNib:[UINib nibWithNibName:@"ReviewDetailTableViewCell" bundle:nil] forCellReuseIdentifier:@"ReviewDetailTableViewCell"];
    
    [_product_recommendTable registerNib:[UINib nibWithNibName:@"ProductTableViewCell" bundle:nil] forCellReuseIdentifier:@"ProductTableViewCell"];
    
    [_reviewBtn setBackgroundColor:[UIColor orangeColor]];
    [_recommendBtn setBackgroundColor:[UIColor whiteColor]];
    [_infoBtn setBackgroundColor:[UIColor whiteColor]];
    
    _product_reviewTable.hidden = NO;
    _product_recommendTable.hidden = YES;
    _infoTextView.hidden = YES;
    
    [self addRecentProduct];
    [self loadProductReview];
    
}
-(void)initValue {
    _product_name.text = _product_title;
    
    _product_photo.image = nil;
    NSURL *url = [NSURL URLWithString:_product_photoval];
    [_product_photo setImageWithURL:url];
    
    NSString *curRate;
    
    if ([_product_rateval isEqual:[NSNull null]])
        curRate = @"0";
    else
        curRate = _product_rateval;
    CGFloat strRate = (CGFloat)[curRate floatValue];
    
    [_product_rate setValue:strRate];
    [_product_rate setEnabled:false];
    
    _reviewCount.text = _review_count;
    
    selectTable = 0;
    
}
-(void)addRecentProduct
{
    [utility showProgressDialog:self];
    NSString *user_id = [pref getSharedPreference:nil :PREF_PARAM_USER_ID :@""];
    if(user_id == nil)
        user_id = @"0";

    NSURL *URL = [NSURL URLWithString:API_POST_ADD_RECENT_VISIT];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:user_id, @"user_id", _category_id, @"category_id",_product_id, @"product_id", nil];
    
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
            }
            else
                [[AppDelegate sharedAppDelegate] showToastMessage:NSLocalizedString(@"request failed", @"")];
        }
    } failure:^(NSURLSessionDataTask  *task, NSError  *error) {
        
        [utility hideProgressDialog];
        [[AppDelegate sharedAppDelegate] showToastMessage:error.localizedDescription];
        
    }];
}
-(void)loadProductReview {
    [utility showProgressDialog:self];
    
    NSString *user_id = [pref getSharedPreference:nil :PREF_PARAM_USER_ID :@""];
    if(user_id == nil)
        user_id = @"0";
    
    NSURL *URL = [NSURL URLWithString:API_POST_GET_PRODUCT_REVIEW];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:user_id, @"user_id",_product_id, @"product_id",nil];
    
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
                    _reviewDetailModel = [[reviewDetailModel alloc] init:[json objectForKey:@"Data"]];
                    [_product_reviewTable reloadData];
                    
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

-(void)loadProductRecommend {
    [utility showProgressDialog:self];
    
    NSURL *URL = [NSURL URLWithString:API_POSTPRODUCT_LIST];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:API_POSTPRODUCT_LIST, @"url",_category_id, @"category_id",nil];
    
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
                    [_product_recommendTable reloadData];
                    
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

-(void)loadProductInfo {
    [utility showProgressDialog:self];
    
    NSURL *URL = [NSURL URLWithString:API_POSTPRODUCT_LIST];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:API_POSTPRODUCT_LIST, @"url",_category_id, @"category_id",nil];
    
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
                    NSArray *arrInfo = [json objectForKey:@"Data"];
//                    for(NSDictionary *info in arrInfo)
//                    {
                        
//                    }
                    NSString *desc = [arrInfo[0] objectForKey:@"description"];
                    _infoTextView.text = desc;

                    
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
    if(_tableView == _product_reviewTable)
    {
        ReviewDetailTableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:@"ReviewDetailTableViewCell" forIndexPath:indexPath];
        if (cell == nil) {
            cell = [[ReviewDetailTableViewCell alloc] init];
        }
        NSString *photoUrl = [self.reviewDetailModel.user_photo objectAtIndex:indexPath.row];
        NSString *name = [self.reviewDetailModel.firstname objectAtIndex:indexPath.row];
        NSString *comment = [self.reviewDetailModel.comment objectAtIndex:indexPath.row];
        NSString *point = [self.reviewDetailModel.point objectAtIndex:indexPath.row];
        NSString *commentCount = [self.reviewDetailModel.commentCount objectAtIndex:indexPath.row];
//    NSString *imageCount = [NSString stringWithFormat:@"%lu", (unsigned long)[[self.reviewDetailModel.photo objectAtIndex:indexPath.row] count]];
        NSString *LikeCount = [self.reviewDetailModel.like objectAtIndex:indexPath.row];
        NSString *DislikeCount = [self.reviewDetailModel.dislike objectAtIndex:indexPath.row];
        NSString *rate = [self.reviewDetailModel.review objectAtIndex:indexPath.row];
    
        [cell setProductPhotoCell:photoUrl];
        [cell setNameCell:name];
        [cell setPointCell:point];
        [cell setDescriptionCell:comment];
        [cell setLikeCountCell:LikeCount];
        [cell setCommentCountCell:commentCount];
        [cell setDislikeCountCell:DislikeCount];
        [cell setImageCountCell:@"1"];
        [cell setRateCell:rate];
        
        cell.LikeBtn.tag = indexPath.row;
        cell.DislikeBtn.tag = indexPath.row;
        cell.CommentBtn.tag = indexPath.row;
        cell.ImageBtn.tag = indexPath.row;
        
        [cell.LikeBtn addTarget:self action:@selector(LikeClicked:)
                 forControlEvents:UIControlEventTouchUpInside];
        [cell.DislikeBtn addTarget:self action:@selector(DislikeClicked:)
               forControlEvents:UIControlEventTouchUpInside];
        [cell.CommentBtn addTarget:self action:@selector(CommentClicked:)
               forControlEvents:UIControlEventTouchUpInside];
        [cell.ImageBtn addTarget:self action:@selector(ImageClicked:)
               forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
    }
    
    if(_tableView == _product_recommendTable)
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
    
    UITableViewCell *cell;
    return cell;
    
}
-(void) LikeClicked:(UIButton *) sender
{
    bLike = TRUE;
    NSString *productReviewID = [self.reviewDetailModel.product_reviewid objectAtIndex:sender.tag];
    NSString *likeStatus = [self.reviewDetailModel.like_status objectAtIndex:sender.tag];
    
    if([likeStatus isEqualToString:@"1"])
        likeStatus = @"0";
    else
        likeStatus = @"1";
    [self addLike:productReviewID status:likeStatus];

}
-(void)addLike:(NSString *)reviewid status:(NSString *)likeStatusvalue
{
    [utility showProgressDialog:self];
    
    NSURL *URL = [NSURL URLWithString:API_POST_ADD_LIKE];
//    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:[pref getSharedPreference:nil :PREF_PARAM_USER_ID :@""], @"user_id",reviewid, @"product_review_id",likeStatus, "status", nil];
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:[pref getSharedPreference:nil :PREF_PARAM_USER_ID :@""], @"user_id",
                                reviewid, @"product_review_id",
                                likeStatusvalue, @"status",
                                nil];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST:URL.absoluteString parameters:parameters progress:nil success:^(NSURLSessionDataTask * task, id  responseObject) {
        
        [utility hideProgressDialog];
        if (responseObject == nil) {
            return;
        }
        else {

            if([[self.reviewDetailModel.like_status objectAtIndex:reviewTag] isEqualToString:@"1"]) {
                @try {
                    if(bLike == FALSE)
                    {
                        int dislikeCnt = [[self.reviewDetailModel.dislike objectAtIndex:reviewTag] intValue];
                        dislikeCnt++;
                        
                        [self.reviewDetailModel.dislike replaceObjectAtIndex:reviewTag withObject:[NSString stringWithFormat:@"%d", dislikeCnt]];
                        [self.reviewDetailModel.like_status replaceObjectAtIndex:reviewTag withObject:@"0"];
                        
                        int likeCnt = [[self.reviewDetailModel.like objectAtIndex:reviewTag] intValue];
                        if(likeCnt > 0)
                            likeCnt--;
                        
                        [self.reviewDetailModel.like replaceObjectAtIndex:reviewTag withObject:[NSString stringWithFormat:@"%d", likeCnt]];

                        [self.product_reviewTable reloadData];
                    }
                }
                @catch (NSException *e) {
                }
            }
            else
            {
                if(bLike == TRUE)
                {
                    int likeCnt = [[self.reviewDetailModel.like objectAtIndex:reviewTag] intValue];

                    likeCnt++;
                
                    [self.reviewDetailModel.like replaceObjectAtIndex:reviewTag withObject:[NSString stringWithFormat:@"%d", likeCnt]];
                    [self.reviewDetailModel.like_status replaceObjectAtIndex:reviewTag withObject:@"1"];
                    
                    int dislikeCnt = [[self.reviewDetailModel.dislike objectAtIndex:reviewTag] intValue];
                    
                    if(dislikeCnt > 0)
                        dislikeCnt--;
                    
                    [self.reviewDetailModel.dislike replaceObjectAtIndex:reviewTag withObject:[NSString stringWithFormat:@"%d", dislikeCnt]];
                    
                    [self.product_reviewTable reloadData];
                }
            }
        }
        
        
    } failure:^(NSURLSessionDataTask  *task, NSError  *error) {
        
        [utility hideProgressDialog];
        [[AppDelegate sharedAppDelegate] showToastMessage:error.localizedDescription];
        
    }];
}
-(void) DislikeClicked:(UIButton *) sender
{
    bLike = FALSE;
    NSString *productReviewID = [self.reviewDetailModel.product_reviewid objectAtIndex:sender.tag];
    NSString *likeStatus = [self.reviewDetailModel.like_status objectAtIndex:sender.tag];
    
    if([likeStatus isEqualToString:@"1"])
        likeStatus = @"0";
    else
        likeStatus = @"1";
    [self addLike:productReviewID status:likeStatus];
}

-(void) CommentClicked:(UIButton *) sender
{
//    selPhoto = [self.productModel.product_photo objectAtIndex:sender.tag];

}

-(void) ImageClicked:(UIButton *) sender
{
//    UITapGestureRecognizer *gesture = (UITapGestureRecognizer *) sender;
 //   selPhoto = [self.productModel.product_photo objectAtIndex:gesture.view.tag];
    
//    [self performSegueWithIdentifier:@"fullPhotoSegue" sender:self];
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
    if(_tableView == _product_reviewTable)
    {
        if(self.reviewDetailModel == nil)
            return 0;
        return [self.reviewDetailModel.product_id count];
    }
    
    if(_tableView == _product_recommendTable)
    {
        if(self.productModel == nil)
            return 0;
        return [self.productModel.product_id count];
    }
    
    return 0;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == _product_reviewTable)
        return 250;
    return 100;
}
- (void)tableView:(UITableView *)_tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (IBAction)compareClicked:(id)sender {
    [self performSegueWithIdentifier:@"compareSegue" sender:self];
}
- (IBAction)productRateClicked:(id)sender {
    [self performSegueWithIdentifier:@"rateSegue" sender:self];
}
- (IBAction)reviewClicked:(id)sender {
    [_reviewBtn setBackgroundColor:[UIColor orangeColor]];
    [_recommendBtn setBackgroundColor:[UIColor whiteColor]];
    [_infoBtn setBackgroundColor:[UIColor whiteColor]];
    
    [self loadProductReview];
    _product_reviewTable.hidden = NO;
    _product_recommendTable.hidden = YES;
    _infoTextView.hidden = YES;
}
- (IBAction)recommendClicked:(id)sender {
    [_reviewBtn setBackgroundColor:[UIColor whiteColor]];
    [_recommendBtn setBackgroundColor:[UIColor orangeColor]];
    [_infoBtn setBackgroundColor:[UIColor whiteColor]];
    
    [self loadProductRecommend];
    _product_reviewTable.hidden = YES;
    _product_recommendTable.hidden = NO;
    _infoTextView.hidden = YES;
}
- (IBAction)infoClicked:(id)sender {
    [_reviewBtn setBackgroundColor:[UIColor whiteColor]];
    [_recommendBtn setBackgroundColor:[UIColor whiteColor]];
    [_infoBtn setBackgroundColor:[UIColor orangeColor]];
    
    [self loadProductInfo];
    _product_reviewTable.hidden = YES;
    _product_recommendTable.hidden = YES;
    _infoTextView.hidden = NO;
}
- (IBAction)byonlineClicked:(id)sender {
    selStore = @"online";
    [self performSegueWithIdentifier:@"priceSegue" sender:self];
}
- (IBAction)buyStoreClicked:(id)sender {
    selStore = @"store";
    [self performSegueWithIdentifier:@"priceSegue" sender:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation


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
        [ProductDetailViewController setPresentationStyleForSelfController:self presentingController:vc];
    }
    if([[segue identifier] isEqualToString:@"compareSegue"]) {

    }
    if([[segue identifier] isEqualToString:@"rateSegue"]) {
        
    }
    // Pass the selected object to the new view controller.
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

@end
