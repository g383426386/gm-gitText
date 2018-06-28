//
//  SYTagsView.m
//  SY_Doctor
//
//  Created by vic_wei on 16/1/26.
//  Copyright © 2016年 SY. All rights reserved.
//

#import "SYTagsView.h"
#import "Masonry.h"
#import "NSString+SizeCalculate.h"
#import "UIView+FrameRelated.h"

@interface SYTagsView() <UICollectionViewDataSource , UICollectionViewDelegate , UICollectionViewDelegateFlowLayout>

//collectView
@property (nonatomic , strong) UICollectionView *collectionView;
//容器的高度
@property (nonatomic , assign) CGFloat containerViewHeight;

@property (nonatomic , assign) NSInteger itemsNum;


@property (nonatomic , strong) NSMutableArray *aryItemRects;
@property (nonatomic , assign) CGFloat        offY;
@property (nonatomic , assign) CGFloat        offCellY;

@end

@implementation SYTagsView
{
    NSMutableDictionary *_dicItems;
}

@synthesize collectionView = _collectionView;
@synthesize itemMinimumLineSpacing = _itemMinimumLineSpacing;
@synthesize itemMinimumInteritemSpacing = _itemMinimumInteritemSpacing;

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame]) {
        [self instance];
    }
    return self;
}

- (void)awakeFromNib
{
    [self instance];
}

- (void)instance
{
    _dicItems = [NSMutableDictionary new];
    self.aryItemRects = [NSMutableArray new];
    
    self.titleFontSize = 13.0;
    self.titleHeight = 20.0;
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];//设置其布局方向
    flowLayout.sectionInset = UIEdgeInsetsMake(0.0, 0.0, 0, 0.0);
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.itemSize = CGSizeMake(100.0, 20);
    
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    [_collectionView setCollectionViewLayout:flowLayout];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.alwaysBounceVertical = NO;
    _collectionView.alwaysBounceHorizontal = NO;
//    [_collectionView registerNib:[UINib nibWithNibName:@"SYTagItem" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"SYTagItem"];
    [_collectionView registerClass:[SYTagItem class] forCellWithReuseIdentifier:@"SYTagItem"];
    _collectionView.scrollsToTop = NO;
    
    [self addSubview:_collectionView];
    
    [_collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.left.equalTo(self.mas_left);
        make.bottom.equalTo(self.mas_bottom);
        make.right.equalTo(self.mas_right);
    }];
    
    @weakify(self);
    [[RACObserve(_collectionView, contentSize)  filter:^BOOL(NSValue *value) {
        @strongify(self);
        
        if (value.CGSizeValue.height == 0 ) {
            return YES;
        }else{
            return (fabs(self.containerViewHeight - value.CGSizeValue.height) > 0);
        }
        
    }] subscribeNext:^(NSValue *x) {
        @strongify(self);
        self.containerViewHeight = x.CGSizeValue.height;
        if (self.containerHeight) {
            self.containerHeight(self.containerViewHeight);
        }
    }];
    
}

- (void)setTagViewItems:(NSInteger)items
{
    self.itemsNum = items;
    [_collectionView reloadData];
}

- (CGFloat)getCurrentHeight
{
    [_collectionView setNeedsLayout];
    [_collectionView layoutIfNeeded];
    return _collectionView.contentSize.height;
}

- (void)reloadData
{
    [_collectionView reloadData];
}

- (void)setItemMinimumLineSpacing:(CGFloat)itemMinimumLineSpacing
{
    _itemMinimumLineSpacing = itemMinimumLineSpacing;
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout*)_collectionView.collectionViewLayout;
    flowLayout.minimumLineSpacing = _itemMinimumLineSpacing;
    [_collectionView reloadData];
}

- (void)setItemMinimumInteritemSpacing:(CGFloat)itemMinimumInteritemSpacing
{
    _itemMinimumInteritemSpacing = itemMinimumInteritemSpacing;
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout*)_collectionView.collectionViewLayout;
    flowLayout.minimumInteritemSpacing = _itemMinimumInteritemSpacing;
    [_collectionView reloadData];
}

- (void)setScrollsToTop:(BOOL)scrollsToTop
{
    self.collectionView.scrollsToTop = scrollsToTop;
}

- (BOOL)scrollsToTop
{
    return self.collectionView.scrollsToTop;
}

- (SYTagItem *)itemForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return (SYTagItem*)[self.collectionView cellForItemAtIndexPath:indexPath];
}

+ (CGFloat)measureHeightWithSource:(NSArray *)titles maxWidth:(CGFloat)maxWidth titleHeight:(CGFloat)titleHeight fontSize:(CGFloat)fontSize inset:(UIEdgeInsets)inset itemSpacing:(CGFloat)itemSpacing lineSpacing:(CGFloat)lineSpacing
{
    
    __block CGFloat resultHeight = 0.0;
    
    __block CGFloat offX = 0.0;
    [titles enumerateObjectsUsingBlock:^(NSString*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSString *title = obj;
        CGFloat width = [title sc_calculateWidthInFontSize:fontSize withStableHeight:titleHeight];
        width = MIN(width, maxWidth - (inset.left + inset.right));
        CGSize size = CGSizeMake(inset.left + inset.right + width, inset.top + inset.bottom + titleHeight);
        
        CGFloat tempX = (offX==0.0) ? size.width : (offX + itemSpacing + size.width);
        
        if (0 == idx) {
            resultHeight = size.height;
            offX = tempX;
        }else{
            if (tempX > maxWidth) {
                offX = size.width;
                resultHeight += lineSpacing + size.height;
            }else{
                offX = tempX;
            }
        }
    }];
    
    return resultHeight;
}

