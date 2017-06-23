//
//  CommentModel.h
//  iosreviewApp
//
//  Created by dan jin on 5/29/17.
//  Copyright © 2017 star. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommentModel : NSObject

@property (nonatomic, retain) NSMutableArray *product_title;
@property (nonatomic, retain) NSMutableArray *product_comment;
@property (nonatomic, retain) NSMutableArray *product_photo;

-(id)init:(NSDictionary*)jsonObject;
-(id)initComment:(NSDictionary*)jsonObject;

-(void) initWithJsonObject:(NSDictionary*)jsonObject;
-(void) initWithAddCommentJsonObject:(NSDictionary*)jsonObject;

@end
