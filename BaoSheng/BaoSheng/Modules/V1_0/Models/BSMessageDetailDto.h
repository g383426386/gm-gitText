//
//  BSMessageDetailDto.h
//  BaoSheng
//
//  Created by GML on 2018/4/27.
//  Copyright © 2018年 haozheng. All rights reserved.
//

#import "BSBaseDto.h"

@interface BSMessageDetailDto : BSBaseDto


@property (nonatomic , strong)NSNumber *Id;
@property (nonatomic , strong)NSString *title;
@property (nonatomic , strong)NSString *contentUrl;
@property (nonatomic , strong)NSString *synopsis;
@property (nonatomic , strong)NSNumber *informFor;
@property (nonatomic , strong)NSString *createTime;
@property (nonatomic , strong)NSString *creater;
@property (nonatomic , strong)NSString *publishTime;
@property (nonatomic , strong)NSNumber *status;

@end
