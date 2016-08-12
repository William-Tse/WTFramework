# WTFramework

## Introduction

WTFramework is an utility framework used on iOS, it packages some frequently-used capabilities, such as serialization, local database, file cache, network, signal, ... and more. Here thanks for bee framework, giving me so many good precedents and ideas. So I just standing on the shoulders of giants.

## Features

### Generics

Though xcode supports lightweight generics, but when deserializing, we can't get object class in array by that yet. Now, you can use List(ObjectType) instead of NSArray\<ObjectType *\>, no properties mapping, no own loop analyzing...as simple as you wanted.

```Objective-C

// TestModel.h
#import "TestItemModel.h"

@interface TestModel : WTModel
@property (nonatomic, strong) List(TestItemModel) *items;
@end


// TestModel.m
#import "TestModel.h"

@implementation TestModel : WTModel
@end


// TestItemModel.h
@interface TestItemModel : WTModel
@property (nonatomic, copy) NSNumber *itemId;
@property (nonatomic, copy) NSString *itemName;
@end
@generic(TestItemModel)


// TestItemModel.m
#import "TestItemModel.h"

@implementation TestItemModel : WTModel
@end
@def_generic(TestItemModel)

```

Then you can serialize or deserialize directly like this:

```Objective-C

NSString *json = @"\
{[\
    {\"itemId\":1, \"itemName\":\"Mac\"},\
    {\"itemId\":2, \"itemName\":\"IPhone\"},\
    {\"itemId\":3, \"itemName\":\"IPad\"}\
]}";

//deserialize from json
TestModel *model = [TestModel objectFromJSONString:json];

//serialize to json
NSString *str = [model toJSONString];

```

### Database

Local database is based on FMDB, and supports simple query of ORM.

```Objective-C

// UserModel.h
@interface UserModel : WTModel
@property (nonatomic, copy) NSNumber *userId;
@property (nonatomic, copy) NSNumber *userGender;
@property (nonatomic, copy) NSString *userName;
@end


// UserModel.m
#import "UserModel.h"

@implementation UserModel : WTModel

// define field attributes
WT_DATABASE_FIELD(userId, ((WTDatabaseFieldAttribute){.primaryKey=YES, .autoIncrement=YES}));
WT_DATABASE_FIELD(userGender, ((WTDatabaseFieldAttribute){.index=YES}));

@end

```
Query and update datas:

```Objective-C

[WTDatabaseQueue inDatabase:^(WTDatabase *db){
    //insert or update
    UserModel *model1 = [UserModel model];
    model1.userGender = @1;
    model1.userName = @"LiLei";
    model1.SAVE_INTO(db);

    UserModel *model2 = [UserModel model];
    model2.userGender = @0;
    model2.userName = @"HanMeimei";
    model2.SAVE_INTO(db);

    //query
    UserModel *result = UserModel.DB(db).WHERE(@"userName", @"LiLei").ORDER_ASC_BY(@"userGender")
        .GET_FIRST();

    //delete
    result.DELETE_FROM(db);

    //drop
    UserModel.DB(db).DROP();
}];

```

And, you can still use "executeScalar", "executeQuery", "executeUpdate" for complicated operation.

### Cache

Here provides file cache and memory cache, you can cache any objects. Received memory warning, memory cache data will be cleared automatically.

```Objective-C

UserModel *model = [UserModel model];

//write to file
WTFileCache *fileCache = [WTFileCache sharedInstance];
[fileCache setObject:model forKey:@"user"];

//read from file
NSData *data = [fileCache objectForKey:@"user"];
UserModel *result = [data toObjectWithClass:[UserModel class]];

```

### Network

Network invokes by AFNetworking directly, and just combines with query parameters serialization, then you can transmit NSDictionary/WTModel/NSString either. And before the responder deallocate, requesting will be cancelled.

```Objective-C

//global setting 
[WTHttp setBaseUrl:@"http://william-tse.com"];

//parameter
UserModel *model = [UserModel model];
model.userGender = @1;
model.userName = @"LiLei";

//get
[WTHttp get:@"/api/test" parameters:model success:^(id data){

    TestModel *result = [TestModel objectFromDictionary:json];
    //TODO:...

} failure:^BOOL(NSError *err){

    NSLog(@"%@", err);
    return NO;

} responder:viewController];

//post
[WTHttp post:@"http://google.com/api/test" parameters:model success:^(id data){

    TestModel *result = [TestModel objectFromDictionary:json];
    //TODO:...

} failure:^BOOL(NSError *err){

    NSLog(@"%@", err);
    return NO;

} responder:viewController];

```

### Signal

Signal is triggered when events of view control occurring. It transmits upward crossing classes and crossing files. As you like, you can forward or stop propagation at any time.

```Objective-C

ON_SIGNAL3(UIButton, signal)
{
    UIButton *button = signal.target;
    signal.handled = NO;
}

ON_SIGNAL3(UIButton, TouchDown, signal)
{
    UIButton *button = signal.target;
}

```

WTFramework supports customized signal.

```Objective-C

ON_SIGNAL3(UIButton, TouchDown, signal)
{
    id data = @"The data that you wanted to transmit";

    WTSignal *signal = [WTSignal signalWithName:@"mysignal" target:signal.target object:data];
    [self sendSignal:signal]
}

ON_SIGNAL2(mysignal, signal)
{
    NSString *data = signal.object;
}

```


