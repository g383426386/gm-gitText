//
//  BSCycleImgeDetailDto.h
//  BaoSheng
//
//  Created by GML on 2018/4/27.
//  Copyright © 2018年 haozheng. All rights reserved.
//

#import "BSBaseDto.h"

@interface BSCycleImgeDetailDto : BSBaseDto

/** 内容地址 */
@property (nonatomic , strong)NSString * contentUrl;
@property (nonatomic , strong)NSString *text;
/** 发布时间 */
@property (nonatomic , strong)NSString *publishDate;
/** 创建时间 */
@property (nonatomic , strong)NSString *createDate;
/** ID */
@property (nonatomic , strong)NSNumber *Id;
/** 图片地址 */
@property (nonatomic , strong)NSString *thumbnailUrl;
/** 标题 */
@property (nonatomic , strong)NSString *title;

@end
