//
//  BSCertfHelperControl.m
//  BaoSheng
//
//  Created by GML on 2018/4/28.
//  Copyright © 2018年 haozheng. All rights reserved.
//

#import "BSCertfHelperControl.h"
#import "CollectionViewCell.h"
#import "CertifColltionHeader.h"
#import "WKWebCommonVc.h"


@implementation CertfCellDto

@end



@implementation CertfSectionDto

+(NSDictionary *)mj_objectClassInArray{
    
    return @{@"cellArr" : [CertfCellDto class]};
}

@end

@interface BSCertfHelperControl ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic , strong)UICollectionView *collectionView;
@property (nonatomic , strong)NSMutableArray *DataArr;


@end

@implementation BSCertfHelperControl

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"办证指南";
    
    [self initData];
    [self buildUI];
    
}
- (void)initData{
    
    self.DataArr = [@[]mutableCopy];
    NSArray *sectionArr = @[@"公安局",@"民政局",@"国土局",@"人社局",@"卫生委",@"市场综合管理"];
    NSArray *gonganArr = @[@{@"image" :@"shenfenzheng" , @"title" :@"身份证",@"url":@"sfz"},
                          @{@"image" :@"linshishenfenz" , @"title" :@"临时身份证",@"url":@"lssfz"},
                          @{@"image" :@"shouyang" , @"title" :@"婴儿入户登记",@"url":@"xsyerh"},
                          @{@"image" :@"hukou" , @"title" :@"户口变更",@"url":@"hkbg"},
                          @{@"image" :@"juzhuzheng" , @"title" :@"居住证",@"url":@"jzz"},
                          @{@"image" :@"zanzhuzheng" , @"title" :@"港澳通行证",@"url":@"gatxz"},
                          @{@"image" :@"jaishizheng" , @"title" :@"暂住证",@"url":@"zzz"},
                          @{@"image" :@"xignshizheng" , @"title" :@"驾驶证",@"url":@"jsz"},
                          @{@"image" :@"gangaotongxingz" , @"title" :@"行驶证",@"url":@"xsz"}
                          ];
    
    NSArray *minzhengArr =@[@{@"image" :@"jeihunz" , @"title" :@"结婚证",@"url":@"jhz"},
                            @{@"image" :@"canjizheng" , @"title" :@"残疾证",@"url":@"cjz"},
                            @{@"image" :@"dibaozheng" , @"title" :@"低保证",@"url":@"dbz"},
                            @{@"image" :@"laonianzheng" , @"title" :@"老年证",@"url":@"lnz"},
                            @{@"image" :@"lieshizheng" , @"title" :@"烈士证",@"url":@"lsz"}
                            ];
    NSArray *guotuArr = @[@{@"image" :@"budongchan" , @"title" :@"不动产证书",@"url":@"fcz"},
                            @{@"image" :@"diyadnegji" , @"title" :@"抵押登记",@"url":@"fcdyzl"}
                            ];
    NSArray *rensheArr = @[@{@"image" :@"nongyibaoxian" , @"title" :@"农医保险",@"url":@"yb"},
                         @{@"image" :@"chengyibaoxian" , @"title" :@"城医保险",@"url":@"yb"}
                         ];
    NSArray *weishengArr = @[@{@"image" :@"jiankangzheng" , @"title" :@"健康证",@"url":@"jkz"},
                            @{@"image" :@"shengyuzheng" , @"title" :@"生育证",@"url":@"syz"},
                            @{@"image" :@"chushengzheng" , @"title" :@"出生证",@"url":@"csz"},
                            @{@"image" :@"jiezhongzheng" , @"title" :@"接种证",@"url":@"yfjzz"},
                            ];
    NSArray *zongheArr = @[@{@"image" :@"yingyezhizhao" , @"title" :@"营业执照",@"url":@"yyzz"},
                          @{@"image" :@"weishengxuke" , @"title" :@"卫生许可证",@"url":@"wsxkz"}
                          ];
    
    for (int i = 0; i < sectionArr.count; i++) {
      
        CertfSectionDto *SecDto = [CertfSectionDto new];
        SecDto.sectionTitle = sectionArr[i];

        NSMutableArray *CellArr = [@[]mutableCopy];
        if (i == 0) {
            for (int j = 0; j < gonganArr.count; j++) {
                CertfCellDto *cellDto = [CertfCellDto new];
                NSDictionary *dic = gonganArr[j];
                cellDto.url = dic[@"url"];
                cellDto.imagePath = dic[@"image"];
                cellDto.title = dic[@"title"];
                [CellArr addObject:cellDto];
            }
        }else if (i == 1){
            for (int j = 0; j < minzhengArr.count; j++) {
                CertfCellDto *cellDto = [CertfCellDto new];
                NSDictionary *dic = minzhengArr[j];
                cellDto.url = dic[@"url"];
                cellDto.imagePath = dic[@"image"];
                cellDto.title = dic[@"title"];
                [CellArr addObject:cellDto];
            }
        }else if (i == 2){
            for (int j = 0; j < guotuArr.count; j++) {
                CertfCellDto *cellDto = [CertfCellDto new];
                NSDictionary *dic = guotuArr[j];
                cellDto.url = dic[@"url"];
                cellDto.imagePath = dic[@"image"];
                cellDto.title = dic[@"title"];
                [CellArr addObject:cellDto];
            }
        }else if (i == 3){
            for (int j = 0; j < rensheArr.count; j++) {
                CertfCellDto *cellDto = [CertfCellDto new];
                NSDictionary *dic = rensheArr[j];
                cellDto.url = dic[@"url"];
                cellDto.imagePath = dic[@"image"];
                cellDto.title = dic[@"title"];
                [CellArr addObject:cellDto];
            }
        }else if (i == 4){
            for (int j = 0; j < weishengArr.count; j++) {
                CertfCellDto *cellDto = [CertfCellDto new];
                NSDictionary *dic = weishengArr[j];
                cellDto.url = dic[@"url"];
                cellDto.imagePath = dic[@"image"];
                cellDto.title = dic[@"title"];
                [CellArr addObject:cellDto];
            }
        }else if (i == 5){
            for (int j = 0; j < zongheArr.count; j++) {
                CertfCellDto *cellDto = [CertfCellDto new];
                NSDictionary *dic = zongheArr[j];
                cellDto.url = dic[@"url"];
                cellDto.imagePath = dic[@"image"];
                cellDto.title = dic[@"title"];
                [CellArr addObject:cellDto];
            }
            
        }
        SecDto.cellArr = CellArr;
        
        [self.DataArr addObject:SecDto];
    }
    
}


