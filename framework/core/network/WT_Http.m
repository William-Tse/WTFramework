//
//   ▼▲       ▲▼  ▼▲▼▲▼▲▼▲▼▲▼
//    ▼▲  ▲  ▲▼       ▲▼
//     ▼▲▼ ▼▲▼        ▲▼
//      ▼   ▼         ▲▼
//
//  Copyright © 2016 WTFramework. All rights reserved.
//  Created by William.Tse on 16/7/14.
//
//  WT_Http.m
//  WTFramework
//

#import "WT_Http.h"

#import "WT_System.h"
#import "NSObject+WT_Extension.h"
#import "NSObject+WT_Http.h"

@interface WTHttp ()

@property (nonatomic, copy) NSString *baseUrl;
@property (nonatomic, assign) NSUInteger memoryCapacity;
@property (nonatomic, assign) NSUInteger diskCapacity;

@property (nonatomic, copy) id (^beforeSuccess)(NSURLResponse *response, id responseData);
@property (nonatomic, copy) void (^afterSuccess)(NSURLResponse *response, id responseData);
@property (nonatomic, copy) BOOL (^beforeFailure)(NSURLResponse *response, id responseData);
@property (nonatomic, copy) void (^afterFailure)(NSURLResponse *response, id responseData);

@property (nonatomic, strong, readonly) AFHTTPSessionManager *manager;
@property (nonatomic, strong, readonly) NSURLCache *cache;
@property (nonatomic, strong, readonly) NSURLSessionConfiguration *configuration;

@end

@implementation WTHttp

@def_singleton(WTHttp)

- (instancetype)init
{
    self = [super init];
    if(self)
    {
        NSString *userAgent = [NSString stringWithFormat:@"%@,%@(%@) %@", [WTSystem osVersion], [WTSystem appBundleName], [WTSystem appName], [WTSystem appShortVersion]];
        
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];

        [config setHTTPAdditionalHeaders:@{@"User-Agent":userAgent}];
        //设置我们的缓存大小 其中内存缓存大小设置10M  磁盘缓存5M
        NSURLCache *cache = [[NSURLCache alloc] initWithMemoryCapacity:10 * 1024 * 1024
                                                          diskCapacity:50 * 1024 * 1024
                                                              diskPath:nil];
        [config setURLCache:cache];
        
        _manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:config];
    }
    return self;
}

+ (void)setBaseUrl:(NSString *)baseUrl
{
    [[self sharedInstance] setBaseUrl:baseUrl];
}

+ (void)setMemoryCapacity:(NSUInteger)memoryCapacity
{
    [[[self sharedInstance] cache] setMemoryCapacity:memoryCapacity];
}

+ (void)setdiskCapacity:(NSUInteger)diskCapacity
{
    [[[self sharedInstance] cache] setDiskCapacity:diskCapacity];
}

+ (void)setRequestHeader:(NSString *)value forKey:(NSString *)key
{
    [[[self sharedInstance] configuration] setHTTPAdditionalHeaders:@{key:value}];
}

+ (void)handleBeforeSuccess:(id  _Nonnull (^)(NSURLResponse * _Nonnull, id _Nonnull))beforeSuccess
{
    [[self sharedInstance] setBeforeSuccess:beforeSuccess];
}

+ (void)handleAfterSuccess:(void (^)(NSURLResponse * _Nonnull, id _Nonnull))afterSuccess
{
    [[self sharedInstance] setAfterSuccess:afterSuccess];
}

+ (void)handleBeforeFailure:(BOOL (^)(NSURLResponse * _Nonnull, NSError * _Nonnull))beforeFailure
{
    [[self sharedInstance] setBeforeFailure:beforeFailure];
}

+ (void)handleAfterFailure:(void (^)(NSURLResponse * _Nonnull, NSError * _Nonnull))afterFailure
{
    [[self sharedInstance] setAfterFailure:afterFailure];
}

