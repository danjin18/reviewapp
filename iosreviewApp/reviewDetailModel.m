//
//  reviewDetailModel.m
//  iosreviewApp
//
//  Created by dan jin on 6/5/17.
//  Copyright © 2017 star. All rights reserved.
//

#import "reviewDetailModel.h"

@implementation reviewDetailModel

-(id)init:(NSDictionary*)jsonObject
{
    if((self = [super init]) != nil ) {
        [self initWithJsonObject:jsonObject];
    }
    
    return self;
}

-(void) initWithJsonObject:(NSDictionary*)jsonObject
{
    NSArray *detailReview = (NSArray *)jsonObject;
    
    self.product_reviewid = [[NSMutableArray alloc] init];
    self.product_id = [[NSMutableArray alloc] init];
    self.user_id = [[NSMutableArray alloc] init];
    self.review = [[NSMutableArray alloc] init];
    self.photo = [[NSMutableArray alloc] init];
    self.comment = [[NSMutableArray alloc] init];
    self.firstname = [[NSMutableArray alloc] init];
    self.user_photo = [[NSMutableArray alloc] init];
    self.point = [[NSMutableArray alloc] init];
    self.commentCount = [[NSMutableArray alloc] init];
    self.like_status = [[NSMutableArray alloc] init];
    self.like = [[NSMutableArray alloc] init];
    self.dislike = [[NSMutableArray alloc] init];
    self.recommended = [[NSMutableArray alloc] init];
    
    for(NSDictionary *obj in detailReview) {
        [self.product_reviewid addObject:[obj objectForKey:@"product_review_id"]];
        [self.product_id addObject:[obj objectForKey:@"product_id"]];
        [self.user_id addObject:[obj objectForKey:@"user_id"]];
        [self.review addObject:[obj objectForKey:@"review"]];
        [self.photo addObject:[obj objectForKey:@"photo"]];
        [self.comment addObject:[obj objectForKey:@"comment"]];
        
        NSDictionary *user = [obj objectForKey:@"userDetail"];
        [self.firstname addObject:[user objectForKey:@"firstname"]];
        [self.user_photo addObject:[user objectForKey:@"user_image"]];
        [self.point addObject:[user objectForKey:@"point"]];
        
        [self.commentCount addObject:[obj objectForKey:@"commentCount"]];
        [self.like_status addObject:[obj objectForKey:@"like_status"]];
        [self.like addObject:[obj objectForKey:@"like"]];
//        [self.dislike addObject:[obj objectForKey:@"like"]];
        [self.dislike addObject:@"0"];
        [self.recommended addObject:[obj objectForKey:@"recommended"]];
    }
}


@end
