//
//  BSNineteenCollectionVC.m
//  BaoSheng
//
//  Created by GML on 2018/4/27.
//  Copyright © 2018年 haozheng. All rights reserved.
//

#import "BSNineteenCollectionVC.h"
#import "BSNineteenCell.h"
#import "BSMoreInfomationContol.h"

@interface BSNineteenCollectionVC ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic , strong)UICollectionView *collectionView;
@property (nonatomic , strong)NSMutableArray *DataArr;

@end


@implementation BSNineteenCollectionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"十九大精神";
    [self initData];
    [self buildUI];
}
- (void)initData{
    
    self.DataArr = @[@{@"image" :@"guanche", @"title" : @"贯彻十九大" ,@"Id":@4,@"navTile" :@"十九大概述"},
                    @{@"image" :@"xiangjie", @"title" : @"十九大详解",@"Id":@40,@"navTile" :@"十九大详解"},
                     @{@"image" :@"zhuanjiajiedu", @"title" : @"专家解读",@"Id":@41,@"navTile" :@"专家解读"},
                     @{@"image" :@"xuexiwenda", @"title" : @"报告学习问答",@"Id":@43,@"navTile" :@"全程播报"},
                    ].mutableCopy;
    
}
#pragma mark - UI
- (void)buildUI{
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.itemSize = CGSizeMake(152*wSCALE_WIDTH, (207*wSCALE_WIDTH + 28*wSCALE_WIDTH));
    flowLayout.minimumLineSpacing = 15;
    flowLayout.minimumInteritemSpacing = 15;
    flowLayout.sectionInset = UIEdgeInsetsMake(20, 15, 20, 15);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    _collectionView  = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT - 64) collectionViewLayout:flowLayout];
    [self.view addSubview:_collectionView];
    _collectionView.backgroundColor = kappBackgroundColor;
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    [_collectionView registerNib:[UINib nibWithNibName:@"BSNineteenCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"BSNineteenCell"];
    
}
#pragma mark - UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return 4;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    BSNineteenCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BSNineteenCell" forIndexPath:indexPath];

    NSDictionary *dic = self.DataArr[indexPath.row];
    cell.ImageView_.image = [UIImage imageNamed:dic[@"image"]];
    cell.titlelb_.text = dic[@"title"];
    
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = self.DataArr[indexPath.row];
    BSMoreInfomationContol *Vc = [[BSMoreInfomationContol alloc]init];
    Vc.navigationItem.title = dic[@"navTile"];
    Vc.Id = dic[@"Id"];
    [self.navigationController pushViewController:Vc animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
