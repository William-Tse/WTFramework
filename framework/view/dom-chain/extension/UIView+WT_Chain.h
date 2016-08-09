//
//   ▼▲       ▲▼  ▼▲▼▲▼▲▼▲▼▲▼
//    ▼▲  ▲  ▲▼       ▲▼
//     ▼▲▼ ▼▲▼        ▲▼
//      ▼   ▼         ▲▼
//
//  Created by William.Tse on 16/7/14.
//  Copyright © 2016 WTFramework. All rights reserved.
//
//  UIView+WT_Chain.h
//  WTFramework
//

#import "WT_Chain.h"


NS_ASSUME_NONNULL_BEGIN

@interface UIView (WT_Chain)

- (__kindof UIView *(^)(NSString *))NAME;
- (__kindof UIView *(^)(__nullable id))DATA;
- (__kindof UIView *(^)(NSString *, __nullable id))SET_VALUE;

- (__kindof UIView *(^)(id))DELEGATE;
- (__kindof UIView *(^)(id))DATASOURCE;

- (__kindof UIView *(^)(NSInteger))TAG;
- (__kindof UIView *(^)(BOOL))HIDDEN;
- (__kindof UIView *(^)(CGFloat))ALPHA;
- (__kindof UIView *(^)(BOOL))OPAQUE;
- (__kindof UIView *(^)(UILayoutPriority,UILayoutConstraintAxis))CONTENT_HUGGING_PRIORITY; //more higher, more priority compression
- (__kindof UIView *(^)(UILayoutPriority,UILayoutConstraintAxis))CONTENT_COMPRESSION_RESISTANCE_PRIORITY;
- (__kindof UIView *(^)(BOOL))USER_INTERACTION_ENABLED;
- (__kindof UIView *(^)(id, CGFloat))BORDER;
- (__kindof UIView *(^)(CGFloat))BORDER_RADIUS;
- (__kindof UIView *(^)(CGSize, id))BORDER_SHADOW;
- (__kindof UIView *(^)(id))BACKGROUND_COLOR;
- (__kindof UIButton *(^)(id))BACKGROUND_IMAGE;
- (__kindof UIView *(^)(UIViewContentMode))CONTENTMODE;
- (__kindof UIView *(^)(UIView *))APPENDTO;

- (__kindof UIView *(^)(NSString *))TEXT;
- (__kindof UIView *(^)(NSTextAlignment))TEXT_ALIGNMENT;
- (__kindof UIView *(^)(id))COLOR;
- (__kindof UIView *(^)(CGFloat, BOOL))FONT;
- (__kindof UIView *(^)(BOOL))EDITABLE;
- (__kindof UIView *(^)(NSString *))PLACEHOLDER;
- (__kindof UIView *(^)(UIReturnKeyType))RETURNKEY_TYPE;
- (__kindof UIView *(^)(UIKeyboardType))KEYBOARD_TYPE;

- (__kindof UIView *(^)(BOOL))ENABLED;
- (__kindof UIView *(^)(NSUInteger))NUMBER_OF_LINES;

- (__kindof UIView *(^)(id))IMAGE;

- (__kindof UIView *(^)(id))__TEXT_INSETS;
- (__kindof UIView *(^)(id))TEXT_INSETS;
- (__kindof UIView *(^)(UIViewContentMode))IMAGE_CONTENTMODE;
- (__kindof UIButton *(^)(id))__IMAGE_INSETS;
- (__kindof UIButton *(^)(id))IMAGE_INSETS;
- (__kindof UIButton *(^)(id))COLOR_HIGHLIGHTED;
- (__kindof UIButton *(^)(id))COLOR_SELECTED;
- (__kindof UIButton *(^)(id))IMAGE_HIGHLIGHTED;
- (__kindof UIButton *(^)(id))IMAGE_SELECTED;
- (__kindof UIButton *(^)(id))BACKGROUND_IMAGE_HIGHLIGHTED;
- (__kindof UIButton *(^)(id))BACKGROUND_IMAGE_SELECTED;

- (__kindof UIScrollView *(^)(BOOL))SCROLL_ENABLED;
- (__kindof UIScrollView *(^)(BOOL))SCROLL_VERTICAL_INDICATOR;
- (__kindof UIScrollView *(^)(BOOL))SCROLL_HORIZONTAL_INDICATOR;
- (__kindof UIScrollView *(^)(BOOL))SCROLL_BOUNCES;
- (__kindof UIScrollView *(^)(BOOL))SCROLL_BOUNCES_HORIZONTAL;
- (__kindof UIScrollView *(^)(BOOL))SCROLL_BOUNCES_VERTICAL;

- (__kindof UITableView *(^)(UITableViewCellSeparatorStyle))SEPARATOR_STYLE;
- (__kindof UITableView *(^)(CGFloat))ROW_HEIGHT;

- (__kindof UICollectionView *(^)(id))__ITEM_SIZE;
- (__kindof UICollectionView *(^)(id))ITEM_SIZE;
- (__kindof UICollectionView *(^)(id))__SECTION_INSET;
- (__kindof UICollectionView *(^)(id))SECTION_INSET;
- (__kindof UICollectionView *(^)(UICollectionViewScrollDirection))SCROLL_DIRECTION;
- (__kindof UICollectionView *(^)(CGFloat))MINIMUM_INTERITEM_SPACING;
- (__kindof UICollectionView *(^)(CGFloat))MINIMUM_LINE_SPACING;

- (__kindof UIPageControl *(^)(id color))PAGE_COLOR;
- (__kindof UIPageControl *(^)(id color))PAGE_CURRENT_COLOR;

@end

NS_ASSUME_NONNULL_END
