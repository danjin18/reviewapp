//
//  categoryModel.m
//  iosreviewApp
//
//  Created by star on 5/21/17.
//  Copyright © 2017 star. All rights reserved.
//

#import "categoryModel.h"

@implementation categoryModel
-(id)init:(NSDictionary*)jsonObject
{
    if((self = [super init]) != nil ) {
        [self initWithJsonObject:jsonObject];
    }
    
    return self;
}

-(void) initWithJsonObject:(NSDictionary*)jsonObject
{
    NSArray *tmp = (NSArray *)jsonObject;
    NSDictionary *categories = [tmp objectAtIndex:0];
    
    NSArray *category = [categories objectForKey:@"category"];
    
    self.category_id = [[NSMutableArray alloc] init];
    self.name = [[NSMutableArray alloc] init];
    self.photos = [[NSMutableArray alloc] init];
    
    for(NSDictionary *obj in category) {
        [self.category_id addObject:[obj objectForKey:@"category_id"]];
        [self.name addObject:[obj objectForKey:@"name"]];
        [self.photos addObject:[obj objectForKey:@"photos"]];
    }
}
@end
