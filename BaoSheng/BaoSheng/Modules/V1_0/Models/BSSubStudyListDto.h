//
//  BSSubStudyListDto.h
//  BaoSheng
//
//  Created by GML on 2018/4/28.
//  Copyright © 2018年 haozheng. All rights reserved.
//

#import "BSBaseDto.h"

@interface learnListDto :BSBaseDto

@property (nonatomic , strong)NSString *publishTime;
@property (nonatomic , strong)NSNumber *Id;
@property (nonatomic , strong)NSString *title;
@property (nonatomic , strong)NSNumber *isEnd;

@end


@interface BSSubStudyListDto : BSBaseDto

@property (nonatomic , strong)NSNumber *learnEndCount;
@property (nonatomic , strong)NSNumber *count;
@property (nonatomic , strong)NSMutableArray <learnListDto *> *learnList;



@end
