//
//  FindFriendViewController.m
//  iosreviewApp
//
//  Created by dan jin on 6/7/17.
//  Copyright © 2017 star. All rights reserved.
//

#import "FindFriendViewController.h"
#import "MyFriendTableViewCell.h"

#import "Preference.h"
#import "Constants.h"

#import <AFNetworking.h>
#import "UIImageView+AFNetworking.h"
#import "ServerAPIPath.h"

#import "utility.h"
#import "AppDelegate.h"

#import "SWRevealViewController.h"
#import "ContactViewController.h"
#import "SearchViewController.h"
#import "ScanController.h"

#import <AddressBook/ABAddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

@interface FindFriendViewController ()
{
    Preference *pref;
    NSString *fullfriendname;
}
@end

@implementation FindFriendViewController

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
    
    _tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                            action:@selector(facebookClicked:)];
    
    [_facebookBtn addGestureRecognizer:_tapRecognizer];
    
    _tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                             action:@selector(contactnumberClicked:)];
    
    [_contactBtn addGestureRecognizer:_tapRecognizer];
    
    pref = [Preference getInstance];
    
    [_friendTable registerNib:[UINib nibWithNibName:@"MyFriendTableViewCell" bundle:nil] forCellReuseIdentifier:@"MyFriendTableViewCell"];
    
    [self initContact];
}
-(void)initContact
{
    ABAddressBookRef addressBook = ABAddressBookCreate();
    
    __block BOOL accessGranted = NO;
    
    if (&ABAddressBookRequestAccessWithCompletion != NULL) { // We are on iOS 6
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
            accessGranted = granted;
            dispatch_semaphore_signal(semaphore);
        });
        
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        //        dispatch_release(semaphore);
    }
    
    else { // We are on iOS 5 or Older
        accessGranted = YES;
        [self getContactsWithAddressBook:addressBook];
    }
    
    if (accessGranted) {
        [self getContactsWithAddressBook:addressBook];
    }
}

- (IBAction)facebookClicked:(UITapGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateEnded){
        //code here
        [self getFacebookFriend];
    }
}

- (IBAction)contactnumberClicked:(UITapGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateEnded){
        //code here
        [self initContact];
    }
}

// Get the contacts.
- (void)getContactsWithAddressBook:(ABAddressBookRef )addressBook {
    
    NSString *fullname = @"";
    NSString *number = @"";
    
    _contactList = [[NSMutableArray alloc] init];
    CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(addressBook);
    CFIndex nPeople = ABAddressBookGetPersonCount(addressBook);
    
    for (int i=0;i < nPeople;i++)
    {
        NSMutableDictionary *dOfPerson=[NSMutableDictionary dictionary];
        
        ABRecordRef ref = CFArrayGetValueAtIndex(allPeople,i);
        
        //For username and surname
        ABMultiValueRef phones =(__bridge ABMultiValueRef)((__bridge NSString*)ABRecordCopyValue(ref, kABPersonPhoneProperty));
        
        CFStringRef firstName, lastName;
        firstName = ABRecordCopyValue(ref, kABPersonFirstNameProperty);
        lastName  = ABRecordCopyValue(ref, kABPersonLastNameProperty);
        [dOfPerson setObject:[NSString stringWithFormat:@"%@ %@", firstName, lastName] forKey:@"name"];
        
        if([fullname isEqualToString:@""])
            fullname = [NSString stringWithFormat:@"%@ %@", firstName, lastName];
        else
           fullname = [NSString stringWithFormat:@"%@||%@",fullname, [NSString stringWithFormat:@"%@ %@", firstName, lastName]];
        
        // For getting the user image.
        UIImage *contactImage;
        if(ABPersonHasImageData(ref)){
            contactImage = [UIImage imageWithData:(__bridge NSData *)ABPersonCopyImageData(ref)];
        }
        
        //For Email ids
        ABMutableMultiValueRef eMail  = ABRecordCopyValue(ref, kABPersonEmailProperty);
        if(ABMultiValueGetCount(eMail) > 0) {
            [dOfPerson setObject:(__bridge NSString *)ABMultiValueCopyValueAtIndex(eMail, 0) forKey:@"email"];
            
        }
        
        //For Phone number
        NSString* mobileLabel;
        NSString *mobilenumber;
        for(CFIndex i = 0; i < ABMultiValueGetCount(phones); i++)
        {
            mobileLabel = (__bridge NSString*)ABMultiValueCopyLabelAtIndex(phones, i);
            if([mobileLabel isEqualToString:(NSString *)kABPersonPhoneMobileLabel])
            {
                [dOfPerson setObject:(__bridge NSString*)ABMultiValueCopyValueAtIndex(phones, i) forKey:@"Phone"];
                
                if(i == 0)
                    mobilenumber = (__bridge NSString*)ABMultiValueCopyValueAtIndex(phones, i);
                
            }
            else if ([mobileLabel isEqualToString:(NSString*)kABPersonPhoneIPhoneLabel])
            {
                [dOfPerson setObject:(__bridge NSString*)ABMultiValueCopyValueAtIndex(phones, i) forKey:@"Phone"];
                
                if(i == 0)
                    mobilenumber = (__bridge NSString*)ABMultiValueCopyValueAtIndex(phones, i);
                
                break ;
            }
            
        }
        if([number isEqualToString:@""])
            number = mobilenumber;
        else
            number = [NSString stringWithFormat:@"%@||%@",number, mobilenumber];
        [_contactList addObject:dOfPerson];
    }
    NSLog(@"Contacts = %@",_contactList);
    
    [self getFriend:fullname phonenumber:number];
}