#pragma mark - collectView
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    // 清数据
    [_dicItems removeAllObjects];
    [self.aryItemRects removeAllObjects];
    self.offY = 0.0;
    self.offCellY = 0.0;
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    if (self.itemsNum == 0) {
        
    }
    return self.itemsNum;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize result = CGSizeZero;

    if (self.autoTitleLayout) {
        NSString *title = @"";
        if (self.delegate && [self.delegate respondsToSelector:@selector(syTag_itemTitleAtIndexPath: inTagsView:)]) {
            title = [self.delegate syTag_itemTitleAtIndexPath:indexPath inTagsView:self];
        }
        CGFloat width = [title sc_calculateWidthInFontSize:self.titleFontSize withStableHeight:self.titleHeight];
        width = MIN(width, self.f_width - (self.titleInset.left + self.titleInset.right));
        result = CGSizeMake(self.titleInset.left + self.titleInset.right + width, self.titleInset.top + self.titleInset.bottom + self.titleHeight);
        
        if (self.autoTitleLayout) {
            
            // 靠左
            if (TagsViewLayout_AlignLeft == self.layoutTitleType) {
                
                // 记录的时候 从0开始 , 布局时候找出第一个cell y值, 加上 offY  计算正确 rect y值
                UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout*)collectionView.collectionViewLayout;
                CGRect rect = (CGRect){0.0,self.offY,result};
                
                if (indexPath.row == 0) {
                    
                    NSValue *value = [NSValue valueWithCGRect:rect];
                    [self.aryItemRects addObject:value];
                    
                }else{
                    
                    NSValue *previousValue = self.aryItemRects[indexPath.row-1];
                    CGRect previousFrame = previousValue.CGRectValue;
                    
                    // 计算 x位置
                    if (previousFrame.origin.y < self.offY) {
                        rect.origin.x = 0.0;
                    }else{
                        rect.origin.x = previousFrame.origin.x + previousFrame.size.width + flowLayout.minimumInteritemSpacing;
                    }
                    
                    // 修正 x y 位置
                    if (rect.origin.x + rect.size.width >= collectionView.f_width) {
                        self.offY += flowLayout.minimumLineSpacing + rect.size.height;
                        rect.origin.x = 0.0;
                        rect.origin.y = self.offY;
                    }
                    
                    NSValue *value = [NSValue valueWithCGRect:rect];
                    [self.aryItemRects addObject:value];
                }
            }
            
            // 靠右
            if (TagsViewLayout_AlignRight == self.layoutTitleType) {
                
                
            }
            
        }
        
    }else{
        if (!CGSizeEqualToSize(self.itemSize, CGSizeZero)) {
            result = self.itemSize;
        }
        if (self.delegate && [self.delegate respondsToSelector:@selector(syTag_itemSizeAtIndexPath: inTagsView:)]) {
            CGSize size = [self.delegate syTag_itemSizeAtIndexPath:indexPath inTagsView:self];
            if (!CGSizeEqualToSize(size, CGSizeZero)) {
                result = size;
            }
        }
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(syTag_willConfigSizeAtIndexPath:inTagsView:currentSize:)]) {
        result = [self.delegate syTag_willConfigSizeAtIndexPath:indexPath inTagsView:self currentSize:result];
    }
    
    return result;
}

//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString * CellIdentifier = @"SYTagItem";
    SYTagItem * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.titleInset = self.titleInset;
    cell.defaultTitleLab_.font = [UIFont systemFontOfSize:self.titleFontSize];
    
    NSString *title = @"";
    if (self.delegate && [self.delegate respondsToSelector:@selector(syTag_itemTitleAtIndexPath:inTagsView:)]) {
        title = [self.delegate syTag_itemTitleAtIndexPath:indexPath inTagsView:self];
    }
    cell.defaultTitleLab_.text = title;
    
//    if (self.aryItemRects.count > indexPath.row) {
//        
//        if (0 == indexPath.row) {
//            NSValue *last = [self.aryItemRects lastObject];
//            NSLog(@"%@" , NSStringFromCGSize(collectionView.contentSize));
//            NSLog(@"%@" , last);
//        }
//        
//        NSValue *value = self.aryItemRects[indexPath.row];
//        NSLog(@"%@ %@" , cell , value);
//    }
    
    if (self.autoTitleLayout) {
        
        if (0 == indexPath.row) {
            self.offCellY = cell.f_y;
        }
        
        if (self.aryItemRects.count > indexPath.row) {
            NSValue *value = self.aryItemRects[indexPath.row];
            cell.frame = (CGRect){value.CGRectValue.origin.x,self.offCellY+value.CGRectValue.origin.y,value.CGRectValue.size};
        }
        
        
    }else{
        
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(syTag_configItem:atIndexPath: inTagsView:)]) {
        [self.delegate syTag_configItem:cell atIndexPath:indexPath inTagsView:self];
    }
    
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(syTag_didSelectItemAtIndexPath: inTagsView:)]) {
        [self.delegate syTag_didSelectItemAtIndexPath:indexPath inTagsView:self];
    }
}

@end
