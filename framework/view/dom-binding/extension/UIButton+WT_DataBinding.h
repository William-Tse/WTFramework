//
//   ▼▲       ▲▼  ▼▲▼▲▼▲▼▲▼▲▼
//    ▼▲  ▲  ▲▼       ▲▼
//     ▼▲▼ ▼▲▼        ▲▼
//      ▼   ▼         ▲▼
//
//  Created by William.Tse on 16/7/14.
//  Copyright © 2016 WTFramework. All rights reserved.
//
//  WT_DataBinding.h
//  WTFramework
//

#import "WT_Precompile.h"

NS_ASSUME_NONNULL_BEGIN

@interface UIView (WT_DataBinding)

@property (nullable, nonatomic, strong) id data;

- (void)bindData:(nullable id)data;
- (void)unbindData;

@end

NS_ASSUME_NONNULL_END
