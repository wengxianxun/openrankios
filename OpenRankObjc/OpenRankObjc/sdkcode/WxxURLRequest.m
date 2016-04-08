//
//  YMAdRequest.m
//  HuaiNanVideoSDK
//
//  Created by Layne on 11-11-18.
//  Copyright (c) 2012年 HuaiNanVideoSDK Mobile Co. Ltd. All rights reserved.
//

#import "WxxURLRequest.h"
#import <UIKit/UIKit.h>
static NSString *const kRequestMethodGET   = @"GET";
static NSString *const kRequestMethodPOST  = @"POST";

//30秒钟超时
#define kRequestTimeOut 10.0f


@interface WxxURLRequest ()
- (void)_URLRequestAsynchronously;
- (void)_URLRequestFinished:(BOOL)success;
@end

#define _RELEASE_SAFELY(__POINTER) { [__POINTER release]; __POINTER = nil; }

@implementation WxxURLRequest

#pragma mark -
#pragma mark private Methods
- (void)dealloc {
    [_URLRequestMethod release];
    [_URLRequestURL release];
    [_data release];
    [_response release];
    [_error release];
    [_completion_block release];
    [_URLRequestTimestamp release];
    [_finishTimestamp release];
    [_firstResponseTimestamp release];
    self.urlRequest = nil;
    [super dealloc];
}

- (void)_URLRequestAsynchronously {
//    @try {
//        // reset
//        // Init the data to handle the response coming back from the server.
//        if (!_data) {
//            _data = [[NSMutableData alloc] init];
//        }
//#pragma clang diagnostic push
//#pragma clang diagnostic ignored "-Wnonnull"
//        // clear content
//        [_data setData:nil];
//        
//        _RELEASE_SAFELY(_response);
//        _RELEASE_SAFELY(_error);
//        _hasRequested = NO;
//        self.statusCode = 200;
//        self.errorCode  = 0;
//        self.URLRequestTimestamp       = nil;
//        self.firstResponseTimestamp = nil;
//        self.finishTimestamp        = nil;
//        self.urlRequest             = nil;
//        
//		self.urlRequest = [NSMutableURLRequest requestWithURL:_URLRequestURL
//                                                                  cachePolicy: NSURLRequestReloadIgnoringCacheData
//                                                              timeoutInterval:_URLRequestTimeout];
//        [self.urlRequest allHTTPHeaderFields];
//        //用作负载均衡
//        NSString *mcid = @"M-CI";
//        NSString *xycid = [NSString stringWithFormat:@"X-Y%@D",mcid];
//        PhoneInfoUtilStruct *cdutil = [PhoneInfoUtil sharePhoneInfoUtil];
//        [self.urlRequest addValue:cdutil->GenerateCID() forHTTPHeaderField:xycid];
//        
//		[self.urlRequest setHTTPMethod:_URLRequestMethod];
//        if ([_URLRequestMethod isEqualToString:kRequestMethodPOST] && _URLRequestBody) {
//            [self.urlRequest setHTTPBody:_URLRequestBody];
//        }
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [[[NSURLConnection alloc] initWithRequest:self.urlRequest delegate:self] autorelease];
//            self.URLRequestTimestamp = [NSDate date];
//        });
//	}
//	@catch (NSException * exception) {
//        LOGERROR(@"%@", exception);
//	}
}

- (void)_URLRequestFinished:(BOOL)success {
    if (_completion_block) {
        _completion_block(success, self);
    }
    if (_completion_block) {
        [_completion_block release];
        _completion_block = nil;
    }
}

#pragma mark -
#pragma mark public Methods
+ (WxxURLRequest *)hnRrequestWithURL:(NSURL *)url {
    WxxURLRequest *request = [[[WxxURLRequest alloc] init] autorelease];
    request.URLRequestURL = url;
    return request;
}

- (id)init {
    self = [super init];
	if (self) {
        _URLRequestTag = 0;
        _URLRequestTimeout = kRequestTimeOut;
        _URLRequestMethod = [[NSString alloc] initWithString:kRequestMethodGET];
    }
	
	return self;
}

- (void)URLRequestAsynchronouslyWithCompletionUsingBlock:(void (^)(BOOL finished, WxxURLRequest *request))completion {
   _RELEASE_SAFELY(_completion_block);
    _completion_block = [completion copy];
    [self _URLRequestAsynchronously];
}

#pragma mark - delegate methods for asynchronous requests

- (NSCachedURLResponse*)connection:(NSURLConnection*)connection willCacheResponse:(NSCachedURLResponse*)cachedResponse {
	return nil;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    // set network activity visible
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    _RELEASE_SAFELY(_response);
    _response = [response retain];
    
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    self.statusCode = [httpResponse statusCode];
    
    self.firstResponseTimestamp = [NSDate date];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [_data appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // set network activity no visible
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
	_hasRequested = YES;
    _error = [error retain];
    self.errorCode = [error code];
    
    self.finishTimestamp = [NSDate date];
    if (!self.firstResponseTimestamp) {
        self.firstResponseTimestamp = self.finishTimestamp;
    }
    //百分三概率上报
//    int value = arc4random() % (100+1);
//    if (value<=3) {
//        WebErrorCollectionWithOPSrequest(self);
//    }
    // finish
    [self _URLRequestFinished:NO];
    NSLog(@"error:%@",error);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	// set network activity no visible
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
 
	_hasRequested = YES;
    _error = nil;
    self.finishTimestamp = [NSDate date];
    if (!self.firstResponseTimestamp) {
        self.firstResponseTimestamp = self.finishTimestamp;
    }
    
    // finish
    [self _URLRequestFinished:YES];
}

#pragma clang diagnostic pop
@end
