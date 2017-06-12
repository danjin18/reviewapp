//
//  surpriseModel.m
//  iosreviewApp
//
//  Created by dan jin on 6/2/17.
//  Copyright © 2017 star. All rights reserved.
//

#import "surpriseModel.h"

@implementation surpriseModel

-(id)init:(NSDictionary*)jsonObject
{
    if((self = [super init]) != nil ) {
        [self initWithJsonObject:jsonObject];
    }
    
    return self;
}

-(void) initWithJsonObject:(NSDictionary*)jsonObject
{
    NSArray *surprise = (NSArray *)jsonObject;
    
    self.photo = [[NSMutableArray alloc] init];
    self.title = [[NSMutableArray alloc] init];
    self.expiry = [[NSMutableArray alloc] init];
    self.review = [[NSMutableArray alloc] init];
    self.sid = [[NSMutableArray alloc] init];
    self.points = [[NSMutableArray alloc] init];
    
    for(NSDictionary *obj in surprise) {
        [self.photo addObject:[obj objectForKey:@"image"]];
        [self.title addObject:[obj objectForKey:@"title"]];
        [self.expiry addObject:[obj objectForKey:@"end_Date"]];
        [self.review addObject:[obj objectForKey:@"Description"]];
        [self.sid addObject:[obj objectForKey:@"sId"]];
        [self.points addObject:[obj objectForKey:@"points"]];
    }
}

@end
