//
//  ServerAPICall.m
//  etip
//


#import "ServerAPICall.h"
#import "ServerAPIPath.h"
#import "AFNetworking.h"
#import "Preference.h"
#import "Utility.h"
#import "UIImageResizing.h"

typedef enum _METHOD {
    GET,
    POST,
    MULTIPOST,
    MULTIPOST_ARRAY,
    PUT,
    DELETE
}METHOD;

NSString *const  ERR_INVALID_FORMAT_DATA = @"Invalid format data.";
NSString *const  FAIL_UPLOAD_IMAGE = @"Image upload fail.";
NSString *const  ERR_NO_NETWORK = @"Network connect error.";

#define  TIME_LIMIT (180)

#define  UPLOAD_MAX_WIDTH (300)

@interface ServerAPICall ()
{
@private
    onResponse      _successBlock;
    onErrorResponse _errorBlock;
    int             _method;
    NSString       *_url;
    NSDictionary   *_params;
    NSMutableArray *_arrImage;
    NSMutableArray *_arrImageParam;
    UIImage        *_image;
    NSString       *_imageParam;
}

@end

@implementation ServerAPICall

+(void) callGET:(NSString*)url success:(onResponse)success failure:(onErrorResponse)failure {
    
    ServerAPICall *call = [[ServerAPICall alloc] init];
    
    [call callGET:url success:success failure:failure];
}

+(void) callPOST:(NSString*)url success:(onResponse)success failure:(onErrorResponse)failure params:(NSDictionary*)params {
    
    ServerAPICall *call = [[ServerAPICall alloc] init];
    
    [call callPOST:url success:success failure:failure params:params];
}


+(void) callPOSTMultipart:(NSString*)url image:(UIImage*)image :(NSString *)imageParam success:(onResponse)success failure:(onErrorResponse)failure params:(NSDictionary*)params {
    
    ServerAPICall *call = [[ServerAPICall alloc] init];
    if(image == nil)
        [call callPOST:url success:success failure:failure params:params];
    else
        [call callPOSTMultipart :url image:image :imageParam success:success failure:failure params:params];
}

+(void) callPOSTMultipart:(NSString*)url imageArray:(NSMutableArray*)arrImage :(NSMutableArray*)arrImageParam success:(onResponse)success failure:(onErrorResponse)failure params:(NSDictionary*)params {
    
    ServerAPICall *call = [[ServerAPICall alloc] init];
    if(arrImage == nil)
        [call callPOST:url success:success failure:failure params:params];
    else
        [call callPOSTMultipart :url imageArray:arrImage :arrImageParam success:success failure:failure params:params];
}


+(void) uploadPhoto:(NSString*)url image:(UIImage*)image success:(onResponse)success failure:(onErrorResponse)failure {
    
    ServerAPICall *call = [[ServerAPICall alloc] init];
    
    [call setCallBack:success failure:failure];
    [call uploadPhoto:url image:image];
}

-(void) setCallBack:(onResponse)sucess failure:(onErrorResponse)failure {
    _successBlock = sucess;
    _errorBlock = failure;
}

-(void) callGET:(NSString*)url success:(onResponse)success failure:(onErrorResponse)failure {
    _successBlock = success;
    _errorBlock = failure;
    _method = GET;
    _url = url;
    
    [self callServerAPI];
}


-(void) callPOST:(NSString*)url success:(onResponse)success failure:(onErrorResponse)failure params:(NSDictionary*)params {
    _successBlock = success;
    _errorBlock = failure;
    _method = POST;
    _url = url;
    _params = params;
    
    [self callServerAPI];
}

-(void) callPOSTMultipart:(NSString*)url  image:(UIImage*)image :(NSString *)imageParam success:(onResponse)success failure:(onErrorResponse)failure params:(NSDictionary*)params {
    _successBlock = success;
    _errorBlock = failure;
    _method = MULTIPOST;
    _url = url;
    _params = params;
    _image = image;
    _imageParam = imageParam;
    [self callServerAPI];
}

-(void) callPOSTMultipart:(NSString*)url  imageArray:(NSMutableArray*)arrImage :(NSMutableArray*)arrImageParam success:(onResponse)success failure:(onErrorResponse)failure params:(NSDictionary*)params {
    _successBlock = success;
    _errorBlock = failure;
    _method = MULTIPOST_ARRAY;
    _url = url;
    _params = params;
    _arrImage = arrImage;
    _arrImageParam = arrImageParam;
    [self callServerAPI];
}