+ (NSString *)requestUrlWithString:(NSString *)url
{
    if(![url rangeOfString:@"://"].length)
    {
        NSURL *baseUrl = [NSURL URLWithString:[[self sharedInstance] baseUrl]];
        return [[NSURL URLWithString:url relativeToURL:baseUrl] absoluteString];
    }
    return url;
}

+ (void)get:(NSString *)url parameters:(nullable id)parameters success:(nullable void (^)(id data))success failure:(nullable BOOL (^)(NSError *err))failure responder:(nullable id)responder
{
    NSString *requestUrl = [self requestUrlWithString:url];
    NSDictionary *dictParams = parameters ? [parameters toQueryParameters] : nil;
    
#if !(defined(_DEBUG) || defined(DEBUG))
    NSLog(@"**HTTP_REQUEST**\nGET:%@\n%@", requestUrl, dictParams);
#endif
    
    NSURLSessionDataTask *task = [[[self sharedInstance] manager] GET:requestUrl parameters:dictParams progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if(responder)
        {
            [responder cancelRequestByIdentifier:task.taskIdentifier];
        }
        id responseData = responseObject;
        if([[self sharedInstance] beforeSuccess])
        {
            responseData = [[self sharedInstance] beforeSuccess](task.response, responseObject);
        }
        if(success)
        {
            success(responseData);
        }
        if([[self sharedInstance] afterSuccess])
        {
            [[self sharedInstance] afterSuccess](task.response, responseObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull err) {
        if(responder)
        {
            [responder cancelRequestByIdentifier:task.taskIdentifier];
        }
        BOOL handled = NO;
        if([[self sharedInstance] beforeFailure])
        {
            handled = [[self sharedInstance] beforeFailure](task.response, err);
        }
        if(!handled && failure)
        {
            handled = failure(err);
        }
        if(!handled && [[self sharedInstance] afterFailure])
        {
            [[self sharedInstance] afterFailure](task.response, err);
        }
    }];
    if(responder)
    {
        [responder responderWithSession:task];
    }
}

+ (void)post:(NSString *)url parameters:(id)parameters success:(void (^)(id data))success failure:(BOOL (^)(NSError *err))failure responder:(id)responder
{
    NSString *requestUrl = [self requestUrlWithString:url];
    NSDictionary *dictParams = parameters ? [parameters toQueryParameters] : nil;
    
#if !(defined(_DEBUG) || defined(DEBUG))
    NSLog(@"**HTTP_REQUEST**\nPOST:%@\n%@", requestUrl, dictParams);
#endif
    
    NSURLSessionDataTask *task = [[[self sharedInstance] manager] GET:requestUrl parameters:dictParams progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if(responder)
        {
            [responder cancelRequestByIdentifier:task.taskIdentifier];
        }
        id responseData = responseObject;
        if([[self sharedInstance] beforeSuccess])
        {
            responseData = [[self sharedInstance] beforeSuccess](task.response, responseObject);
        }
        if(success)
        {
            success(responseData);
        }
        if([[self sharedInstance] afterSuccess])
        {
            [[self sharedInstance] afterSuccess](task.response, responseObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull err) {
        if(responder)
        {
            [responder cancelRequestByIdentifier:task.taskIdentifier];
        }
        BOOL handled = NO;
        if([[self sharedInstance] beforeFailure])
        {
            handled = [[self sharedInstance] beforeFailure](task.response, err);
        }
        if(!handled && failure)
        {
            handled = failure(err);
        }
        if(!handled && [[self sharedInstance] afterFailure])
        {
            [[self sharedInstance] afterFailure](task.response, err);
        }
    }];
    if(responder)
    {
        [responder responderWithSession:task];
    }
}

+ (void)upload:(NSString *)url parameters:(id)parameters files:(void (^)(id <AFMultipartFormData> formData))files progress:(nullable void (^)(NSProgress *progess))progress success:(nullable void (^)(id data))success failure:(BOOL (^)(NSError *err))failure responder:(id)responder
{
    NSString *requestUrl = [self requestUrlWithString:url];
    NSDictionary *dictParams = parameters ? [parameters toQueryParameters] : nil;
    
#if !(defined(_DEBUG) || defined(DEBUG))
    NSLog(@"**HTTP_REQUEST**\nPOST:%@\n%@", requestUrl, dictParams);
#endif
    
    NSURLSessionDataTask *task = [[[self sharedInstance] manager] POST:requestUrl parameters:dictParams constructingBodyWithBlock:files progress:progress success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if(responder)
        {
            [responder cancelRequestByIdentifier:task.taskIdentifier];
        }
        id responseData = responseObject;
        if([[self sharedInstance] beforeSuccess])
        {
            responseData = [[self sharedInstance] beforeSuccess](task.response, responseObject);
        }
        if(success)
        {
            success(responseData);
        }
        if([[self sharedInstance] afterSuccess])
        {
            [[self sharedInstance] afterSuccess](task.response, responseObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull err) {
        if(responder)
        {
            [responder cancelRequestByIdentifier:task.taskIdentifier];
        }
        BOOL handled = NO;
        if([[self sharedInstance] beforeFailure])
        {
            handled = [[self sharedInstance] beforeFailure](task.response, err);
        }
        if(!handled && failure)
        {
            handled = failure(err);
        }
        if(!handled && [[self sharedInstance] afterFailure])
        {
            [[self sharedInstance] afterFailure](task.response, err);
        }
    }];
    if(responder)
    {
        [responder responderWithSession:task];
    }
}

+ (void)download:(NSString *)url parameters:(id)parameters savePath:(NSString *)savePath  progress:(nullable void (^)(NSProgress *progess))progress success:(nullable void (^)(id data))success failure:(nullable BOOL (^)(NSError *err))failure responder:(nullable id)responder
{
    NSString *requestUrl = [self requestUrlWithString:url];
    NSDictionary *dictParams = parameters ? [parameters toQueryParameters] : nil;
    
#if !(defined(_DEBUG) || defined(DEBUG))
    NSLog(@"**HTTP_REQUEST**\nGET:%@\n%@", requestUrl, dictParams);
#endif
    
    NSURLSessionDataTask *task = [[[self sharedInstance] manager] GET:requestUrl parameters:dictParams progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if(responder)
        {
            [responder cancelRequestByIdentifier:task.taskIdentifier];
        }
        id responseData = responseObject;
        if([[self sharedInstance] beforeSuccess])
        {
            responseData = [[self sharedInstance] beforeSuccess](task.response, responseObject);
        }
        if([responseData isKindOfClass:[NSData class]])
        {
            [(NSData *)responseData writeToFile:savePath options:NSDataWritingAtomic error:NULL];
        }
        if(success)
        {
            success(responseData);
        }
        if([[self sharedInstance] afterSuccess])
        {
            [[self sharedInstance] afterSuccess](task.response, responseObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull err) {
        if(responder)
        {
            [responder cancelRequestByIdentifier:task.taskIdentifier];
        }
        BOOL handled = NO;
        if([[self sharedInstance] beforeFailure])
        {
            handled = [[self sharedInstance] beforeFailure](task.response, err);
        }
        if(!handled && failure)
        {
            handled = failure(err);
        }
        if(!handled && [[self sharedInstance] afterFailure])
        {
            [[self sharedInstance] afterFailure](task.response, err);
        }
    }];
    if(responder)
    {
        [responder responderWithSession:task];
    }
}

+ (void)cancelRequestByIdentifier:(NSUInteger)identifier
{
    NSArray<NSURLSessionTask *> *arr = [[[self sharedInstance] manager] tasks];
    for (NSURLSessionTask *task in arr) {
        if(task.taskIdentifier == identifier)
        {
            [task cancel];
        }
    }
}

+ (void)cancelRequestsByIdentifiers:(NSArray *)array
{
    for (NSNumber *item in array) {
        [self cancelRequestByIdentifier:[item unsignedIntegerValue]];
    }
}

+ (void)clearCachedResponses
{
    [[[self sharedInstance] cache] removeAllCachedResponses];
}

@end