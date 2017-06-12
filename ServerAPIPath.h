//
//  ServerAPIPath.h
//  Rentcar
//
//  Created by suju on 12/03/15.
//  Copyright (c) 2015 wuguang. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifdef DEBUG
#define API_BASE_URL @"http://52.78.15.209/api/"
#else
#define API_BASE_URL @"http://52.78.15.209/api/"
#endif
#define API_HEADER @"http://52.78.15.209/api/"
//member
extern NSString *const API_POST_LOGIN;
extern NSString *const API_POST_GETCATEGORY;




extern NSString *const API_POST_LOGIN_SNS;
extern NSString *const API_POST_CHECK_NUM;
extern NSString *const API_POST_PLATE;
extern NSString *const API_POST_REGISTER_MYCARNUM;
extern NSString *const API_POST_CHECK_EMAIL;
extern NSString *const API_POST_SEND_SMS;
extern NSString *const API_POST_REGIST_MEMBER;
extern NSString *const API_POST_REGIST_TOKEN;
extern NSString *const API_POST_FIND_EMAIL;
extern NSString *const API_POST_MY_CARNUM_LIST;
extern NSString *const API_POST_NOTICE_LIST;
extern NSString *const API_URL_FIND_ADDRESS_DETAIL;
extern NSString *const API_POST_FAQ_LIST;
extern NSString *const API_POST_QUESTION_LIST;
extern NSString *const API_POST_PROVISION;
extern NSString *const API_POST_CHAT_LIST;
extern NSString *const API_POST_REGIST_CALL;
extern NSString *const API_POST_CALL_LIST;
extern NSString *const API_POST_DELETE_LIST;
extern NSString *const API_POST_REGIST_QUESTION;
extern NSString *const API_POST_MODIFY_QUESTION;
extern NSString *const API_POST_DELETE_QUESTION;

extern NSString *const API_POST_DELETE_CARNUM;
extern NSString *const API_POST_MODIFY_MEMBER;



@interface ServerAPIPath : NSObject

@end
