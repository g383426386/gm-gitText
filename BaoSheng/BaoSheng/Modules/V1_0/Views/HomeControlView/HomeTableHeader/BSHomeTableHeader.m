//
//  BSHomeTableHeader.m
//  BaoSheng
//
//  Created by GML on 2018/4/22.
//  Copyright © 2018年 haozheng. All rights reserved.
//

#import "BSHomeTableHeader.h"

@interface BSHomeTableHeader()<SDCycleScrollViewDelegate>

@property (nonatomic , strong)NSMutableArray *imageArr;

@end

@implementation BSHomeTableHeader

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)addOwnViews{
    
    self.f_width = kSCREEN_WIDTH;
    self.backgroundColor = kappBackgroundColor;
    
    SDCycleScrollView *cycleView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 210 *wSCALE_WIDTH) delegate:nil placeholderImage:[UIImage imageNamed:@"zhanwei_banner"]];
    cycleView.bannerImageViewContentMode = UIViewContentModeScaleToFill;
    cycleView.backgroundColor = kappBackgroundColor;
    cycleView.currentPageDotColor = kappButtonBackgroundColor;
    cycleView.pageDotColor = kWhiteColor;
    cycleView.autoScrollTimeInterval = 5.f;
    self.cycleScrolView = cycleView;
    [self addSubview:self.cycleScrolView];
    
//    [self netRequest_cycleImage];
    
    NSArray *itemtitleArr = @[@"十九大",@"党员学习",@"办证指南",@"智慧党建"];
    NSArray *itemImgeArr = @[@"zixun",@"xuexi",@"banzheng",@"dangjian"];
    NSMutableArray *itemArr = [@[]mutableCopy];
    
    UIView *itemContentView = [UIView new];
    [self addSubview:itemContentView];
    itemContentView.backgroundColor = kWhiteColor;
    itemContentView.f_width = kSCREEN_WIDTH;
    itemContentView.f_height = 92;
    
    CGFloat W = 69;
    CGFloat H = 62 + 5;
    
    for (int i = 0; i < itemtitleArr.count; i++) {
        HomeItem *item = [[HomeItem alloc]initWithFrame:CGRectMake(0, 0, W, H)];
        item.imageView.image = [UIImage imageNamed:itemImgeArr[i]];
        
        UITapGestureRecognizer *itemTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(itemTap:)];
        item.userInteractionEnabled  = YES;
        item.tag = i;
        [item addGestureRecognizer:itemTap];
        
        [itemContentView addSubview:item];
        item.titlelb.text = itemtitleArr[i];
        [itemArr addObject:item];
    }
//    [itemContentView alignSubviews:itemArr horizontallyWithPadding:2 margin:5 inRect:CGRectMake(0, 5, kSCREEN_WIDTH, itemContentView.f_height)];
    [itemContentView gridViewsCustom:itemArr inColumn:itemtitleArr.count size:CGSizeMake(W, H) margin:UIEdgeInsetsMake(15, 15, 5, 15) inRect:CGRectMake(0, 15, kSCREEN_WIDTH, 92)];
    itemContentView.f_height = itemContentView.subviews.lastObject.f_bottom+ 15;
    
    itemContentView.f_top = self.cycleScrolView.f_bottom;
    itemContentView.f_left = 0;
    
    UIView *secView = [self buildSectionViewWithTitle:@"资讯动态"];
    [self addSubview:secView];
    secView.f_top = itemContentView.f_bottom + 10;
    secView.f_left = 0;
    
    self.f_height = secView.f_bottom;
    
}

- (UIView *)buildSectionViewWithTitle:(NSString *)title{
    
    UIView *sectionView = [UIView new];
    sectionView.f_width = kSCREEN_WIDTH;
    sectionView.f_height = 50;
    sectionView.backgroundColor = kWhiteColor;
    
    UIView *leftView = [UIView new];
    [sectionView addSubview:leftView];
    leftView.f_width = 3;
    leftView.f_height = sectionView.f_height - 30;
    leftView.backgroundColor = kRedColor;
    leftView.f_centerY = sectionView.f_height/2;
    leftView.f_left = 20;
    
    UILabel *titlelb = [UILabel new];
    [sectionView addSubview:titlelb];
    titlelb.font = FONTSize(18);
    titlelb.textColor =  kappTextColorDrak;
    titlelb.text = title;
    [titlelb sizeToFit];
    titlelb.f_centerY = leftView.f_centerY;
    titlelb.f_left = leftView.f_right + 15;
    
    UIImageView *moreImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"more"]];
    [sectionView addSubview:moreImage];
    moreImage.f_centerY = titlelb.f_centerY;
    moreImage.f_right = sectionView.f_width - 15;
    
    UIButton  *moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [sectionView addSubview:moreBtn];
    moreBtn.titleLabel.font = FONTSize(12);
    [moreBtn setTitleColor:kappTextColorlingtGray forState:UIControlStateNormal];
    [moreBtn setTitle:@"更多" forState:UIControlStateNormal];
    [moreBtn sizeToFit];
    
    [sectionView addSubview:moreBtn];
    moreBtn.f_centerY = titlelb.f_centerY;
    moreBtn.f_right = moreImage.f_left - 2;
    
    [moreBtn addTarget:self action:@selector(moreBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    return sectionView;
}
#pragma mark - Events
- (void)moreBtnClick:(UIButton *)sender{
    
    if (self.moreBtnClickBlock) {
        self.moreBtnClickBlock();
    }
    
}
- (void)itemTap:(UITapGestureRecognizer *)sender{
    if (self.itemClickAtIndex) {
        self.itemClickAtIndex(sender.view.tag);
    }
    
}


#pragma mark - SDCycleScrollViewDelegate
/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    
    NSLog(@"点击了%ld %@",index,self.imageArr[index]);
    
}


@end
