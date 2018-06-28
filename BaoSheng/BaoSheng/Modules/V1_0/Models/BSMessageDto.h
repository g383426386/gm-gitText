//
//  BSMessageDto.h
//  BaoSheng
//
//  Created by GML on 2018/4/26.
//  Copyright © 2018年 haozheng. All rights reserved.
//

#import "BSBaseDto.h"

@interface BSMessageDto : BSBaseDto
/** 是否是党员消息 */
@property (nonatomic , assign)NSInteger informFor;
/** 发布时间 */
@property (nonatomic , strong)NSString *publishTime;
/** ID */
@property (nonatomic , strong)NSNumber *Id;
/** 简介 */
@property (nonatomic , strong)NSString *synopsis;
/** 标题 */
@property (nonatomic , strong)NSString *title;


@end
