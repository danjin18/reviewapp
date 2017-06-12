//
//  ServerAPICall.h
//  Rentcar
//
//  Created by suju on 12/03/15.
//  Copyright (c) 2015 wuguang. All rights reserved.
//

#import <UIKit/UIKit.h>



typedef id ServerResultRef;
typedef NSString ServerErrorResult;

typedef void (^onResponse)(ServerResultRef result);
typedef void (^onErrorResponse)(ServerErrorResult *result);


@interface ServerAPICall : NSObject {
    
}


//+(void) saveHeader;
//+(void) restoreHeader;
+(void) callGET:(NSString*)url success:(onResponse)success failure:(onErrorResponse)failure;
+(void) callPOST:(NSString*)url success:(onResponse)success failure:(onErrorResponse)failure params:(NSDictionary*)params;
+(void) callPOSTMultipart:(NSString*)url image:(UIImage*)image :(NSString *)imageParam success:(onResponse)success failure:(onErrorResponse)failure params:(NSDictionary*)params;
+(void) callPOSTMultipart:(NSString*)url imageArray:(NSMutableArray*)arrImage :(NSMutableArray*)arrImageParam success:(onResponse)success failure:(onErrorResponse)failure params:(NSDictionary*)params;
//+(void) uploadPhoto:(NSString*)url image:(UIImage*)image success:(onResponse)success failure:(onErrorResponse)failure;
//+(void) calluploadPhoto:(NSString*)url image:(UIImage*)image success:(onResponse)success failure:(onErrorResponse)failure;
-(void) callGET:(NSString*)url success:(onResponse)success failure:(onErrorResponse)failure;
-(void) callPOST:(NSString*)url success:(onResponse)success failure:(onErrorResponse)failure params:(NSDictionary*)params;
//-(void) uploadPhoto:(NSString*)url image:(UIImage*)image;
@end
