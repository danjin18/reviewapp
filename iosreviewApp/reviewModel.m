//
//  reviewModel.m
//  iosreviewApp
//
//  Created by star on 5/23/17.
//  Copyright © 2017 star. All rights reserved.
//

#import "reviewModel.h"

@implementation reviewModel

-(id)init:(NSDictionary*)jsonObject
{
    if((self = [super init]) != nil ) {
        [self initWithJsonObject:jsonObject];
    }
    
    return self;
}

-(void) initWithJsonObject:(NSDictionary*)jsonObject
{
    NSArray *reviews = (NSArray *)jsonObject;
    
    self.name = [[NSMutableArray alloc] init];
    self.product_id = [[NSMutableArray alloc] init];
    self.category_id = [[NSMutableArray alloc] init];
    self.primary_photos = [[NSMutableArray alloc] init];
    self.sale_price = [[NSMutableArray alloc] init];
    self.totalReviewCount = [[NSMutableArray alloc] init];
    self.review = [[NSMutableArray alloc] init];
    self.comment = [[NSMutableArray alloc] init];

    for(NSDictionary *review in reviews) {
        [self.name addObject:[review objectForKey:@"name"]];
        [self.product_id addObject:[review objectForKey:@"product_id"]];
        [self.category_id addObject:[review objectForKey:@"category_id"]];
        [self.primary_photos addObject:[review objectForKey:@"primary_photos"]];
        [self.sale_price addObject:[review objectForKey:@"sale_price"]];
        
        NSDictionary *product = [review objectForKey:@"ProdcutReview"];
        [self.totalReviewCount addObject:[product objectForKey:@"TotalReviewCount"]];
        
        NSDictionary *product_review = [product objectForKey:@"review"];
        [self.review addObject:[product_review objectForKey:@"review"]];
        [self.comment addObject:[product_review objectForKey:@"comment"]];
    }

}
@end
