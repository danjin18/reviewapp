//
//  FriendModel.h
//  iosreviewApp
//
//  Created by ymamsMacOSX on 6/27/17.
//  Copyright © 2017 star. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FriendModel : NSObject

@property (nonatomic, retain) NSMutableArray *user_name;
@property (nonatomic, retain) NSMutableArray *user_photo;
@property (nonatomic, retain) NSMutableArray *user_status;
@property (nonatomic, retain) NSMutableArray *user_phone;
@property (nonatomic, retain) NSMutableArray *user_id;

-(id)init:(NSDictionary*)jsonObject;
-(void) initWithJsonObject:(NSDictionary*)jsonObject;

@end
