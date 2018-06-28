//
//  BSStudyRecordControl.h
//  BaoSheng
//
//  Created by GML on 2018/4/26.
//  Copyright © 2018年 haozheng. All rights reserved.
//

#import "BSBaseControl.h"

@interface learenDto : BSBaseDto

@property (nonatomic , strong)NSString *title;
@property (nonatomic , strong)NSString *createTime;
@property (nonatomic ,  assign)NSInteger isEnd;

@end

@interface BSStudyRecordControl : BSBaseControl


@end
