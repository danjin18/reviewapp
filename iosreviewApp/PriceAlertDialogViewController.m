//
//  PriceAlertDialogViewController.m
//  iosreviewApp
//
//  Created by star on 5/25/17.
//  Copyright © 2017 star. All rights reserved.
//

#import "PriceAlertDialogViewController.h"
#import "ExternalLinkViewController.h"

#import <AFNetworking.h>
#import "ServerAPIPath.h"

#import "utility.h"
#import "AppDelegate.h"

#import "Preference.h"
#import "Constants.h"

#import <AFNetworking.h>
#import "UIImageView+AFNetworking.h"
#import "ServerAPIPath.h"

@interface PriceAlertDialogViewController ()
{
    NSInteger selected_row;
    
    Preference *pref;
}
@end

@implementation PriceAlertDialogViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    pref = [Preference getInstance];
    
    _notFoundLabel.hidden = YES;
    _priceTable.hidden = YES;
    
    [self getPriceList];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *priceTableIdentifier = @"PriceTableItem";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:priceTableIdentifier];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:priceTableIdentifier];
    }
    
    UILabel *priceLabel = (UILabel *)[cell viewWithTag:100];
    priceLabel.text = [_pricevalue objectAtIndex:indexPath.row];
    
    UILabel *siteLabel = (UILabel *)[cell viewWithTag:200];
    siteLabel.text = [_site objectAtIndex:indexPath.row];
    
    return cell;
}
-(void)getPriceList {
    
    [utility showProgressDialog:self];
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:_product_id,@"product_id",
                                nil];

    NSURL *URL = [NSURL URLWithString:API_POST_GET_ALL_PRODUCT_PRICE];
    
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
                    self.pricevalue = [[NSMutableArray alloc] init];
                    self.site = [[NSMutableArray alloc] init];
                    self.product = [[NSMutableArray alloc] init];
                    
                    if([_selStore isEqualToString:@"online"]) {
                        NSArray *arrPrice = [json objectForKey:@"liveUrl"];
                        
                        if(arrPrice == nil)
                        {
                            _notFoundLabel.hidden = NO;
                            _priceTable.hidden = YES;
                        }
                        else{
                            for(NSDictionary *priceObj in arrPrice) {
                                [self.site addObject:[priceObj objectForKey:@"website_type"]];
                                [self.product addObject:[priceObj objectForKey:@"product_url"]];
                                [self.pricevalue addObject:[priceObj objectForKey:@"price"]];
                            }
                            _notFoundLabel.hidden = YES;
                            _priceTable.hidden = NO;
                        }
                        
                    }
                    else {
                        NSArray *arrPrice = [json objectForKey:@"priceList"];
                        
                        if(arrPrice == nil)
                        {
                            _notFoundLabel.hidden = NO;
                            _priceTable.hidden = YES;
                        }
                        else
                        {
                            for(NSDictionary *priceObj in arrPrice) {
                                [self.site addObject:[priceObj objectForKey:@"adminDetail"]];
                                [self.product addObject:@""];
                                [self.pricevalue addObject:[priceObj objectForKey:@"price"]];
                            }
                            _notFoundLabel.hidden = YES;
                            _priceTable.hidden = NO;
                        }
                        
                    }
                    [_priceTable reloadData];
                    
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

- (NSInteger)tableView:(UITableView *)_tableView numberOfRowsInSection:(NSInteger)section
{
    return [_pricevalue count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}
- (void)tableView:(UITableView *)_tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    selected_row = indexPath.row;
    [self performSegueWithIdentifier:@"siteSegue" sender:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)dialogCloseClicked:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([[segue identifier] isEqualToString:@"siteSegue"])
    {
        UINavigationController *navController = (UINavigationController *)segue.destinationViewController;
        ExternalLinkViewController *controller = (ExternalLinkViewController *)navController.topViewController;
        controller.curPos = selected_row;
        controller.site = _site;
    }
}


@end