-(void) callServerAPI {
    // 1
    NSURL *baseURL = [NSURL URLWithString:_url];
    
    // 2
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager.requestSerializer setTimeoutInterval:TIME_LIMIT];  //Time out after TIME_LIMIT seconds
    //manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    [self initHttpHeader:manager.requestSerializer];
    
    if(_method == GET) {
        [manager GET:_url parameters:nil progress:nil
             success:^(NSURLSessionDataTask *task, id responseObject) {
                 [self preprocessResult:responseObject];
             } failure:^(NSURLSessionDataTask *task, NSError *error) {
                 _errorBlock(ERR_NO_NETWORK);
             }];
    }
    else if(_method == POST){
        if([_url rangeOfString:@"https://kairos-face-recognition"].length>0) {
            manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
            [self initHttpHeaderForRecog:manager.requestSerializer];
        }
        
        [manager POST:_url parameters:_params progress:nil
              success:^(NSURLSessionDataTask *task, id responseObject) {
                  [self preprocessResult:responseObject];
              }
              failure:^(NSURLSessionDataTask *task, NSError *error) {
                  _errorBlock(ERR_NO_NETWORK);
              }];
    }
    else if(_method == MULTIPOST) {
        UIImage *preImage = [self preProcessImage:_image];
        NSData *imageData = UIImageJPEGRepresentation(preImage,1);
        
        AFHTTPSessionManager  *manager = [AFHTTPSessionManager  manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        [manager.requestSerializer setTimeoutInterval:TIME_LIMIT];  //Time out after TIME_LIMIT seconds
        //        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"]; //text/html
        
        [self initHttpHeader:manager.requestSerializer];
        
        [manager POST:_url parameters:_params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            [formData appendPartWithFileData:imageData name:_imageParam fileName:[NSString stringWithFormat:@"%@.jpg",_imageParam] mimeType:@"image/jpeg"];
        } progress:nil success:^(NSURLSessionDataTask  *operation, id responseObject) {
            NSError *error = nil;
            NSDictionary *item = [NSJSONSerialization JSONObjectWithData:(NSData*)responseObject options:0 error:&error];
            if(error != nil) {
                _errorBlock(FAIL_UPLOAD_IMAGE);
            }
            else {
                [self preprocessResult:item];
            }
        } failure:^(NSURLSessionDataTask  *operation, NSError *error) {
            _errorBlock(ERR_NO_NETWORK);
        }];
    }
    else if(_method == MULTIPOST_ARRAY) {
        
        AFHTTPSessionManager  *manager = [AFHTTPSessionManager  manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        [manager.requestSerializer setTimeoutInterval:TIME_LIMIT];  //Time out after TIME_LIMIT seconds
        //        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"]; //text/html
        
        [self initHttpHeader:manager.requestSerializer];
        
        [manager POST:_url parameters:_params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            for(int i=0;i<_arrImage.count;i++) {
                UIImage *preImage = [_arrImage objectAtIndex:i];
                NSData *imageData = UIImageJPEGRepresentation(preImage,1);
                NSString *imageParam = [_arrImageParam objectAtIndex:i];
                [formData appendPartWithFileData:imageData name:imageParam fileName:[NSString stringWithFormat:@"%@.jpg",imageParam] mimeType:@"image/jpeg"];
            }
        } progress:nil success:^(NSURLSessionDataTask  *operation, id responseObject) {
            NSError *error = nil;
            NSDictionary *item = [NSJSONSerialization JSONObjectWithData:(NSData*)responseObject options:0 error:&error];
            if(error != nil) {
                _errorBlock(FAIL_UPLOAD_IMAGE);
            }
            else {
                [self preprocessResult:item];
            }
        } failure:^(NSURLSessionDataTask  *operation, NSError *error) {
            _errorBlock(ERR_NO_NETWORK);
        }];
    }
    
}

-(void) initHttpHeader:(AFHTTPRequestSerializer*)request {
    
    
    //    if([Common Key] != nil && [[Common Key] isEqualToString:@""] == false) {
    //        [request  setValue:[Common Key] forHTTPHeaderField:@"app-key"];
    //    }
    //
    //    [request setValue:[Common DeviceID] forHTTPHeaderField:@"device-id"];
    //    [request setValue:[Common DeviceModel] forHTTPHeaderField:@"device-model"];
    //    [request setValue:[Common OsType] forHTTPHeaderField:@"os-type"];
    //    [request setValue:[Common OsVersion] forHTTPHeaderField:@"os-version"];
    //    [request setValue:[Common AppVersion] forHTTPHeaderField:@"app-version"];
    //    [request setValue:[Common Market] forHTTPHeaderField:@"app-market"];
}

