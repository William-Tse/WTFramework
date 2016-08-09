//
//   ▼▲       ▲▼  ▼▲▼▲▼▲▼▲▼▲▼
//    ▼▲  ▲  ▲▼       ▲▼
//     ▼▲▼ ▼▲▼        ▲▼
//      ▼   ▼         ▲▼
//
//  Created by William.Tse on 16/7/14.
//  Copyright © 2016 WTFramework. All rights reserved.
//
//  UIView+WT_Chain.m
//  WTFramework
//

#import "UIView+WT_Chain.h"

#import "UIView+WT_Extension.h"

@implementation UIView (WT_Chain)

- (void)logInfo:(NSString *)method info:(NSString *)info
{
#if defined(_DEBUG) || defined(DEBUG)
    NSLog(@"[ERROR]UIView \"%@\" invoke method %@(%@) failed.", self.name, method, info);
#endif
}

- (__kindof UIView *(^)(NSString *))NAME
{
    return ^id(NSString *name){
        self.name = name;
        return self;
    };
}

- (__kindof UIView *(^)(id))DATA
{
    //TODO;
    return nil;
}

- (BOOL)setObject:(id)obj withValue:(id)value forKey:(NSString *)key
{
    if(key.length)
    {
        NSRange range = [key rangeOfString:@"."];
        if(range.length)
        {
            NSString *subObjName = [key substringToIndex:range.location];
            NSString *subKey = [key substringFromIndex:range.location+1];
            if([obj respondsToSelector:NSSelectorFromString(subObjName)])
            {
                id subObj = [obj valueForKey:subObjName];
                return [self setObject:subObj withValue:value forKey:subKey];
            }
        }
        else
        {
            if([obj respondsToSelector:NSSelectorFromString(key)])
            {
                [obj setValue:value forKey:key];
                return YES;
            }
        }
    }
    return NO;
}

- (__kindof UIView *(^)(NSString *, id))SET_VALUE
{
    return ^id(NSString *property, id value){
        if(!value || ![self setObject:self withValue:value forKey:property])
        {
            [self logInfo:@"SET_VALUE" info:[NSString stringWithFormat:@"%@, %@", property, value]];
        }
        return self;
    };
}

- (__kindof UIView *(^)(NSInteger))TAG
{
    return ^id(NSInteger tag){
        self.tag = tag;
        return self;
    };
}

- (__kindof UIView *(^)(BOOL))HIDDEN
{
    return ^id(BOOL hidden){
        self.hidden = hidden;
        return self;
    };
}

- (__kindof UIView *(^)(CGFloat))ALPHA
{
    return ^id(CGFloat alpha){
        self.alpha = alpha;
        return self;
    };
}

- (__kindof UIView *(^)(BOOL))OPAQUE
{
    return ^id(BOOL opaque){
        self.opaque = opaque;
        return self;
    };
}

- (__kindof UIView *(^)(UILayoutPriority,UILayoutConstraintAxis))CONTENT_HUGGING_PRIORITY
{
    return ^id(UILayoutPriority priority, UILayoutConstraintAxis axis){
        [self setContentHuggingPriority:priority forAxis:axis];
        return self;
    };
}

- (__kindof UIView *(^)(UILayoutPriority,UILayoutConstraintAxis))CONTENT_COMPRESSION_RESISTANCE_PRIORITY
{
    return ^id(UILayoutPriority priority, UILayoutConstraintAxis axis){
        [self setContentCompressionResistancePriority:priority forAxis:axis];
        return self;
    };
}

- (__kindof UIView *(^)(BOOL))USER_INTERACTION_ENABLED
{
    return ^id(BOOL enabled){
        self.userInteractionEnabled = enabled;
        return self;
    };
}

- (__kindof UIView *(^)(id, CGFloat))BORDER
{
    return ^id(id color, CGFloat width){
        //
        UIColor *c = nil;
        if(color)
        {
            if([color isKindOfClass:[NSString class]])
            {
                c = [UIColor colorWithString:color];
            }
            else if([color isKindOfClass:[UIColor class]])
            {
                c = color;
            }
        }
        
        self.layer.borderWidth = width;
        self.layer.borderColor = c ? [c CGColor] : nil;
        
        return self;
    };
}

