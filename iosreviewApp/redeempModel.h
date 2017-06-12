//
//  redeempModel.h
//  iosreviewApp
//
//  Created by dan jin on 6/1/17.
//  Copyright © 2017 star. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface redeempModel : NSObject

@property (nonatomic, retain) NSMutableArray *photo;
@property (nonatomic, retain) NSMutableArray *point;
@property (nonatomic, retain) NSMutableArray *id;

-(id)init:(NSDictionary*)jsonObject;
-(void) initWithJsonObject:(NSDictionary*)jsonObject;

@end
