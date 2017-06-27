//
//  surpriseModel.h
//  iosreviewApp
//
//  Created by dan jin on 6/2/17.
//  Copyright © 2017 star. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface surpriseModel : NSObject

@property (nonatomic, retain) NSMutableArray *photo;
@property (nonatomic, retain) NSMutableArray *title;
@property (nonatomic, retain) NSMutableArray *expiry;
@property (nonatomic, retain) NSMutableArray *review;
@property (nonatomic, retain) NSMutableArray *sid;
@property (nonatomic, retain) NSMutableArray *points;
@property (nonatomic, retain) NSMutableArray *status;

-(id)init:(NSDictionary*)jsonObject;
-(void) initWithJsonObject:(NSDictionary*)jsonObject;

@end
