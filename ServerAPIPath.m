//
//  ServerAPIPath.m
//  Rentcar
//
//  Created by suju on 12/03/15.
//  Copyright (c) 2015 wuguang. All rights reserved.
//

#import "ServerAPIPath.h"
//member
NSString *const API_POST_LOGIN = (API_BASE_URL @"login.php/?");
NSString *const API_POST_LOGIN_SNS = (API_BASE_URL @"login_sns.php/?");
NSString *const API_POST_GETCATEGORY = (API_BASE_URL @"GetCategory.php/");

NSString *const API_POST_CHECK_NUM=(API_BASE_URL @"chk_number.php/?");
NSString *const API_POST_REGISTER_MYCARNUM=(API_BASE_URL @"regist_carnum.php/?");
NSString *const API_POST_PLATE = ( API_HEADER @"plate/kaka.php");
NSString *const API_POST_CHECK_EMAIL=( API_BASE_URL @"chk_email.php/?");
NSString *const API_POST_SEND_SMS=( API_BASE_URL @"sms.php/?");
NSString *const API_POST_REGIST_MEMBER=( API_BASE_URL @"regist_member.php/?");
NSString *const API_POST_REGIST_TOKEN=( API_BASE_URL @"regist_device.php/?");
NSString *const API_POST_MY_CARNUM_LIST= ( API_BASE_URL @"getCarnum.php/?");
NSString *const API_POST_FIND_EMAIL = ( API_BASE_URL @"find.email.php/?");
NSString *const API_POST_NOTICE_LIST = ( API_BASE_URL @"getNoticeList.php/?");
NSString *const API_URL_PAYMENT = (@"http://tamu.kakaoapps.co.kr/pg/pg.php");
NSString *const API_URL_FIND_ADDRESS_DETAIL=(API_BASE_URL @"zipcode.php/?");
NSString *const API_POST_FAQ_LIST=(API_BASE_URL @"getFaq.php/?");
NSString *const API_POST_QUESTION_LIST=(API_BASE_URL @"getHelp.php/?");
NSString *const API_POST_REGIST_QUESTION=(API_BASE_URL @"regist_Help.php/?");
NSString *const API_POST_MODIFY_QUESTION=(API_BASE_URL @"modify_Help.php/?");
NSString *const API_POST_DELETE_QUESTION=(API_BASE_URL @"del_help.php/?");

NSString *const API_POST_PROVISION=(API_BASE_URL @"getAgreement.php/?");
NSString *const API_POST_CHAT_LIST=( API_BASE_URL @"Call_history.php/?");
NSString *const API_POST_REGIST_CALL=( API_BASE_URL @"regist_call.php/?");
NSString *const API_POST_CALL_LIST=(API_BASE_URL @"getCallList.php/?");
NSString *const API_POST_DELETE_LIST=(API_BASE_URL @"del_call.php/?");
NSString *const API_POST_DELETE_CARNUM=(API_BASE_URL @"del_carnum.php/?");
NSString *const API_POST_MODIFY_MEMBER=( API_BASE_URL @"modify_member.php/?");

@implementation ServerAPIPath

@end
