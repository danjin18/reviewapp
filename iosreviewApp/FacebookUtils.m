//
//  FacebookUtils.m
//  jiome
//
//  Created by zhaochenghe on 10/4/15.
//  Copyright (c) 2015 jn. All rights reserved.
//

#import "FacebookUtils.h"
#import "Constants.h"
#import "Utility.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>

#import <AFNetworking.h>
#import "ServerAPIPath.h"

#import "AppDelegate.h"

static FacebookUtils* instance = nil;
NSString *fullname;

@implementation FacebookUtils



+(FacebookUtils*)getInstance{	    if(!instance){
    instance = [[super allocWithZone:NULL]init];
}
    return instance;
}

-(id)init{
    self = [super init];
    if(self != nil){
        pref = [Preference getInstance];
    }
    return self;
}

-(NSString*) buildFacebookAvatarUrl
{
    FBSDKAccessToken *accessToken = [FBSDKAccessToken currentAccessToken];
    if(accessToken && accessToken.userID)
        return [self buildFacebookAvatarUrl:accessToken.userID];
    //    else
    //        return  [pref getSharedPreference:nil :PREF_PARAM_USER_IMAGEURL :@""];
    
    return nil;
}

-(NSString*) buildFacebookAvatarUrl:(NSString*)userID
{
    FBSDKAccessToken *accessToken = [FBSDKAccessToken currentAccessToken];
    NSString *res = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=normal", userID];
    if(accessToken)
        res =[NSString stringWithFormat:@"%@&access_token=%@",res,accessToken.tokenString];
    return res;
}

//-(NSString*)getSavedFacebookUserEmail
//{
//    if([self isLoggedInToFacebook]) {
//      return   [pref getSharedPreference:nil :PREF_PARAM_USER_EMAIL :@""];
//    }
//    return nil;
//}


-(Boolean)isLoggedInToFacebook
{
    FBSDKAccessToken *accessToken = [FBSDKAccessToken currentAccessToken];
    return accessToken != nil;
}

-(void)saveFacebookInfo:(FBSDKProfile *)profile
{
    if(profile) {
        [pref putSharedPreference:nil :PREF_PARAM_USER_ID :profile.userID];
        //        [pref putSharedPreference:nil :PREF_PARAM_USER_NAME :profile.name];
    } else {
        //        [pref putSharedPreference:self :PREF_PARAM_USER_NAME :@""];
        [pref putSharedPreference:self :PREF_PARAM_USER_ID :@""];
        //        [pref putSharedPreference:self :PREF_PARAM_IS_LOGIN :@"NO"];
    }
}

-(UIViewController *)currentController
{
    return curController;
}

-(void)connectToFacebook:(UIViewController *)controller
{
    curController = controller;
    
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    login.loginBehavior = FBSDKLoginBehaviorNative;

    [login
     logInWithReadPermissions:@[@"public_profile", @"email",@"user_photos",@"user_birthday"]
     handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
         if(error)
         {
             NSLog(@"Process error");
         } else if(result.isCancelled) {
             NSLog(@"Cancelled");
         } else {
             NSLog(@"Logged in");
             
             NSLog(@"user id:%@",[FBSDKAccessToken currentAccessToken].userID);
             NSLog(@"user name:%@", [FBSDKProfile currentProfile].name);
             if([result.grantedPermissions containsObject:@"email"])
             {
                 if([FBSDKAccessToken currentAccessToken]) {
                     NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
                     [parameters setValue:@"id,first_name,last_name,name,email,gender,birthday" forKey:@"fields"];
                     FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:parameters];
                     [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                         // Since we're only requesting /me, we make a simplifying assumption that any error
                         // means the token is bad.
                         if (!error) {
                             NSLog(@"fetched user:%@",result);
                             NSString *id = [result objectForKey:@"id"];
                             NSString *name = [result objectForKey:@"name"];
                             NSString *email = [result objectForKey:@"email"];
                             
                             NSString *firstname = [result objectForKey:@"first_name"];
                             NSString *lastname = [result objectForKey:@"last_name"];
                             
                             NSString *photoUrl = [self buildFacebookAvatarUrl];
                             
//                             [pref putSharedPreference:nil :PREF_PARAM_USER_ID :id];
                             [pref putSharedPreference:nil :PREF_PARAM_USER_IMAGE :photoUrl];
                             [pref putSharedPreference:nil :PREF_PARAM_USER_NAME :name];
                             [pref putSharedPreference:nil :PREF_PARAM_USER_EMAIL :email];
                             [pref putSharedPreference:nil :PREF_PARAM_USER_FIRSTNAME:firstname];
                             [pref putSharedPreference:nil :PREF_PARAM_USER_LASTNAME:lastname];
                             
                             [self siteLogin:firstname last:lastname fb_id:id fullname:name email:email];
                         }
                     }];
                 }
             }
             
         }
     }];
}

-(void)disconnectFromFacebook
{
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login logOut];
    //    [self saveFacebookInfo:nil];
}

-(void)siteLogin:(NSString *)firstname last:(NSString *)lastname fb_id:(NSString *)fbid fullname:(NSString *)fullname email:(NSString *)useremail
{
    [utility showProgressDialog:curController];
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:@"mobile",@"type",
                                @"facebook",@"connect",
                                fbid,@"fb_id",
                                firstname,@"first_name",
                                lastname, @"last_name",
                                useremail, @"emailID",
                                fullname,@"fb_username",
                                nil];
    
    NSURL *URL = [NSURL URLWithString:API_POST_REGISTERATION];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST:URL.absoluteString parameters:parameters progress:nil success:^(NSURLSessionDataTask * task, id  responseObject) {
        
        [utility hideProgressDialog];
        if (responseObject != nil) {
            NSError *error = nil;
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&error];
            
            if([json objectForKey:@"status"]) {
                NSDictionary *info = [json objectForKey:@"Data"];
                
                NSArray *arrinfo = (NSArray *)info;
                NSDictionary *userinfo = [arrinfo objectAtIndex:0];
                
                [pref putSharedPreference:nil :PREF_PARAM_USER_ID :[userinfo objectForKey:@"id"]];

//                [pref putSharedPreference:nil :PREF_PARAM_USER_AGE :[userinfo objectForKey:@"age"]];
//                [pref putSharedPreference:nil :PREF_PARAM_USER_PHONE :[userinfo objectForKey:@"phone"]];
                [pref putSharedPreference:nil :PREF_PARAM_USER_POINT :[userinfo objectForKey:@"point"]];
                
                [pref settedLogin:TRUE];
                
//                [self getFacebookFriend];
                [curController performSegueWithIdentifier:@"signinSegue" sender:nil];
            }
            else {
                [[AppDelegate sharedAppDelegate] showToastMessage:NSLocalizedString(@"request failed", @"")];
            }
            
        }
        
    } failure:^(NSURLSessionDataTask  *task, NSError  *error) {
        [utility hideProgressDialog];
        [[AppDelegate sharedAppDelegate] showToastMessage:error.localizedDescription];
        
    }];
}

-(NSString *)getFacebookFriend
{
    fullname = @"";
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
                     
                     if([fullname isEqualToString:@""])
                         fullname = [NSString stringWithFormat:@"%@", friend_name];
                     else
                         fullname = [NSString stringWithFormat:@"%@||%@",fullname, friend_name];
                 }
             }
         }];
    }
    
    return fullname;
}

@end
