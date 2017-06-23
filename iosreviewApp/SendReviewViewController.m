//
//  SendReviewViewController.m
//  iosreviewApp
//
//  Created by dan jin on 6/4/17.
//  Copyright © 2017 star. All rights reserved.
//

#import "SendReviewViewController.h"

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
#import "ServerAPICall.h"

@interface SendReviewViewController ()
{
    Preference *pref;
}
@end

@implementation SendReviewViewController

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

}

- (IBAction)uploadClicked:(id)sender {
/*    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *pickerViewController =[[UIImagePickerController alloc]init];
        pickerViewController.allowsEditing = YES;
        pickerViewController.delegate = self;
        pickerViewController.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:pickerViewController animated:YES completion:nil];
    } else {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"Camera is not available" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    }*/
    UIImagePickerController *pickerViewController = [[UIImagePickerController alloc] init];
    pickerViewController.allowsEditing = YES;
    pickerViewController.delegate = self;
    [pickerViewController setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    [self presentViewController:pickerViewController animated:YES completion:nil];
}

- (IBAction)postClicked:(id)sender {
    if([_comment.text isEqualToString:@""])
    {
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"please type comment", @"") delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        
        [myAlertView show];
        
        return;
    }
    [utility showProgressDialog:self];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    // add image data
    UIImage *yourImage= _upload_photo.image;
    
    [params setObject:[pref getSharedPreference:nil :PREF_PARAM_USER_ID :@""] forKey:@"user_id"];
    
    [params setObject:[NSString stringWithFormat:@"%f", [_rate value]] forKey:@"review"];
    [params setObject:_comment.text forKey:@"comment"];
    [params setObject:_product_id forKey:@"product_id"];
    
    if(yourImage != nil)
    {
        [params setObject:@"1" forKey:@"image"];
    }
    NSString *recommend=@"";
    if(_yesBtn.selected)
        recommend = @"YES";
    
    [params setObject:recommend forKey:@"recommended"];
    
    
    [ServerAPICall callPOSTMultipart:API_POST_ADD_REVIEWS image:yourImage :@"image" success:^(ServerResultRef s)
     {
         if(s == nil)
         {
             [utility hideProgressDialog];
             return;
         }
         NSDictionary* jsonObject = (NSDictionary*)s;
         long status = [[jsonObject objectForKey:@"status"] longValue];
         if(status == 1) {
             @try {
                 
             }
             @catch (NSException *e) {
                 NSLog(@"responseInvoiceList - JSONException : %@", e.reason);
             }
         }
         [utility hideProgressDialog];
         
         UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:nil message:[jsonObject objectForKey:@"message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                 
        [myAlertView show];
     }
     failure:^(ServerErrorResult *err)
     {
         
     }
     params:params];
/*    [ServerAPICall callPOSTMultipart:API_POST_ADD_REVIEWS imageArray:[[utility getInstance] arrOfflinePhotos] :arrImageParam
                             success: ^(ServerResultRef s) {
                                 if(s == nil) {
                                     [utility hideProgressDialog];
                                     return;
                                 }
                                 NSDictionary* jsonObject = (NSDictionary*)s;
                                 @try {
                                     int s = self.invoiceModel.arrDeliveryPhotoUrl.count;
                                     for(int i=0;i<[[utility getInstance] arrOfflinePhotos].count;i++)
                                     {
                                         NSString *photoUrl = [jsonObject objectForKey:[NSString stringWithFormat:@"photo_url%d",i+s]];
                                         if(photoUrl!=nil && ![photoUrl  isEqual: @""])
                                             [self.invoiceModel.arrDeliveryPhotoUrl addObject:photoUrl];
                                     }
                                     
                                     [[[Utility getInstance]arrOfflinePhotos] removeAllObjects];
                                     [[Utility getInstance] setOfflinePhotos:self.invoiceModel.strNo];
                                 }
                                 @catch (NSException *e) {
                                     NSLog(@"responseInvoiceList - JSONException : %@", e.reason);
                                 }
                                 [Utility hideProgressDialog];
                             }
                             failure:^(ServerErrorResult *err) {
                                 [[Utility getInstance] showToastMessage:err];
                                 [Utility hideProgressDialog];
                             }
                              params:params];*/
/*    NSMutableDictionary* _params = [[NSMutableDictionary alloc] init];
    
    [_params setObject:[pref getSharedPreference:nil :PREF_PARAM_USER_ID :@""] forKey:@"user_id"];

    [_params setObject:[NSString stringWithFormat:@"%f", [_rate value]] forKey:@"review"];
    [_params setObject:_comment.text forKey:@"comment"];
    [_params setObject:_product_id forKey:@"product_id"];
    
    NSString *recommend=@"";
    if(_yesBtn.selected)
        recommend = @"YES";

    [_params setObject:recommend forKey:@"recommended"];
    
    // the boundary string : a random string, that will not repeat in post data, to separate post data fields.
    NSString *BoundaryConstant = @"----------V2ymHFg03ehbqgZCaKO6jy";
    
    // string constant for the post parameter 'file'. My server uses this name: `file`. Your's may differ
    NSString* FileParamConstant = @"image";
    
    // the server url to which the image (or the media) is uploaded. Use your server url here
    NSURL* requestURL = [NSURL URLWithString:API_POST_ADD_REVIEWS];
    
    // create request
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [request setHTTPShouldHandleCookies:NO];
    [request setTimeoutInterval:30];
    [request setHTTPMethod:@"POST"];
    
    // set Content-Type in HTTP header
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", BoundaryConstant];
    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    // post body
    NSMutableData *body = [NSMutableData data];
    
    // add params (all params are strings)
    for (NSString *param in _params) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", param] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@\r\n", [_params objectForKey:param]] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    // add image data
    UIImage *yourImage= _upload_photo.image;
    NSData *imageData = UIImagePNGRepresentation(yourImage);
    
    if (imageData) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"image.png\"\r\n", FileParamConstant] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:imageData];
        [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // setting the body of the post to the reqeust
    [request setHTTPBody:body];
    
    // set the content-length
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[body length]];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    // set URL
    [request setURL:requestURL];
    
    [utility showProgressDialog:self];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:
                                  ^(NSData *data, NSURLResponse *response, NSError *error) {
                                      
                                      [utility hideProgressDialog];
                                      if (data == nil) {
//                                          [self printCannotLoad];
                                      } else {
                                          NSLog(@"%@", response);
                                          
                                          NSLog(@"%@",data);
//                                          [self printSuccess];
                                      }
                                  }];
    [task resume];*/
}

- (void) selectImage:(UIButton *) sender {
    NSLog(@"selectImage");
    UIImagePickerController *pickerViewController = [[UIImagePickerController alloc] init];
    pickerViewController.allowsEditing = YES;
    pickerViewController.delegate = self;
    [pickerViewController setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    [self presentViewController:pickerViewController animated:YES completion:nil];
    /*
     UIImagePickerController *picker = [[UIImagePickerController alloc] init];
     picker.delegate = self;
     picker.allowsEditing = YES;
     picker.sourceType = UIImagePickerControllerSourceTypeCamera;
     
     [self presentViewController:picker animated:YES completion:NULL];
     */
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    self.upload_photo.image = chosenImage;
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
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
