//
//  MyFriendModel.h
//  iosreviewApp
//
//  Created by dan jin on 5/31/17.
//  Copyright © 2017 star. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyFriendModel : NSObject

@property (nonatomic, retain) NSMutableArray *user_name;
@property (nonatomic, retain) NSMutableArray *user_photo;
@property (nonatomic, retain) NSMutableArray *user_status;
@property (nonatomic, retain) NSMutableArray *user_phone;
@property (nonatomic, retain) NSMutableArray *user_id;

-(id)init:(NSDictionary*)jsonObject;
-(id)initContact:(NSDictionary*)jsonObject;
-(void) initWithJsonObject:(NSDictionary*)jsonObject;
-(void) initWithContactObject:(NSDictionary*)jsonObject;
-(void) initWithLoadingObject:(NSDictionary*)jsonObject;
@end
