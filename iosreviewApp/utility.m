//
//  utility.m
//  pmpireApp
//
//  Created by star on 1/30/17.
//  Copyright © 2017 star. All rights reserved.
//

#import "utility.h"
#import "MBProgressHUD.h"

@implementation utility

MBProgressHUD  *gHUD = nil;
BOOL gIsShowHUD = NO;
int  gHUDRequesCount = 0;

+(BOOL) isValidEmail:(NSString *)checkString
{
    checkString = [checkString lowercaseString];
    BOOL stricterFilter = YES;
    NSString *stricterFilterString = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSString *laxString = @".+@.+\\.[A-Za-z]{2}[A-Za-z]*";
    
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:checkString];
}

+ (void) showProgressDialog:(UIViewController*)controller {
    if(YES == gIsShowHUD) {
        gHUDRequesCount++;
        return;
    }
    
    if(true) {
        UIWindow* w_pMainWindow = [[UIApplication sharedApplication].windows objectAtIndex:0];

        gHUD = [MBProgressHUD showHUDAddedTo:w_pMainWindow animated:YES];
        gHUD.mode = MBProgressHUDModeIndeterminate;
        gHUD.labelText = NSLocalizedString(@"Loading", @"");
        //        gHUD.labelText = @"";
        [gHUD show:NO];
    }
    gIsShowHUD = YES;
}

+ (void) hideProgressDialog {
    
    if(gHUDRequesCount != 0) {
        gHUDRequesCount--;
    }
    else if(gIsShowHUD == YES) {
        
        if(true) {
            [gHUD hide:NO];
        }
        
        gIsShowHUD = NO;
        gHUDRequesCount = 0;
    }
}

+(BOOL)isNumeric:(NSString*)inputString{
    NSCharacterSet *alphaNumbersSet = [NSCharacterSet decimalDigitCharacterSet];
    NSCharacterSet *stringSet = [NSCharacterSet characterSetWithCharactersInString:inputString];
    return [alphaNumbersSet isSupersetOfSet:stringSet];
}

+(void) alertDialog:(NSString*)messageString {
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:messageString
                          message:nil
                          delegate: self
                          cancelButtonTitle:NSLocalizedString(@"Cancel", @"")
                          otherButtonTitles:nil];
    [alert show];
}

@end
