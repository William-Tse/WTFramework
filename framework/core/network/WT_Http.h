//
//   ▼▲       ▲▼  ▼▲▼▲▼▲▼▲▼▲▼
//    ▼▲  ▲  ▲▼       ▲▼
//     ▼▲▼ ▼▲▼        ▲▼
//      ▼   ▼         ▲▼
//
//  Copyright © 2016 WTFramework. All rights reserved.
//  Created by William.Tse on 16/7/14.
//
//  WT_Http.h
//  WTFramework
//

#import "WT_Precompile.h"

#import <AFNetworking.h>
#import "NSObject+WT_Http.h"

NS_ASSUME_NONNULL_BEGIN

@interface WTHttp : NSObject

@singleton(WTHttp)

+ (void)setBaseUrl:(NSString *)baseUrl;
+ (void)setMemoryCapacity:(NSUInteger)memoryCapacity;
+ (void)setdiskCapacity:(NSUInteger)diskCapacity;

+ (void)setRequestHeader:(NSString *)value forKey:(NSString *)key;

+ (void)handleBeforeSuccess:(id (^)(NSURLResponse *response, id responseData))beforeSuccess;
+ (void)handleAfterSuccess:(void (^)(NSURLResponse *response, id responseData))afterSuccess;
+ (void)handleBeforeFailure:(BOOL (^)(NSURLResponse *response, NSError *err))beforeFailure;
+ (void)handleAfterFailure:(void (^)(NSURLResponse *response, NSError *err))afterFailure;

#pragma mark -

+ (void)get:(NSString *)url parameters:(nullable id)parameters success:(nullable void (^)(id data))success failure:(nullable BOOL (^)(NSError *err))failure responder:(nullable id)responder;
+ (void)post:(NSString *)url parameters:(nullable id)parameters success:(nullable void (^)(id data))success failure:(nullable BOOL (^)(NSError *err))failure responder:(nullable id)responder;
+ (void)upload:(NSString *)url parameters:(id)parameters formData:(void (^)(id <AFMultipartFormData> formData))formData progress:(nullable void (^)(NSProgress *progess))progress success:(nullable void (^)(id data))success failure:(nullable BOOL (^)(NSError *err))failure responder:(nullable id)responder;
+ (void)download:(NSString *)url parameters:(id)parameters savePath:(NSString *)savePath  progress:(nullable void (^)(NSProgress *progess))progress success:(nullable void (^)(id data))success failure:(nullable BOOL (^)(NSError *err))failure responder:(nullable id)responder;

+ (void)cancelRequestByIdentifier:(NSUInteger)identifier;
+ (void)cancelRequestsByIdentifiers:(NSArray *)array;

+ (void)clearCachedResponses;

@end

NS_ASSUME_NONNULL_END
