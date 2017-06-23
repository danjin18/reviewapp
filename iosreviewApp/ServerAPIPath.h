//
//  ServerAPIPath.h
//  Rentcar
//
//  Created by suju on 12/03/15.
//  Copyright (c) 2015 wuguang. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifdef DEBUG
#define API_BASE_URL @"http://ansfy.com/reviewapp/webservice/"
#else
#define API_BASE_URL @"http://ansfy.com/reviewapp/webservice/"
#endif
#define API_HEADER @"http://ansfy.com/reviewapp/webservice/"
//member
extern NSString *const API_POST_LOGIN;
extern NSString *const API_POST_GET_TOP_CATEGOTY;
extern NSString *const API_POST_GET_FEATURE_REVIEW;
extern NSString *const API_POST_REGISTERATION;
extern NSString *const API_POST_FORGOT_PASSWORD;
extern NSString *const API_POSTPRODUCT_LIST;
extern NSString *const API_POST_GET_ALL_PRODUCT_PRICE;
extern NSString *const API_POST_GET_PRODUCT_REVIEW;
extern NSString *const API_POST_GET_MY_REVIEWS;
extern NSString *const API_POST_GET_MY_COMMENTS;
extern NSString *const API_POST_GET_MY_EDITOR;
extern NSString *const API_POST_CHANGE_PASSWORD;
extern NSString *const API_POST_EDIT_PROFILE;
extern NSString *const API_POST_GET_COUPONS;
extern NSString *const API_POST_GET_FREESTUFF;
extern NSString *const API_POST_LIMITED_TIME;
extern NSString *const API_POST_GET_POINTS;
extern NSString *const API_POST_GET_MY_FRIEND;
extern NSString *const API_POST_ADD_REVIEWS;
extern NSString *const API_POST_EDIT_NOTIFICATION;
extern NSString *const API_POST_GET_REDEEPTION;
extern NSString *const API_POST_ADDRESS;
extern NSString *const API_POST_GET_SURPRISE;
extern NSString *const API_POST_GET_HISTORY;
extern NSString *const API_POST_BARCODE_SRARCH;
extern NSString *const API_POST_SEARCH_CONNECT;
extern NSString *const API_POST_ADD_RECENT_VISIT;
extern NSString *const API_POST_ADD_LIKE;
extern NSString *const API_POST_FIND_FRIENDS;
extern NSString *const API_POST_GET_RECENT_VIEW;
extern NSString *const API_POST_ADD_CLICK;
extern NSString *const API_POST_ADD_NEWFRIENDS;
extern NSString *const API_POST_GET_SUGGESTED_FRIEND;
extern NSString *const API_POST_GET_REVIEW_COMMENT;
extern NSString *const API_POST_GET_COUNTRY;
@interface ServerAPIPath : NSObject

@end
