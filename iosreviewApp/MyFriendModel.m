//
//  MyFriendModel.m
//  iosreviewApp
//
//  Created by dan jin on 5/31/17.
//  Copyright © 2017 star. All rights reserved.
//

#import "MyFriendModel.h"

@implementation MyFriendModel
-(id)init:(NSDictionary*)jsonObject
{
    if((self = [super init]) != nil ) {
        [self initWithJsonObject:jsonObject];
    }
    
    return self;
}

-(id)initContact:(NSDictionary*)jsonObject
{
    if((self = [super init]) != nil ) {
        [self initWithLoadingObject:jsonObject];
    }
    
    return self;
}

-(void) initWithJsonObject:(NSDictionary*)jsonObject
{
    NSArray *friends = (NSArray *)jsonObject;
    
    self.user_name = [[NSMutableArray alloc] init];
    self.user_photo = [[NSMutableArray alloc] init];
    self.user_status = [[NSMutableArray alloc] init];
    
    for(NSDictionary *obj in friends) {
        NSDictionary *detail = [obj objectForKey:@"userDetail"];
        
        [self.user_name addObject:[NSString stringWithFormat:@"%@ %@", [detail objectForKey:@"firstname"], [detail objectForKey:@"lastname"]]];
         
        [self.user_photo addObject:[detail objectForKey:@"user_image"]];
        [self.user_status addObject:[obj objectForKey:@"Status"]];
    }
}

-(void) initWithContactObject:(NSDictionary*)jsonObject
{
    NSArray *friends = (NSArray *)jsonObject;
    
    self.user_name = [[NSMutableArray alloc] init];
    self.user_photo = [[NSMutableArray alloc] init];
    self.user_status = [[NSMutableArray alloc] init];
    
    for(NSDictionary *obj in friends) {
        
        [self.user_name addObject:[NSString stringWithFormat:@"%@", [obj objectForKey:@"fullname"]]];
        
        [self.user_photo addObject:[obj objectForKey:@"image"]];
        [self.user_status addObject:[obj objectForKey:@"status"]];
    }
}
-(void) initWithLoadingObject:(NSDictionary*)jsonObject
{
    NSArray *friends = (NSArray *)jsonObject;
    
    self.user_name = [[NSMutableArray alloc] init];
    self.user_photo = [[NSMutableArray alloc] init];
    self.user_status = [[NSMutableArray alloc] init];
    self.user_phone = [[NSMutableArray alloc] init];
    self.user_id = [[NSMutableArray alloc] init];
    
    for(NSDictionary *obj in friends) {
        
        [self.user_name addObject:[NSString stringWithFormat:@"%@", [obj objectForKey:@"fullname"]]];
        
        [self.user_photo addObject:[obj objectForKey:@"image"]];
        [self.user_phone addObject:[obj objectForKey:@"phone"]];
        [self.user_id addObject:[obj objectForKey:@"id"]];
        [self.user_status addObject:@"Approved"];
    }
}
@end