-(void)getFriend:(NSString *)fullname phonenumber:(NSString *)phone
{
    [utility showProgressDialog:self];
    
    
    NSURL *URL = [NSURL URLWithString:API_POST_FIND_FRIENDS];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:[pref getSharedPreference:nil :PREF_PARAM_USER_ID :@""], @"user_id",
                                fullname, @"name",
                                phone, @"number",
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
            long status = [[json objectForKey:@"status"] longValue];
            if(status == 1) {
                @try {
                    _myFriendModel = [[MyFriendModel alloc] init:[json objectForKey:@"Data"]];
                    [self.friendTable reloadData];
                }
                @catch (NSException *e) {
                    NSLog(@"responseInvoiceList - JSONException : %@", e.reason);
                }
            }
            else
                [[AppDelegate sharedAppDelegate] showToastMessage:NSLocalizedString(@"not fild friend.", @"")];
        }
        
        
    } failure:^(NSURLSessionDataTask  *task, NSError  *error) {
        
        [utility hideProgressDialog];
        [[AppDelegate sharedAppDelegate] showToastMessage:error.localizedDescription];
        
    }];
    
    
}

-(void)getFacebookFriend
{
    fullfriendname = @"";
    if ([FBSDKAccessToken currentAccessToken])
    {
        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me/friends" parameters:nil]
         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
                                      id result, NSError *error) {
             if (!error) {
                 NSLog(@"fetched user:%@", result);
                 NSArray *friends = [result objectForKey:@"data"];
                 for(NSDictionary *friend in friends)
                 {
                     NSString *friend_name;
                     friend_name = [friend objectForKey:@"name"];
                     
                     if([fullfriendname isEqualToString:@""])
                         fullfriendname = [NSString stringWithFormat:@"%@", friend_name];
                     else
                         fullfriendname = [NSString stringWithFormat:@"%@||%@",fullfriendname, friend_name];
                 }
                 [self getFacebookFriend:fullfriendname];
             }
         }];
    }
}

-(void)getFacebookFriend:(NSString *)fullname
{
    [utility showProgressDialog:self];
    
    
    NSURL *URL = [NSURL URLWithString:API_POST_FIND_FRIENDS];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:[pref getSharedPreference:nil :PREF_PARAM_USER_ID :@""], @"user_id",
                                fullname, @"name",
                                @"", @"number",
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
            long status = [[json objectForKey:@"status"] longValue];
            if(status == 1) {
                @try {
                    _myFriendModel = [[MyFriendModel alloc] init:[json objectForKey:@"Data"]];
                    [self.friendTable reloadData];
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
    MyFriendTableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:@"MyFriendTableViewCell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[MyFriendTableViewCell alloc] init];
    }
    NSString *photoUrl = [self.myFriendModel.user_photo objectAtIndex:indexPath.row];
    NSString *name = [self.myFriendModel.user_name objectAtIndex:indexPath.row];
    
    [cell setPhotoCell:photoUrl];
    [cell setNameCell:name];
    [cell setFollowCell:@"0"];
    
    cell.followImage.userInteractionEnabled = YES;
    cell.followImage.tag = indexPath.row;
    
    UITapGestureRecognizer *tapped = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(followAction:)];
    tapped.numberOfTapsRequired = 1;
    [cell.followImage addGestureRecognizer:tapped];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)_tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.myFriendModel.user_name count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}
- (void)tableView:(UITableView *)_tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_tableView deselectRowAtIndexPath:indexPath animated:NO];
    //   selected_row = (int)indexPath.row;
}

-(void)followAction :(id) sender
{
    UITapGestureRecognizer *gesture = (UITapGestureRecognizer *) sender;
    NSLog(@"Tag = %ld", gesture.view.tag);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
