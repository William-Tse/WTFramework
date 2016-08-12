//
//   ▼▲       ▲▼  ▼▲▼▲▼▲▼▲▼▲▼
//    ▼▲  ▲  ▲▼       ▲▼
//     ▼▲▼ ▼▲▼        ▲▼
//      ▼   ▼         ▲▼
//
//  Copyright © 2016 WTFramework. All rights reserved.
//  Created by William.Tse on 16/7/14.
//
//  WT_Model.h
//  WTFramework
//

#import "WT_Precompile.h"

@interface WTModel : NSObject//<NSCoding>

+ (instancetype)model;
- (instancetype)initWithDictionary:(NSDictionary *)otherDictionary;

@end

