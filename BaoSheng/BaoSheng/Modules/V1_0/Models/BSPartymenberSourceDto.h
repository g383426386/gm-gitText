//
//  BSPartymenberSourceDto.h
//  BaoSheng
//
//  Created by GML on 2018/4/26.
//  Copyright © 2018年 haozheng. All rights reserved.
//

#import "BSBaseDto.h"

@interface hyqdDto :BSBaseDto

@property (nonatomic , copy)NSString *title;
@property (nonatomic , strong)NSNumber * integral;
@property (nonatomic , strong)NSString *createDate;

@end

@interface fpjlDto :BSBaseDto

@property (nonatomic , strong)NSString *explanation;
@property (nonatomic , assign)NSInteger type;
@property (nonatomic , strong)NSNumber * integral;
@property (nonatomic , strong)NSString *createDate;

@end

//党员积分
@interface BSPartymenberSourceDto : BSBaseDto

@property (nonatomic , strong)NSString *dyName;
/** 当前积分 */
@property (nonatomic , strong)NSNumber *grades;
/** 会议签到 */
@property (nonatomic , strong)NSMutableArray <hyqdDto *>* hyqd;
/** 扶贫记录 */
@property (nonatomic , strong)NSMutableArray <fpjlDto *>* fpjl;


@end