- (__kindof UIView *(^)(CGFloat))BORDER_RADIUS
{
    return ^id(CGFloat radius){
        self.clipsToBounds = YES;
        self.layer.cornerRadius = radius;
        return self;
    };
}

- (__kindof UIView *(^)(CGSize, id))BORDER_SHADOW
{
    return ^id(CGSize offset, id color){
        
        UIColor *c = nil;
        if(color)
        {
            if([color isKindOfClass:[NSString class]])
            {
                c = [UIColor colorWithString:color];
            }
            else if([color isKindOfClass:[UIColor class]])
            {
                c = color;
            }
        }
        
        self.layer.shadowOffset = offset;
        self.layer.shadowColor = c ? [c CGColor] : nil;
        
        return self;
    };
}

- (__kindof UIView *(^)(id))BACKGROUND_COLOR
{
    return [WTChain createColorBlockWithView:self action:^(UIColor *color) {
        self.backgroundColor = color;
    }];
}

- (__kindof UIButton *(^)(id))BACKGROUND_IMAGE
{
    return [WTChain createImageBlockWithView:self action:^(UIImage *image) {
        [(UIButton *)self setBackgroundImage:image forState:UIControlStateNormal];
    }];
}

- (__kindof UIView *(^)(UIViewContentMode))CONTENTMODE
{
    return ^id(UIViewContentMode contentMode){
        self.contentMode = contentMode;
        if([self isKindOfClass:[UIControl class]])
        {
            switch (contentMode) {
                case UIViewContentModeLeft:
                    [(UIControl *)self setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
                    break;
                case UIViewContentModeRight:
                    [(UIControl *)self setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
                    break;
                default:
                    break;
            }
        }
        return self;
    };
}

- (__kindof UIView *(^)(UIView *))APPENDTO
{
    return ^id(UIView *view){
        [view addSubview:self];
        return self;
    };
}

//---------------
//  UILabel (or UIButton,UITextField,UITextView)
//---------------

- (__kindof UIView *(^)(BOOL))ENABLED
{
    return ^id(BOOL enabled){
        if([self isKindOfClass:[UIControl class]])
        {
            [(UIControl *)self setEnabled:enabled];
        }
        else if([self respondsToSelector:NSSelectorFromString(@"enabled")])
        {
            [self setValue:[NSNumber numberWithBool:enabled] forKey:@"enabled"];
        }
        else
        {
            [self logInfo:@"ENABLED" info:[NSString stringWithFormat:@"%ld", (long)enabled]];
        }
        return self;
    };
}

- (__kindof UIView *(^)(NSString *))TEXT
{
    return ^id(NSString *text){
        if([self isKindOfClass:[UILabel class]])
        {
            [(UILabel *)self setText:text];
        }
        else if ([self isKindOfClass:[UIButton class]])
        {
            [(UIButton *)self setTitle:text forState:UIControlStateNormal];
            [(UIButton *)self setTitle:text forState:UIControlStateHighlighted];
            [(UIButton *)self setTitle:text forState:UIControlStateSelected];
            [(UIButton *)self setTitle:text forState:UIControlStateDisabled];
        }
        else if ([self isKindOfClass:[UITextField class]])
        {
            [(UITextField *)self setText:text];
        }
        else if ([self isKindOfClass:[UITextView class]])
        {
            [(UITextView *)self setText:text];
        }
        else
        {
            [self logInfo:@"TEXT" info:text];
        }
        return self;
    };
}

- (__kindof UIView *(^)(NSTextAlignment))TEXT_ALIGNMENT
{
    return ^id(NSTextAlignment alignment){
        if([self isKindOfClass:[UILabel class]])
        {
            [(UILabel *)self setTextAlignment:alignment];
        }
        else if ([self isKindOfClass:[UIButton class]])
        {
            [((UIButton *)self).titleLabel setTextAlignment:alignment];
        }
        else if ([self isKindOfClass:[UITextField class]])
        {
            [(UITextField *)self setTextAlignment:alignment];
        }
        else if ([self isKindOfClass:[UITextView class]])
        {
            [(UITextView *)self setTextAlignment:alignment];
        }
        else
        {
            [self logInfo:@"TEXT_ALIGNMENT" info:[NSString stringWithFormat:@"%ld", (long)alignment]];
        }
        return self;
    };
}

- (__kindof UIView *(^)(CGFloat, BOOL))FONT
{
    return [WTChain createFontBlockWithView:self action:^(UIFont *font) {
        if ([self isKindOfClass:[UIButton class]])
        {
            [((UIButton *)self).titleLabel setFont:font];
        }
        else if ([self respondsToSelector:NSSelectorFromString(@"font")])
        {
            [self setValue:font forKey:@"font"];
        }
        else
        {
            [self logInfo:@"FONT" info:[font description]];
        }
    }];
}

- (__kindof UIView *(^)(id))COLOR
{
    return [WTChain createColorBlockWithView:self action:^(UIColor *color) {
        if([self isKindOfClass:[UILabel class]])
        {
            [(UILabel *)self setTextColor:color];
        }
        else if ([self isKindOfClass:[UIButton class]])
        {
            [(UIButton *)self setTitleColor:color forState:UIControlStateNormal];
        }
        else if ([self isKindOfClass:[UITextField class]])
        {
            [(UITextField *)self setTextColor:color];
        }
        else if ([self isKindOfClass:[UITextView class]])
        {
            [(UITextView *)self setTextColor:color];
        }
        else if ([self respondsToSelector:NSSelectorFromString(@"color")])
        {
            [self setValue:color forKey:@"color"];
        }
        else
        {
            [self logInfo:@"COLOR" info:[color description]];
        }
    }];
}

- (__kindof UIView *(^)(BOOL))EDITABLE
{
    return ^id(BOOL editable){
        if ([self isKindOfClass:[UITextView class]])
        {
            [(UITextView *)self setEditable:editable];
        }
        else if([self respondsToSelector:NSSelectorFromString(@"editable")])
        {
            [self setValue:[NSNumber numberWithBool:editable] forKey:@"editable"];
        }
        else
        {
            [self logInfo:@"EDITABLE" info:[NSString stringWithFormat:@"%ld", (long)editable]];
        }
        return self;
    };
}

- (__kindof UIView *(^)(UIReturnKeyType))RETURNKEY_TYPE
{
    return ^id(UIReturnKeyType type){
        if ([self isKindOfClass:[UITextField class]])
        {
            [(UITextField *)self setReturnKeyType:type];
        }
        else if ([self isKindOfClass:[UITextView class]])
        {
            [(UITextView *)self setReturnKeyType:type];
        }
        else
        {
            [self logInfo:@"EDITABRETURNKEY_TYPELE" info:[NSString stringWithFormat:@"%ld", (long)type]];
        }
        return self;
    };
}

- (__kindof UIView *(^)(UIKeyboardType))KEYBOARD_TYPE
{
    return ^id(UIKeyboardType type){
        if ([self isKindOfClass:[UITextField class]])
        {
            [(UITextField *)self setKeyboardType:type];
        }
        else if ([self isKindOfClass:[UITextView class]])
        {
            [(UITextView *)self setKeyboardType:type];
        }
        else
        {
            [self logInfo:@"KEYBOARD_TYPE" info:[NSString stringWithFormat:@"%ld", (long)type]];
        }
        return self;
    };
}

- (__kindof UIView *(^)(NSString *))PLACEHOLDER
{
    return ^id(NSString *placeHolder){
        if ([self isKindOfClass:[UITextField class]])
        {
            [(UITextField *)self setPlaceholder:placeHolder];
        }
        else
        {
            [self logInfo:@"PLACEHOLDER" info:placeHolder];
        }
        return self;
    };
}

- (__kindof UIView *(^)(NSUInteger))NUMBER_OF_LINES
{
    return ^id(NSUInteger lines){
        if([self isKindOfClass:[UILabel class]])
        {
            [(UILabel *)self setNumberOfLines:lines];
        }
        else if ([self isKindOfClass:[UIButton class]])
        {
            [((UIButton *)self).titleLabel setNumberOfLines:lines];
        }
        else
        {
            [self logInfo:@"NUMBER_OF_LINES" info:[NSString stringWithFormat:@"%ld", (long)lines]];
        }
        return self;
    };
}

//---------------
//  BeeUIImageView
//---------------

- (__kindof UIView *(^)(id))IMAGE
{
    return [WTChain createImageBlockWithView:self action:^(UIImage *image) {
        if ([self isKindOfClass:[UIButton class]])
        {
            [(UIButton *)self setImage:image forState:UIControlStateNormal];
            [(UIButton *)self setImage:image forState:UIControlStateHighlighted];
            [(UIButton *)self setImage:image forState:UIControlStateSelected];
            [(UIButton *)self setImage:image forState:UIControlStateDisabled];
        }
        else if ([self respondsToSelector:NSSelectorFromString(@"image")])
        {
            [self setValue:image forKey:@"image"];
        }
        else
        {
            [self logInfo:@"IMAGE" info:[image description]];
        }
    }];
}

//---------------
//  UIButton
//---------------

- (__kindof UIView *(^)(id))TEXT_INSETS
{
    return ^id(id value){
        return self;
    };
}
- (__kindof UIView *(^)(id))__TEXT_INSETS
{
    return ^id(NSValue *value){
        UIEdgeInsets insets = UIEdgeInsetsZero;
        if(strcmp(value.objCType, @encode(UIEdgeInsets)) == 0)
        {
            insets = [value UIEdgeInsetsValue];
        }
        else if([value isKindOfClass:[NSNumber class]])
        {
            CGFloat f = [(NSNumber *)value floatValue];
            insets = UIEdgeInsetsMake(f, f, f, f);
        }
        else if([self isKindOfClass:[UIButton class]])
        {
            [(UIButton *)self setTitleEdgeInsets:insets];
        }
        else if([self isKindOfClass:[UITextView class]])
        {
            [(UITextView *)self setTextContainerInset:insets];
        }
        else
        {
            [self logInfo:@"TEXT_INSETS" info:NSStringFromUIEdgeInsets(insets)];
        }
        return self;
    };
}

- (__kindof UIView *(^)(UIViewContentMode))IMAGE_CONTENTMODE
{
    return ^id(UIViewContentMode contentMode){
        if([self isKindOfClass:[UIImageView class]])
        {
            [((UIImageView *)self) setContentMode:contentMode];
        }
        else if([self isKindOfClass:[UIButton class]])
        {
            [((UIButton *)self).imageView setContentMode:contentMode];
        }
        else
        {
            [self logInfo:@"IMAGE_CONTENTMODE" info:[NSString stringWithFormat:@"%ld", (long)contentMode]];
        }
        return self;
    };
}

- (__kindof UIButton *(^)(id))IMAGE_INSETS
{
    return ^id(id value){
        return self;
    };
}
- (__kindof UIButton *(^)(id))__IMAGE_INSETS
{
    return ^id(NSValue *value){
        UIEdgeInsets insets = UIEdgeInsetsZero;
        if(strcmp(value.objCType, @encode(UIEdgeInsets)) == 0)
        {
            insets = [value UIEdgeInsetsValue];
        }
        else if([value isKindOfClass:[NSNumber class]])
        {
            CGFloat f = [(NSNumber *)value floatValue];
            insets = UIEdgeInsetsMake(f, f, f, f);
        }
        if([self isKindOfClass:[UIButton class]])
        {
            [(UIButton *)self setImageEdgeInsets:insets];
        }
        else
        {
            [self logInfo:@"IMAGE_INSETS" info:NSStringFromUIEdgeInsets(insets)];
        }
        return self;
    };
}

- (__kindof UIButton *(^)(id))COLOR_HIGHLIGHTED
{
    return [WTChain createColorBlockWithView:self action:^(UIColor *color) {
        if([self isKindOfClass:[UIButton class]])
        {
            [(UIButton *)self setTitleColor:color forState:UIControlStateHighlighted];
        }
        else
        {
            [self logInfo:@"COLOR_HIGHLIGHTED" info:[color description]];
        }
    }];
}


- (__kindof UIButton *(^)(id))COLOR_SELECTED
{
    return [WTChain createColorBlockWithView:self action:^(UIColor *color) {
        if([self isKindOfClass:[UIButton class]])
        {
            [(UIButton *)self setTitleColor:color forState:UIControlStateSelected];
        }
        else
        {
            [self logInfo:@"COLOR_SELECTED" info:[color description]];
        }
    }];
}

- (__kindof UIButton *(^)(id))IMAGE_HIGHLIGHTED
{
    return [WTChain createImageBlockWithView:self action:^(UIImage *image) {
        if([self isKindOfClass:[UIButton class]])
        {
            [((UIButton *)self) setImage:image forState:UIControlStateHighlighted];
        }
        else
        {
            [self logInfo:@"IMAGE_HIGHLIGHTED" info:[image description]];
        }
    }];
}

- (__kindof UIButton *(^)(id))IMAGE_SELECTED
{
    return [WTChain createImageBlockWithView:self action:^(UIImage *image) {
        if([self isKindOfClass:[UIButton class]])
        {
            [((UIButton *)self) setImage:image forState:UIControlStateSelected];
            [((UIButton *)self) setImage:image forState:UIControlStateSelected|UIControlStateHighlighted];
        }
        else
        {
            [self logInfo:@"IMAGE_SELECTED" info:[image description]];
        }
    }];
}

//- (__kindof UIButton *(^)(id))BACKGROUND_COLOR_HIGHLIGHTED
//{
//    return [WTChain createColorBlockWithView:self action:^(UIColor *color) {
//        if([self isKindOfClass:[UIButton class]])
//        {
//            [(UIButton *)self setBackgroundColor:color forState:UIControlStateHighlighted];
//        }
//        else
//        {
//            [self logInfo:@"BACKGROUND_COLOR_HIGHLIGHTED" info:[color description]];
//        }
//    }];
//}

//- (__kindof UIButton *(^)(id))BACKGROUND_COLOR_SELECTED
//{
//    return [WTChain createColorBlockWithView:self action:^(UIColor *color) {
//        if([self isKindOfClass:[UIButton class]])
//        {
//            [(UIButton *)self setBackgroundColor:color forState:UIControlStateSelected];
//        }
//        else
//        {
//            [self logInfo:@"BACKGROUND_COLOR_SELECTED" info:[color description]];
//        }
//    }];
//}

- (__kindof UIButton *(^)(id))BACKGROUND_IMAGE_HIGHLIGHTED
{
    //bg_highlight.png
    return [WTChain createImageBlockWithView:self action:^(UIImage *image) {
        if([self isKindOfClass:[UIButton class]])
        {
            [((UIButton *)self) setBackgroundImage:image forState:UIControlStateHighlighted];
        }
        else
        {
            [self logInfo:@"BACKGROUND_IMAGE_HIGHLIGHT" info:[image description]];
        }
    }];
}

- (__kindof UIButton *(^)(id))BACKGROUND_IMAGE_SELECTED
{
    return [WTChain createImageBlockWithView:self action:^(UIImage *image) {
        if([self isKindOfClass:[UIButton class]])
        {
            [((UIButton *)self) setBackgroundImage:image forState:UIControlStateSelected];
        }
        else
        {
            [self logInfo:@"BACKGROUND_IMAGE_SELECTE" info:[image description]];
        }
    }];
}

//---------------
//  UIScrollView
//---------------

- (__kindof UIView *(^)(id))DELEGATE
{
    return ^id(id delegate){
        if ([self respondsToSelector:NSSelectorFromString(@"delegate")])
        {
            [self setValue:delegate forKey:@"delegate"];
        }
        else
        {
            [self logInfo:@"DELEGATE" info:[delegate description]];
        }
        return self;
    };
}

- (__kindof UIView *(^)(id))DATASOURCE
{
    return ^id(id dataSource){
        if ([self respondsToSelector:NSSelectorFromString(@"dataSource")])
        {
            [self setValue:dataSource forKey:@"dataSource"];
        }
        else
        {
            [self logInfo:@"DATASOURCE" info:[dataSource description]];
        }
        return self;
    };
}

- (__kindof UIScrollView *(^)(BOOL))SCROLL_ENABLED
{
    return ^id(BOOL enabled){
        if([self isKindOfClass:[UIScrollView class]])
        {
            [(UIScrollView *)self setScrollEnabled:enabled];
        }
        else
        {
            [self logInfo:@"SCROLL_ENABLED" info:[NSString stringWithFormat:@"%ld", (long)enabled]];
        }
        return self;
    };
}

- (__kindof UIScrollView *(^)(BOOL))SCROLL_VERTICAL_INDICATOR
{
    return ^id(BOOL show){
        if([self isKindOfClass:[UIScrollView class]])
        {
            [(UIScrollView *)self setShowsVerticalScrollIndicator:show];
        }
        else
        {
            [self logInfo:@"SCROLL_SHOWS_VERTICAL_INDICATOR" info:[NSString stringWithFormat:@"%ld", (long)show]];
        }
        return self;
    };
}

- (__kindof UIScrollView *(^)(BOOL))SCROLL_HORIZONTAL_INDICATOR
{
    return ^id(BOOL show){
        if([self isKindOfClass:[UIScrollView class]])
        {
            [(UIScrollView *)self setShowsHorizontalScrollIndicator:show];
        }
        else
        {
            [self logInfo:@"SCROLL_SHOWS_HORIZONTAL_INDICATOR" info:[NSString stringWithFormat:@"%ld", (long)show]];
        }
        return self;
    };
}

- (__kindof UIScrollView *(^)(BOOL))SCROLL_BOUNCES
{
    return ^id(BOOL bounces){
        if([self isKindOfClass:[UIScrollView class]])
        {
            [(UIScrollView *)self setBounces:bounces];
            [(UIScrollView *)self setAlwaysBounceHorizontal:bounces];
            [(UIScrollView *)self setAlwaysBounceVertical:bounces];
        }
        else
        {
            [self logInfo:@"SCROLL_BOUNCES" info:[NSString stringWithFormat:@"%ld", (long)bounces]];
        }
        return self;
    };
}

- (__kindof UIScrollView *(^)(BOOL))SCROLL_BOUNCES_HORIZONTAL
{
    return ^id(BOOL bounces){
        if([self isKindOfClass:[UIScrollView class]])
        {
            [(UIScrollView *)self setAlwaysBounceHorizontal:bounces];
        }
        else
        {
            [self logInfo:@"SCROLL_BOUNCES_HORIZONTAL" info:[NSString stringWithFormat:@"%ld", (long)bounces]];
        }
        return self;
    };
}

- (__kindof UIScrollView *(^)(BOOL))SCROLL_BOUNCES_VERTICAL
{
    return ^id(BOOL bounces){
        if([self isKindOfClass:[UIScrollView class]])
        {
            [(UIScrollView *)self setAlwaysBounceVertical:bounces];
        }
        else
        {
            [self logInfo:@"SCROLL_BOUNCES_VERTICAL" info:[NSString stringWithFormat:@"%ld", (long)bounces]];
        }
        return self;
    };
}

- (__kindof UITableView *(^)(UITableViewCellSeparatorStyle))SEPARATOR_STYLE
{
    return ^id(UITableViewCellSeparatorStyle style){
        if([self isKindOfClass:[UITableView class]])
        {
            [(UITableView *)self setSeparatorStyle:style];
        }
        else
        {
            [self logInfo:@"SEPARATOR_STYLE" info:[NSString stringWithFormat:@"%ld", (long)style]];
        }
        return self;
    };
}

- (__kindof UITableView *(^)(CGFloat))ROW_HEIGHT
{
    return ^id(CGFloat height){
        if([self isKindOfClass:[UITableView class]])
        {
            [(UITableView *)self setRowHeight:height];
        }
        else
        {
            [self logInfo:@"ROW_HEIGHT" info:[NSString stringWithFormat:@"%f", height]];
        }
        return self;
    };
}

- (__kindof UICollectionView *(^)(id))ITEM_SIZE
{
    return ^id(id value){
        return self;
    };
}
- (__kindof UICollectionView *(^)(id))__ITEM_SIZE
{
    return ^id(NSValue *value){
        CGSize size = CGSizeZero;
        if(strcmp(value.objCType, @encode(CGSize)) == 0)
        {
            size = [value CGSizeValue];
        }
        else if([value isKindOfClass:[NSNumber class]])
        {
            CGFloat f = [(NSNumber *)value floatValue];
            size = CGSizeMake(f, f);
        }
        if([self isKindOfClass:[UICollectionView class]])
        {
            [(UICollectionViewFlowLayout *)((UICollectionView *)self).collectionViewLayout setItemSize:size];
        }
        else
        {
            [self logInfo:@"ITEM_SIZE" info:NSStringFromCGSize(size)];
        }
        return self;
    };
}

- (__kindof UICollectionView *(^)(id))SECTION_INSET
{
    return ^id(id value){
        return self;
    };
}
- (__kindof UICollectionView *(^)(id))__SECTION_INSET
{
    return ^id(NSValue *value){
        UIEdgeInsets insets = UIEdgeInsetsZero;
        if(strcmp(value.objCType, @encode(UIEdgeInsets)) == 0)
        {
            insets = [value UIEdgeInsetsValue];
        }
        else if([value isKindOfClass:[NSNumber class]])
        {
            CGFloat f = [(NSNumber *)value floatValue];
            insets = UIEdgeInsetsMake(f, f, f, f);
        }
        if([self isKindOfClass:[UICollectionView class]])
        {
            [(UICollectionViewFlowLayout *)((UICollectionView *)self).collectionViewLayout setSectionInset:insets];
        }
        else
        {
            [self logInfo:@"SECTION_INSET" info:NSStringFromUIEdgeInsets(insets)];
        }
        return self;
    };
}

- (__kindof UICollectionView *(^)(UICollectionViewScrollDirection))SCROLL_DIRECTION
{
    return ^id(UICollectionViewScrollDirection direction){
        if([self isKindOfClass:[UICollectionView class]])
        {
            [(UICollectionViewFlowLayout *)((UICollectionView *)self).collectionViewLayout setScrollDirection:direction];
        }
        else
        {
            [self logInfo:@"SCROLL_DIRECTION" info:[NSString stringWithFormat:@"%ld", (long)direction]];
        }
        return self;
    };
}

- (__kindof UICollectionView *(^)(CGFloat))MINIMUM_INTERITEM_SPACING
{
    return ^id(CGFloat spacing){
        if([self isKindOfClass:[UICollectionView class]])
        {
            [(UICollectionViewFlowLayout *)((UICollectionView *)self).collectionViewLayout setMinimumInteritemSpacing:spacing];
        }
        else
        {
            [self logInfo:@"MINIMUM_INTERITEM_SPACING" info:[NSString stringWithFormat:@"%f", spacing]];
        }
        return self;
    };
}

- (__kindof UICollectionView *(^)(CGFloat))MINIMUM_LINE_SPACING
{
    return ^id(CGFloat spacing){
        if([self isKindOfClass:[UICollectionView class]])
        {
            [(UICollectionViewFlowLayout *)((UICollectionView *)self).collectionViewLayout setMinimumLineSpacing:spacing];
        }
        else
        {
            [self logInfo:@"MINIMUM_LINE_SPACING" info:[NSString stringWithFormat:@"%f", spacing]];
        }
        return self;
    };
}

//---------------
//  UIPageControl
//---------------

- (__kindof UIPageControl *(^)(id color))PAGE_COLOR
{
    return [WTChain createColorBlockWithView:self action:^(UIColor *color) {
        if([self isKindOfClass:[UIPageControl class]])
        {
            [(UIPageControl *)self setPageIndicatorTintColor:color];
        }
        else
        {
            [self logInfo:@"PAGE_COLOR" info:[color description]];
        }
    }];
}

- (__kindof UIPageControl *(^)(id color))PAGE_CURRENT_COLOR
{
    return [WTChain createColorBlockWithView:self action:^(UIColor *color) {
        if([self isKindOfClass:[UIPageControl class]])
        {
            [(UIPageControl *)self setCurrentPageIndicatorTintColor:color];
        }
        else
        {
            [self logInfo:@"PAGE_ACTIVE_COLOR" info:[color description]];
        }
    }];
}

@end
