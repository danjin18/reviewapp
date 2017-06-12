//
//  redeempModel.m
//  iosreviewApp
//
//  Created by dan jin on 6/1/17.
//  Copyright © 2017 star. All rights reserved.
//

#import "redeempModel.h"

@implementation redeempModel

-(id)init:(NSDictionary*)jsonObject
{
    if((self = [super init]) != nil ) {
        [self initWithJsonObject:jsonObject];
    }
    
    return self;
}

-(void) initWithJsonObject:(NSDictionary*)jsonObject
{
    NSArray *redeemp = (NSArray *)jsonObject;
    
    self.photo = [[NSMutableArray alloc] init];
    self.point = [[NSMutableArray alloc] init];
    self.id = [[NSMutableArray alloc] init];
    
    for(NSDictionary *obj in redeemp) {
        [self.id addObject:[obj objectForKey:@"id"]];
        [self.photo addObject:[obj objectForKey:@"image"]];
        [self.point addObject:[obj objectForKey:@"points"]];
    }
}


@end
