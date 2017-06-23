//
//  EditProfileViewController.m
//  iosreviewApp
//
//  Created by dan jin on 5/28/17.
//  Copyright © 2017 star. All rights reserved.
//

#import "EditProfileViewController.h"
#import "Preference.h"
#import "Constants.h"

#import <AFNetworking.h>
#import "UIImageView+AFNetworking.h"
#import "ServerAPIPath.h"

#import "utility.h"
#import "AppDelegate.h"

#import "MyReviewViewController.h"
#import "MyCommentViewController.h"
#import "MyEditorPickViewController.h"

#import "ContactViewController.h"
#import "SearchViewController.h"
#import "ScanController.h"

#import "SWRevealViewController.h"
@interface EditProfileViewController ()
{
    Preference *pref;
    int selection;
}
@end

@implementation EditProfileViewController

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
    
    _first_name.text = [pref getSharedPreference:nil :PREF_PARAM_USER_FIRSTNAME :@""];
    _last_name.text = [pref getSharedPreference:nil :PREF_PARAM_USER_LASTNAME :@""];
    
    _user_photo.image = nil;
    NSURL *url = [NSURL URLWithString:[pref getSharedPreference:nil :PREF_PARAM_USER_IMAGE :@""]];
    [_user_photo setImageWithURL:url];
    
    selection = 0;
    _reviewTable.hidden = NO;
    _commentTable.hidden = YES;
    _editorpickTable.hidden = YES;
    
    _reviewView.hidden = NO;
    _friendTable.hidden = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startReview:) name:@"ReviewCount" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startFriend:) name:@"FriendCount" object:nil];
    
    [self getPoint];

}

- (void)startReview:(NSNotification *)notification {
    
    NSDictionary *dict = [notification userInfo];
    _reviewCnt.text = [dict objectForKey:@"reviewcnt"];
}

- (void)startFriend:(NSNotification *)notification {
    
    NSDictionary *dict = [notification userInfo];
    _friendCnt.text = [dict objectForKey:@"friendcnt"];
}
-(void)getPoint
{
    [utility showProgressDialog:self];
    
    NSURL *URL = [NSURL URLWithString:API_POST_GET_POINTS];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:[pref getSharedPreference:nil :PREF_PARAM_USER_ID :@""],@"userId",
                                nil];

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
                    _pointCnt.text = [json objectForKey:@"Data"];
                    
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
-(void)getMyReview
{
    [utility showProgressDialog:self];
    
    NSURL *URL = [NSURL URLWithString:API_POST_GET_MY_REVIEWS];
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
                    _reviewModel = [[myReviewModel alloc] init:[json objectForKey:@"Data"]];
                    [self performSegueWithIdentifier:@"reviewSegue" sender:self];
                    
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
-(void)getComment
{
    [utility showProgressDialog:self];
    
    
    NSURL *URL = [NSURL URLWithString:API_POST_GET_MY_COMMENTS];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:[pref getSharedPreference:nil :PREF_PARAM_USER_ID :@""], @"userId", nil];
    
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
            NSArray *tmp = (NSArray *)json;
            NSDictionary *reviewJson = [tmp objectAtIndex:0];
            if([[reviewJson objectForKey:@"status"] isEqualToString:@"ok"]) {
                @try {
                    _commentModel = [[CommentModel alloc] init:json];
                    [self performSegueWithIdentifier:@"commentSegue" sender:self];
                    
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
-(void)getEditorPick
{
    [utility showProgressDialog:self];
    
    
    NSURL *URL = [NSURL URLWithString:API_POST_GET_MY_EDITOR];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:[pref getSharedPreference:nil :PREF_PARAM_USER_ID :@""], @"userId", nil];
    
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
            if(json == nil) return;
            if([json objectForKey:@"status"]) {
                @try {
                    _editorPickerModel = [[productModel alloc] init:[json objectForKey:@"Data"]];
                    [self performSegueWithIdentifier:@"editorSegue" sender:self];
                    
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

- (IBAction)valueuserClicked:(id)sender {
    
}
- (IBAction)reviewClicked:(id)sender {
    _reviewTable.hidden = NO;
    _commentTable.hidden = YES;
    _editorpickTable.hidden = YES;
    
    _reviewView.hidden = NO;
    _friendTable.hidden = YES;
    
    selection = 0;
//    [self getMyReview];
//    [self performSegueWithIdentifier:@"reviewSegue" sender:self];
}
- (IBAction)commentClicked:(id)sender {
    _reviewTable.hidden = YES;
    _commentTable.hidden = NO;
    _editorpickTable.hidden = YES;
    
    _reviewView.hidden = NO;
    _friendTable.hidden = YES;
    
    selection = 1;
//    [self getComment];
//    [self performSegueWithIdentifier:@"commentSegue" sender:self];
}
- (IBAction)editorpickClicked:(id)sender {
    _reviewTable.hidden = YES;
    _commentTable.hidden = YES;
    _editorpickTable.hidden = NO;
    
    _reviewView.hidden = NO;
    _friendTable.hidden = YES;
    
    selection = 2;
//    [self getEditorPick];
}
- (IBAction)AllReviewClicked:(id)sender {
    _reviewView.hidden = NO;
    _friendTable.hidden = YES;
}
- (IBAction)FriendClicked:(id)sender {
    _reviewView.hidden = YES;
    _friendTable.hidden = NO;
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
    if([[segue identifier] isEqualToString:@"reviewSegue"])
    {
        MyReviewViewController *vc = [segue destinationViewController];
        vc.productModel = _reviewModel;
        
        [vc viewWillAppear:true];
        //[vc.myTable reloadData];
    }
    if([[segue identifier] isEqualToString:@"commentSegue"])
    {
        MyCommentViewController *vc = [segue destinationViewController];
        vc.commentModel = _commentModel;
        [vc.myTable reloadData];

    }
    if([[segue identifier] isEqualToString:@"editorSegue"])
    {
        MyEditorPickViewController *vc = [segue destinationViewController];
        vc.productModel = _editorPickerModel;
        
        [vc.myTable reloadData];
//        [vc viewWillAppear:true];
    }
}


@end
