//
//  recentProductModel.m
//  iosreviewApp
//
//  Created by ymamsMacOSX on 6/27/17.
//  Copyright © 2017 star. All rights reserved.
//

#import "recentProductModel.h"

@implementation recentProductModel


-(id)init:(NSDictionary*)jsonObject
{
    if((self = [super init]) != nil ) {
        [self initWithJsonObject:jsonObject];
    }
    
    return self;
}

-(void) initWithJsonObject:(NSDictionary*)jsonObject
{
    self.product_title = [[NSMutableArray alloc] init];
    self.product_photo = [[NSMutableArray alloc] init];
    self.product_rate = [[NSMutableArray alloc] init];
    self.sale_price = [[NSMutableArray alloc] init];
    self.review_count = [[NSMutableArray alloc] init];
    
    self.product_id = [[NSMutableArray alloc] init];
    self.category_id = [[NSMutableArray alloc] init];
    
    
    NSArray * arrObject = (NSArray *)jsonObject;
    
    for(NSDictionary *obj in arrObject) {
        [self.product_title addObject:[obj objectForKey:@"name"]];
        [self.sale_price addObject:[obj objectForKey:@"sale_price"]];
        [self.product_rate addObject:[obj objectForKey:@"averageReview"]];
        [self.product_photo addObject:[obj objectForKey:@"primary_photos"]];
        
        [self.product_id addObject:[obj objectForKey:@"product_id"]];
        [self.category_id addObject:[obj objectForKey:@"category_id"]];
        
        NSDictionary *productReview = [obj objectForKey:@"ProdcutReview"];
        if(productReview == nil)
            [self.review_count addObject:@"0"];
        else
            [self.review_count addObject:[productReview objectForKey:@"TotalReviewCount"]];
    }
}


@end
