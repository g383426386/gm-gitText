//
//  BSUserInfoCertfVC.m
//  BaoSheng
//
//  Created by GML on 2018/4/25.
//  Copyright © 2018年 haozheng. All rights reserved.
//

#import "BSUserInfoCertfVC.h"

@interface BSUserInfoCertfVC ()

@property (nonatomic , strong)UIScrollView *scrollView;
@property (nonatomic , strong)UIImageView *headImage;
@property (nonatomic , strong)UITextView *detailTextView;
@property (nonatomic , strong)UITextField *nameTF;
@property (nonatomic , strong)UITextField *sexTF;
@property (nonatomic , strong)UITextField *brithdayTF;
@end

@implementation BSUserInfoCertfVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"个人信息";
    [self addOwnViews];
    [self configData];
}
#pragma mark - refresh
- (void)configData{
    
    
    BSBaseUserDto *user =  BSContext_shareInstance.currentUser;
    
    partyMemberDto *partyDto = user.partyMemberInformation;
    if (!partyDto) {
        return;
    }
    
    [self.headImage sd_setImageWithURL:[NSURL URLWithString:partyDto.headPortraitUrl] placeholderImage:[UIImage imageNamed:@"my_head_n"]];
    self.nameTF.text = user.partyMemberInformation.names;
    self.sexTF.text = [user getUsergender];
    NSString *datebirth;
    if (user.partyMemberInformation.dateBirth.length) {
        datebirth =  [GmWidget dateFromTimeInterval:[partyDto.dateBirth doubleValue]];
    }else{
        datebirth = @"";
    }
    self.brithdayTF.text = datebirth;
    
  
    //拼接党员信息
    NSString *nameStr = [NSString stringWithFormat:@"姓名：%@",partyDto.names];
    NSString *sexStr = [NSString stringWithFormat:@"性别：%@",[user getUsergender]];
    NSString *nationStr = [NSString stringWithFormat:@"民族：%@",partyDto.nation];
    NSString *placeOfOriginStr = [NSString stringWithFormat:@"籍贯：%@",partyDto.placeOfOrigin];
     NSString *birthStr = [NSString stringWithFormat:@"出生日期：%@", datebirth];
    NSString *timeToJoinThePartyStr = [NSString stringWithFormat:@"入党时间：%@",[GmWidget dateFromTimeInterval:[partyDto.timeToJoinTheParty doubleValue]]];
    NSString *educationStr = [NSString stringWithFormat:@"文化水平：%@",partyDto.education];
    NSString *address = [NSString stringWithFormat:@"住址：%@",partyDto.address];
    NSString *work = [NSString stringWithFormat:@"工作单位：%@",partyDto.workUnit];
    
    NSString *totalStr = [NSString stringWithFormat:@"%@\n%@\n%@\n%@\n%@\n%@\n%@\n%@\n%@\n",nameStr,sexStr,nationStr,placeOfOriginStr,birthStr,timeToJoinThePartyStr,educationStr,address,work];
    self.detailTextView.text = totalStr;
    self.detailTextView.editable = NO;
}

#pragma mark - UI
- (void)addOwnViews{
    
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT - kNavHeight)];
    [self.view addSubview:_scrollView];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    
    //top
    UIView *topBgView = [UIView new];
    [_scrollView addSubview:topBgView];
    topBgView.backgroundColor = kWhiteColor;
    topBgView.f_width  = kSCREEN_WIDTH;
    topBgView.f_height = 146;
    topBgView.f_top = 0;
    topBgView.f_left = 0;
    
    UIImageView *headImge = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"my_head_n"]];
    [topBgView addSubview:headImge];
    headImge.f_centerX = kSCREEN_WIDTH/2;
    headImge.f_top = 38;
    topBgView.f_height = headImge.f_bottom + 32;
    headImge.layer.cornerRadius  = headImge.f_height/2;
    headImge.layer.masksToBounds = YES;
    
  
    //midlle
    STSCustomCell *cell = [[STSCustomCell alloc]initWithFrame:CGRectMake(0, topBgView.f_bottom + 10, kSCREEN_WIDTH, 52) index:10 delegate:nil];
    [_scrollView addSubview:cell];
    cell.titlelb.text = @"姓名";
    cell.arrowdImg.hidden = YES;
    cell.deslb.textColor = rgb(153, 153, 153);
    cell.deslb.f_right = cell.f_width - 15;
    
    STSCustomCell *celltwo = [[STSCustomCell alloc]initWithFrame:CGRectMake(0, cell.f_bottom + 1, kSCREEN_WIDTH, 52) index:11 delegate:nil];
    [_scrollView addSubview:celltwo];
    celltwo.titlelb.text = @"性别";
    celltwo.arrowdImg.hidden = YES;
    celltwo.deslb.textColor = rgb(153, 153, 153);
    celltwo.deslb.f_right = celltwo.f_width - 15;
    
    STSCustomCell *cellthree = [[STSCustomCell alloc]initWithFrame:CGRectMake(0, celltwo.f_bottom + 1, kSCREEN_WIDTH, 52) index:12 delegate:nil];
    [_scrollView addSubview:cellthree];
    cellthree.titlelb.text = @"出生日期";
    cellthree.arrowdImg.hidden = YES;
    cellthree.deslb.textColor = rgb(153, 153, 153);
    cellthree.deslb.f_right = cellthree.f_width - 15;
    
    //bottom
    UIView *bottomView = [UIView new];
    [_scrollView addSubview:bottomView];
    bottomView.backgroundColor = kWhiteColor;
    bottomView.f_width = kSCREEN_WIDTH;
    bottomView.f_height = 100;
    bottomView.f_left = 0;
    bottomView.f_top = cellthree.f_bottom + 10;
    
    UILabel *label = [UILabel new];
    [bottomView addSubview:label];
    label.font = FONTSize(15);
    label.textColor = kappTextColorDrak;
    label.text = @"党员信息";
    [label sizeToFit];
    label.f_left = 15;
    label.f_top = 16;
    
    UIView *infoContentView  = [UIView new];
    [bottomView addSubview:infoContentView];
    infoContentView.backgroundColor = kappBackgroundColor;
    infoContentView.f_width = kSCREEN_WIDTH - 30;
    infoContentView.f_height = 190;
    infoContentView.f_centerX = bottomView.f_width/2;
    infoContentView.f_top = 50;
    infoContentView.layer.cornerRadius = 5.f;
    
    UITextView *infolabel = [UITextView new];
    [infoContentView addSubview:infolabel];
    infolabel.backgroundColor = [UIColor clearColor];
    infolabel.font = FONTSize(13);
    infolabel.textColor = rgb(153, 153, 153);
//    infolabel.numberOfLines = 0;
    infolabel.f_width = infoContentView.f_width - 30;
    infolabel.f_height = infoContentView.f_height - 20;
    infolabel.f_centerX = infoContentView.f_width/2;
    infolabel.f_top = 10;
    
    self.headImage = headImge;
    self.nameTF = cell.deslb;
    self.sexTF = celltwo.deslb;
    self.brithdayTF = cellthree.deslb;
    self.detailTextView = infolabel;
    
    bottomView.f_height = infoContentView.f_bottom + 40;
    _scrollView.contentSize = CGSizeMake(kSCREEN_WIDTH, bottomView.f_bottom);
    

}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
