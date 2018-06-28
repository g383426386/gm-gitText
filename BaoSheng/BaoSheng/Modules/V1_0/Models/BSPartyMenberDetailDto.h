//
//  BSPartyMenberDetailDto.h
//  BaoSheng
//
//  Created by GML on 2018/5/2.
//  Copyright © 2018年 haozheng. All rights reserved.
//

#import "BSBaseDto.h"


@interface partyMemberDetailDto :BSBaseDto

@property (nonatomic , strong)NSNumber *Id;
@property (nonatomic , strong)NSString *title;
@property (nonatomic , strong)NSString *contentUrl;
@property (nonatomic , strong)NSString *contentSource;
@property (nonatomic , strong)NSNumber *learningTime;//学习时长 单位分钟
@property (nonatomic , strong)NSString *createTime;
@property (nonatomic , strong)NSString *createBy;
@property (nonatomic , strong)NSString *publishTime;
@property (nonatomic , strong)NSNumber *status;//0删除 1未发布 2发布

@end

@interface BSPartyMenberDetailDto : BSBaseDto

@property (nonatomic , assign)NSInteger isEnd;
@property (nonatomic , strong)partyMemberDetailDto *partyMemberLearning;

@end
