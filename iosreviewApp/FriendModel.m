//
//  FriendModel.m
//  iosreviewApp
//
//  Created by ymamsMacOSX on 6/27/17.
//  Copyright © 2017 star. All rights reserved.
//

#import "FriendModel.h"

@implementation FriendModel
-(id)init:(NSDictionary*)jsonObject
{
    if((self = [super init]) != nil ) {
        [self initWithJsonObject:jsonObject];
    }
    
    return self;
}

-(void) initWithJsonObject:(NSDictionary*)jsonObject
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