-(void) initHttpHeaderForRecog:(AFHTTPRequestSerializer*)request {
    
    [request setValue:@"resdXCz1O2mshQ0MvZLMPgKb9EuJp1iOC8tjsnFFv1LfRkO2DZ" forHTTPHeaderField:@"X-Mashape-Key"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"c6918d05" forHTTPHeaderField:@"app_id"];
    [request setValue:@"74c7562d63911a3ebe866b77739e943d" forHTTPHeaderField:@"app_key"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
}

-(void) preprocessResult:(id) JSON {
    @try {
        NSError  *error = nil;
        NSDictionary *response = (NSDictionary*)JSON;
        
        if(error != nil) {
            _errorBlock(ERR_INVALID_FORMAT_DATA);
            return;
        }
        
        //NSLog(@"post %@",response);
        if([_url rangeOfString:API_BASE_URL].length <= 0){ //|| [_url isEqualToString:API_POST_MEMBER_PHONE]) {
            _successBlock(response);
            return;
        }
        
        @try {
            int       result_value = [[response objectForKey:@"result_value"] intValue];
            NSString *result_msg  = [response objectForKey:@"result_msg"];
            
            NSLog(@"%@ - result_value : %d" , _url, result_value);
            NSLog(@"%@ - result_msg : %@" , _url, result_msg);
            
            if (result_value != 0) {
                _errorBlock(result_msg);
                return;
            }
        }
        @catch (NSException *exception) {
            
        }
        
        NSObject *result = response;
        if(result == nil) {
            _successBlock(nil);
        }
        else {
            if([result isKindOfClass:[NSNull class]] == true || ([result isKindOfClass:[NSString class]] == true && ([(NSString*)result isEqualToString:@"<null>"] == true || [(NSString*)result isEqualToString:@"null"] == true))) {
                _successBlock(nil);
            }
            else {
                _successBlock(result);
            }
        }
    }
    @catch (NSException *e) {
        NSLog(@"Post - %@",e.reason);
        _errorBlock(ERR_INVALID_FORMAT_DATA);
    }
}


-(UIImage*) preProcessImage:(UIImage*)image {
    
    CGSize imageSize = image.size;
    
    CGFloat scale = 1.0f;
    if(imageSize.width > UPLOAD_MAX_WIDTH || imageSize.height > UPLOAD_MAX_WIDTH) {
        if(imageSize.width > imageSize.height) {
            scale = UPLOAD_MAX_WIDTH / imageSize.width;
        }
        else {
            scale = UPLOAD_MAX_WIDTH / imageSize.height;
        }
    }
    
    CGSize scaleSize = CGSizeMake(imageSize.width*scale, imageSize.height*scale);
    
    UIImage *scaledImage = [image scaleToSize:scaleSize];//[UIImage imageWithCGImage:[image CGImage] scale:(image.scale * scale) orientation:(image.imageOrientation)];
    
    return scaledImage;
}

-(void) uploadPhoto:(NSString*)url image:(UIImage*)image {
    
    _method = GET;
    _url = url;
    
    UIImage *preImage = [self preProcessImage:image];
    
    NSData *imageData = UIImageJPEGRepresentation(preImage,1);
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager.requestSerializer setTimeoutInterval:TIME_LIMIT];  //Time out after TIME_LIMIT seconds
    [self initHttpHeader:manager.requestSerializer];
    
    
    [manager POST:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:imageData name:@"img_filename" fileName:@"img_filename.jpg" mimeType:@"image/jpeg"];
    } progress:nil success:^(NSURLSessionDataTask  *operation, id responseObject) {
        
        NSError *error = nil;
        NSDictionary *item = [NSJSONSerialization JSONObjectWithData:(NSData*)responseObject options:0 error:&error];
        if(error != nil) {
            _errorBlock(FAIL_UPLOAD_IMAGE);
        }
        else {
            [self preprocessResult:item];
        }
    } failure:^(NSURLSessionDataTask  *operation, NSError *error) {
        _errorBlock(FAIL_UPLOAD_IMAGE);
    }];
}

@end
