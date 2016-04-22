//
//  YMAdRequest.h
//  HuaiNanVideoSDK
//
//  Created by Layne on 11-11-18.
//  Copyright (c) 2012年 joying Mobile Co. Ltd. All rights reserved.
//
#import <Foundation/Foundation.h>
@class WxxURLRequest;

@interface WxxURLRequest : NSObject {
    void (^_completion_block)(BOOL finished, WxxURLRequest *request);
}

@property                       int             URLRequestTag;
@property(nonatomic)            NSTimeInterval  URLRequestTimeout;
@property(nonatomic, retain)    NSString        *URLRequestMethod;
@property(nonatomic, retain)    NSData          *URLRequestBody; // use when in POST method
@property(nonatomic, retain)    NSURL           *URLRequestURL;
@property(nonatomic, retain)    NSMutableData   *data;
@property(nonatomic, retain)    NSMutableURLRequest *urlRequest;
@property(nonatomic, retain)    NSURLResponse   *response;
@property(nonatomic, retain)    NSError         *error;

@property(nonatomic)            BOOL            hasRequested;

@property(nonatomic, retain)    NSDate          *URLRequestTimestamp;
@property(nonatomic, retain)    NSDate          *firstResponseTimestamp;
@property(nonatomic, retain)    NSDate          *finishTimestamp;
@property(nonatomic, assign)    NSInteger       statusCode;
@property(nonatomic, assign)    NSInteger       errorCode;

+ (WxxURLRequest *)hnRrequestWithURL:(NSURL *)url;

// asynchronous
- (void)URLRequestAsynchronouslyWithCompletionUsingBlock:(void (^)(BOOL finished, WxxURLRequest *request))completion;
@end


