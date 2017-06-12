//
//  FacebookUtils.h
//  jiome
//
//  Created by zhaochenghe on 10/4/15.
//  Copyright (c) 2015 jn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Preference.h"

@interface FacebookUtils : NSObject{
    
    Preference *pref;
    UIViewController *curController;
}

+(FacebookUtils*)getInstance;

-(NSString*) buildFacebookAvatarUrl;
//-(NSString*)getSavedFacebookUserEmail;
-(Boolean)isLoggedInToFacebook;

-(UIViewController *)currentController;

-(void)connectToFacebook:(UIViewController *)controller;
-(void)disconnectFromFacebook;

@end
