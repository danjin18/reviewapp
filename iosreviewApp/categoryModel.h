//
//  categoryModel.h
//  iosreviewApp
//
//  Created by star on 5/21/17.
//  Copyright © 2017 star. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface categoryModel : NSObject

@property (nonatomic, retain) NSMutableArray *category_id;
@property (nonatomic, retain) NSMutableArray *name;
@property (nonatomic, retain) NSMutableArray *photos;

-(id)init:(NSDictionary*)jsonObject;
-(void) initWithJsonObject:(NSDictionary*)jsonObject;

@end
