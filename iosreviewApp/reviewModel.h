//
//  reviewModel.h
//  iosreviewApp
//
//  Created by star on 5/23/17.
//  Copyright © 2017 star. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface reviewModel : NSObject

@property (nonatomic, retain) NSMutableArray *name;
@property (nonatomic, retain) NSMutableArray *product_id;
@property (nonatomic, retain) NSMutableArray *category_id;
@property (nonatomic, retain) NSMutableArray *primary_photos;
@property (nonatomic, retain) NSMutableArray *sale_price;
@property (nonatomic, retain) NSMutableArray *totalReviewCount;
@property (nonatomic, retain) NSMutableArray *review;
@property (nonatomic, retain) NSMutableArray *comment;

-(id)init:(NSDictionary*)jsonObject;
-(void) initWithJsonObject:(NSDictionary*)jsonObject;

@end
