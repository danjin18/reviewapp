//
//  CommentModel.m
//  iosreviewApp
//
//  Created by dan jin on 5/29/17.
//  Copyright © 2017 star. All rights reserved.
//

#import "CommentModel.h"

@implementation CommentModel
-(id)init:(NSDictionary*)jsonObject
{
    if((self = [super init]) != nil ) {
        [self initWithJsonObject:jsonObject];
    }
    
    return self;
}

-(void) initWithJsonObject:(NSDictionary*)jsonObject
{
    NSArray *comment = (NSArray *)jsonObject;
    
    self.product_title = [[NSMutableArray alloc] init];
    self.product_photo = [[NSMutableArray alloc] init];
    self.product_comment = [[NSMutableArray alloc] init];
    
    for(NSDictionary *obj in comment) {
        [self.product_comment addObject:[obj objectForKey:@"comment"]];
        [self.product_title addObject:[obj objectForKey:@"name"]];
        [self.product_photo addObject:[obj objectForKey:@"primary_photos"]];
    }
}

@end
