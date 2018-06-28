//
//  BSInformationListDto.h
//  BaoSheng
//
//  Created by GML on 2018/4/27.
//  Copyright © 2018年 haozheng. All rights reserved.
//

#import "BSBaseDto.h"

@interface InfoListDto :BSBaseDto

@property (nonatomic , strong)NSNumber *Id;
@property (nonatomic , strong)NSString *title;
@property (nonatomic , strong)NSString *text;
@property (nonatomic , strong)NSString *thumbnailUrl;
@property (nonatomic , strong)NSString *createDate;


@end


@interface BSInformationListDto : BSBaseDto


@property (nonatomic , strong)NSNumber *count;
@property (nonatomic , strong)NSMutableArray <InfoListDto *>*list;

@end
