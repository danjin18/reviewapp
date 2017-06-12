//
//  utility.h
//  pmpireApp
//
//  Created by star on 1/30/17.
//  Copyright © 2017 star. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface utility : NSObject

+(BOOL) isValidEmail:(NSString *)checkString;
+(BOOL)isNumeric:(NSString*)inputString;

+ (void) showProgressDialog:(UIViewController*)controller;
+ (void) hideProgressDialog;

+(void) alertDialog:(NSString*)messageString;

@end
