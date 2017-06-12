//
//  ServerAPIPath.m
//  Rentcar
//
//  Created by suju on 12/03/15.
//  Copyright (c) 2015 wuguang. All rights reserved.
//

#import "ServerAPIPath.h"
//member
NSString *const API_POST_LOGIN = (API_BASE_URL @"user_login.php/?");
NSString *const API_POST_GET_TOP_CATEGOTY = (API_BASE_URL @"GetCategory.php/?");
NSString *const API_POST_GET_FEATURE_REVIEW = (API_BASE_URL @"GetLatesttopreview.php/?");
NSString *const API_POST_REGISTERATION = (API_BASE_URL @"user_registration.php/?");
NSString *const API_POST_FORGOT_PASSWORD = (API_BASE_URL @"foregot.php/?");
NSString *const API_POSTPRODUCT_LIST = (API_BASE_URL @"GetProduct.php/?");
NSString *const API_POST_GET_ALL_PRODUCT_PRICE = (API_BASE_URL @"GetAllProductPrice.php");
NSString *const API_POST_GET_PRODUCT_REVIEW = (API_BASE_URL @"GetProductReview.php");
NSString *const API_POST_GET_MY_REVIEWS = (API_BASE_URL @"GetMyReview.php/?");
NSString *const API_POST_GET_MY_COMMENTS = (API_BASE_URL @"comments.php/?");
NSString *const API_POST_GET_MY_EDITOR = (API_BASE_URL @"editorpick.php/?");
NSString *const API_POST_CHANGE_PASSWORD = (API_BASE_URL @"ChangePassword.php/?");
NSString *const API_POST_EDIT_PROFILE = (API_BASE_URL @"UserEdit.php/?");
NSString *const API_POST_GET_COUPONS = (API_BASE_URL @"GetCoupon.php/?");
NSString *const API_POST_GET_FREESTUFF = {API_BASE_URL @"GetFreeStuff.php/?"};
NSString *const API_POST_LIMITED_TIME = {API_BASE_URL @"LimitedTime.php/?"};
NSString *const API_POST_GET_POINTS = {API_BASE_URL @"getpoints.php/?"};
NSString *const API_POST_GET_MY_FRIEND = {API_BASE_URL @"getMyFriend.php/?"};
NSString *const API_POST_ADD_REVIEWS = {API_BASE_URL @"AddProductReview.php/?"};
NSString *const API_POST_EDIT_NOTIFICATION = {API_BASE_URL @"EditNotification.php/?"};
NSString *const API_POST_GET_REDEEPTION = {API_BASE_URL @"GetRedeemption.php/?"};
NSString *const API_POST_ADDRESS = {API_BASE_URL @"address.php/?"};
NSString *const API_POST_GET_SURPRISE = {API_BASE_URL @"getsurprise.php/?"};
NSString *const API_POST_GET_HISTORY = {API_BASE_URL @"history.php/?"};
NSString *const API_POST_BARCODE_SRARCH = {API_BASE_URL @"BarcodeSearch.php/?"};
NSString *const API_POST_SEARCH_CONNECT = {API_BASE_URL @"search.php/?"};
NSString *const API_POST_ADD_RECENT_VISIT = {API_BASE_URL @"AddToRecentView.php/?"};
NSString *const API_POST_ADD_LIKE = {API_BASE_URL @"AddLikeDisLike.php/?"};
NSString *const API_POST_FIND_FRIENDS = {API_BASE_URL @"findFriend.php/?"};
NSString *const API_POST_GET_RECENT_VIEW = {API_BASE_URL @"GetRecentView.php/?"};
NSString *const API_POST_ADD_CLICK = {API_BASE_URL @"addclick.php/?"};
NSString *const API_POST_ADD_NEWFRIENDS = {API_BASE_URL @"addnewfriend.php/?"};
NSString *const API_POST_GET_SUGGESTED_FRIEND = {API_BASE_URL @"getSuggestedFriend.php/?"};

@implementation ServerAPIPath

@end
