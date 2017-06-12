//
//  promotionModel.m
//  iosreviewApp
//
//  Created by dan jin on 6/1/17.
//  Copyright © 2017 star. All rights reserved.
//

#import "promotionModel.h"

@implementation promotionModel

-(id)initCoupon:(NSDictionary*)jsonObject
{
    if((self = [super init]) != nil ) {
        [self initWithCouponJsonObject:jsonObject];
    }
    
    return self;
}

-(void) initWithCouponJsonObject:(NSDictionary*)jsonObject
{
    NSArray *Coupon = (NSArray *)jsonObject;
    
    self.photo = [[NSMutableArray alloc] init];
    self.title = [[NSMutableArray alloc] init];
    self.startdate = [[NSMutableArray alloc] init];
    self.enddate = [[NSMutableArray alloc] init];
    self.others = [[NSMutableArray alloc] init];
    self.promotion_id = [[NSMutableArray alloc] init];
    
    for(NSDictionary *obj in Coupon) {
        [self.promotion_id addObject:[obj objectForKey:@"promotion_id"]];
        [self.title addObject:[obj objectForKey:@"product_name"]];
        [self.photo addObject:[obj objectForKey:@"image"]];
        [self.startdate addObject:[obj objectForKey:@"start_date"]];
        [self.enddate addObject:[obj objectForKey:@"end_date"]];
        [self.others addObject:[obj objectForKey:@"Percent"]];
    }
}

-(id)initFreeStuff:(NSDictionary*)jsonObject
{
    if((self = [super init]) != nil ) {
        [self initWithFreeStuffJsonObject:jsonObject];
    }
    
    return self;
}
-(void) initWithFreeStuffJsonObject:(NSDictionary*)jsonObject
{
    NSArray *freestuff = (NSArray *)jsonObject;
    
    self.photo = [[NSMutableArray alloc] init];
    self.title = [[NSMutableArray alloc] init];
    self.startdate = [[NSMutableArray alloc] init];
    self.enddate = [[NSMutableArray alloc] init];
    self.others = [[NSMutableArray alloc] init];
    self.promotion_id = [[NSMutableArray alloc] init];
    
    for(NSDictionary *obj in freestuff) {
        [self.promotion_id addObject:[obj objectForKey:@"promotion_id"]];
        [self.title addObject:[obj objectForKey:@"product_name"]];
        [self.photo addObject:[obj objectForKey:@"image"]];
        [self.startdate addObject:[obj objectForKey:@"start_date"]];
        [self.enddate addObject:[obj objectForKey:@"end_date"]];
        [self.others addObject:[obj objectForKey:@"number_of_product"]];
    }
    
}

-(id)initLimitedTime:(NSDictionary*)jsonObject
{
    if((self = [super init]) != nil ) {
        [self initWithLimitedTimeJsonObject:jsonObject];
    }
    
    return self;
}
-(void) initWithLimitedTimeJsonObject:(NSDictionary*)jsonObject
{
    NSArray *limittime = (NSArray *)jsonObject;
    
    self.photo = [[NSMutableArray alloc] init];
    self.title = [[NSMutableArray alloc] init];
    self.startdate = [[NSMutableArray alloc] init];
    self.enddate = [[NSMutableArray alloc] init];
    self.others = [[NSMutableArray alloc] init];
    self.promotion_id = [[NSMutableArray alloc] init];
    
    for(NSDictionary *obj in limittime) {
        [self.promotion_id addObject:[obj objectForKey:@"promotion_id"]];
        [self.title addObject:[obj objectForKey:@"product_name"]];
        [self.photo addObject:[obj objectForKey:@"image"]];
        [self.startdate addObject:[obj objectForKey:@"start_date"]];
        [self.enddate addObject:[obj objectForKey:@"end_date"]];
        [self.others addObject:[obj objectForKey:@"time"]];
    }
   
}
@end
