//
//  BSInformationDetailDto.h
//  BaoSheng
//
//  Created by GML on 2018/4/28.
//  Copyright © 2018年 haozheng. All rights reserved.
//

#import "BSBaseDto.h"

@interface BSInformationDetailDto : BSBaseDto

@property (nonatomic , strong)NSNumber *Id;
@property (nonatomic , strong)NSString *title;
@property (nonatomic , strong)NSString *content;
@property (nonatomic , strong)NSString *text;
@property (nonatomic , strong)NSString *thumbnailUrl;
@property (nonatomic , strong)NSNumber *state;
@property (nonatomic , strong)NSString *createDate;
@property (nonatomic , strong)NSMutableArray *articlePictures;


@end
