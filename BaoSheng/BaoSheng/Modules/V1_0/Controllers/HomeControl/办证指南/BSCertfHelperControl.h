//
//  BSCertfHelperControl.h
//  BaoSheng
//
//  Created by GML on 2018/4/28.
//  Copyright © 2018年 haozheng. All rights reserved.
//

#import "BSBaseControl.h"

@interface CertfCellDto :BSBaseDto

@property (nonatomic , strong)NSString *imagePath;
@property (nonatomic , strong)NSString *title;
@property (nonatomic , strong)NSString *url;

@end

@interface CertfSectionDto :BSBaseDto

@property (nonatomic , strong)NSString *sectionTitle;
@property (nonatomic , strong)NSMutableArray <CertfCellDto *>*cellArr;

@end

@interface BSCertfHelperControl : BSBaseControl

@end