#pragma mark - UI
- (void)buildUI{
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.itemSize = CGSizeMake(74, 46);
    flowLayout.minimumLineSpacing = 10;
    flowLayout.minimumInteritemSpacing = 15;
    flowLayout.headerReferenceSize = CGSizeMake(kSCREEN_WIDTH, 44);
    flowLayout.sectionInset = UIEdgeInsetsMake(5, 15, 20, 15);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    _collectionView  = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 10, kSCREEN_WIDTH, kSCREEN_HEIGHT - 64 - 10) collectionViewLayout:flowLayout];
    [self.view addSubview:_collectionView];
    _collectionView.backgroundColor = kWhiteColor;
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    
    [_collectionView registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:@"CollectionViewCell"];
    [_collectionView registerClass:[CertifColltionHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"CertifColltionHeader"];
    
}
#pragma mark - UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return self.DataArr.count;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    CertfSectionDto *secDto =  self.DataArr[section];
    return secDto.cellArr.count;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
     CertifColltionHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"CertifColltionHeader" forIndexPath:indexPath];
     CertfSectionDto *secDto = self.DataArr[indexPath.section];
    header.sectionTitle.text = secDto.sectionTitle;
    
    header.lineView.hidden = indexPath.section == 0;
    
    return header;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionViewCell" forIndexPath:indexPath];
    
    
    CertfSectionDto *secDto = self.DataArr[indexPath.section];
    CertfCellDto *cellDto = secDto.cellArr[indexPath.row];
    
    cell.imageView.image = [UIImage imageNamed:cellDto.imagePath];
    cell.titlelb.text = cellDto.title;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CertfSectionDto *secDto = self.DataArr[indexPath.section];
    CertfCellDto *cellDto = secDto.cellArr[indexPath.row];
    
    WKWebCommonVc *Vc = [[WKWebCommonVc alloc]init];
    NSString *lastPend =  [NSString stringWithFormat:@"%@.html",cellDto.url];
    NSString *url = BSApi_Path(BS_HOST_Master, BS_hostapend, @"resource/apphtml",lastPend);
    
//    [NSString stringWithFormat:@"%@/%@/resource/apphtml/%@.html",BS_HOST_Master,BS_hostapend,];
    Vc.mainUrl = url.mutableCopy;
    Vc.webStyle = WebViewHeader_Style_Certf;
    [self.navigationController pushViewController:Vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
