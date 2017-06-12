//
//  reviewDetailModel.h
//  iosreviewApp
//
//  Created by dan jin on 6/5/17.
//  Copyright © 2017 star. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface reviewDetailModel : NSObject

@property (nonatomic, retain) NSMutableArray *product_reviewid;
@property (nonatomic, retain) NSMutableArray *product_id;
@property (nonatomic, retain) NSMutableArray *user_id;
@property (nonatomic, retain) NSMutableArray *review;
@property (nonatomic, retain) NSMutableArray *photo;
@property (nonatomic, retain) NSMutableArray *comment;
@property (nonatomic, retain) NSMutableArray *firstname;
@property (nonatomic, retain) NSMutableArray *user_photo;
@property (nonatomic, retain) NSMutableArray *point;
@property (nonatomic, retain) NSMutableArray *commentCount;
@property (nonatomic, retain) NSMutableArray *like_status;
@property (nonatomic, retain) NSMutableArray *like;
@property (nonatomic, retain) NSMutableArray *dislike;
@property (nonatomic, retain) NSMutableArray *recommended;



-(id)init:(NSDictionary*)jsonObject;
-(void) initWithJsonObject:(NSDictionary*)jsonObject;

@end
