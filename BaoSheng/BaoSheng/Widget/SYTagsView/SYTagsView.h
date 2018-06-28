//
//  SYTagsView.h
//  SY_Doctor
//
//  Created by vic_wei on 16/1/26.
//  Copyright © 2016年 SY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SYTagItem.h"

typedef NS_ENUM(NSInteger,SYTagsViewLayout) {
    TagsViewLayout_AlignLeft,
    TagsViewLayout_AlignRight,
};

@protocol SYTagsViewDelegate;

@interface SYTagsView : UIControl

@property (nonatomic , assign) BOOL autoTitleLayout;
@property (nonatomic , assign) SYTagsViewLayout layoutTitleType;

@property (nonatomic , weak) id<SYTagsViewDelegate> delegate;

@property (nonatomic , assign) CGFloat titleHeight;
@property (nonatomic , assign) CGFloat titleFontSize;
@property (nonatomic , assign) UIEdgeInsets titleInset;

@property (nonatomic , assign) CGFloat itemMinimumLineSpacing;
@property (nonatomic , assign) CGFloat itemMinimumInteritemSpacing;
@property (nonatomic , assign) CGSize itemSize;

- (void)setTagViewItems:(NSInteger)items;
- (void)reloadData;
- (void)setScrollsToTop:(BOOL)scrollsToTop;
- (BOOL)scrollsToTop;
- (SYTagItem*)itemForItemAtIndexPath:(NSIndexPath *)indexPath;

+ (CGFloat)measureHeightWithSource:(NSArray*)titles maxWidth:(CGFloat)maxWidth titleHeight:(CGFloat)titleHeight fontSize:(CGFloat)fontSize inset:(UIEdgeInsets)inset itemSpacing:(CGFloat)itemSpacing lineSpacing:(CGFloat)lineSpacing;

/** 弃用 */
@property (nonatomic , copy) void(^containerHeight)(CGFloat height);
- (CGFloat)getCurrentHeight;

@end

@protocol SYTagsViewDelegate <NSObject>

@optional
- (NSString*)syTag_itemTitleAtIndexPath:(NSIndexPath *)indexPath inTagsView:(SYTagsView*)tagView;
- (CGSize)syTag_itemSizeAtIndexPath:(NSIndexPath *)indexPath inTagsView:(SYTagsView*)tagView;
- (CGSize)syTag_willConfigSizeAtIndexPath:(NSIndexPath *)indexPath inTagsView:(SYTagsView*)tagView currentSize:(CGSize)currentSize;

- (void)syTag_configItem:(SYTagItem*)item atIndexPath:(NSIndexPath *)indexPath inTagsView:(SYTagsView*)tagView;
- (void)syTag_didSelectItemAtIndexPath:(NSIndexPath *)indexPath inTagsView:(SYTagsView*)tagView;

@end