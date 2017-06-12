//
//  promotionModel.h
//  iosreviewApp
//
//  Created by dan jin on 6/1/17.
//  Copyright © 2017 star. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface promotionModel : NSObject

@property (nonatomic, retain) NSMutableArray *photo;
@property (nonatomic, retain) NSMutableArray *title;
@property (nonatomic, retain) NSMutableArray *startdate;
@property (nonatomic, retain) NSMutableArray *enddate;
@property (nonatomic, retain) NSMutableArray *others;
@property (nonatomic, retain) NSMutableArray *promotion_id;

-(id)initCoupon:(NSDictionary*)jsonObject;
-(void) initWithCouponJsonObject:(NSDictionary*)jsonObject;

-(id)initFreeStuff:(NSDictionary*)jsonObject;
-(void) initWithFreeStuffJsonObject:(NSDictionary*)jsonObject;

-(id)initLimitedTime:(NSDictionary*)jsonObject;
-(void) initWithLimitedTimeJsonObject:(NSDictionary*)jsonObject;
@end
