//
//  STAlertView.m
//  STS_Master
//
//  Created by GML on 2017/10/24.
//  Copyright © 2017年 Jiujian. All rights reserved.
//

#import "STAlertView.h"



@interface STAlertView ()



@property (nonatomic , assign)AlertVIewStyle style;
@property (nonatomic , strong)NSString *des;
@property (nonatomic , strong)NSString *title;
@property (nonatomic , strong)UIColor *bodyColor;
@property (nonatomic , strong)NSArray *BtnArr;

@property (nonatomic , strong)UIView *bodyView;
@property (nonatomic , strong)UIView *bottomView;


@property (nonatomic , strong)UILabel *titlelb;
@property (nonatomic , strong)UITextField *textField;
@property (nonatomic , assign)UIKeyboardType keyboardtype;

@property (nonatomic , copy)void(^sureClick)(NSString *text);
@property (nonatomic , copy)void(^cancelClik)(void);

@end

@implementation STAlertView

- (instancetype)initWithNomalstyleByDes:(NSString *)des
{
    
    return [self initWithDes:des title:@"温馨提示" style:AlertVIewStyle_Nomarl btnArr:@[@"取消",@"确定"] bodyColor:nil];
}
    



- (instancetype)initWithDes:(NSString *)des title:(NSString *)title style:(AlertVIewStyle)style
                     btnArr:(NSArray <NSString *>*)BtnArr
                  bodyColor:(UIColor *)bodyColor
{
    self = [super init];
    if (self) {
        self.style = style;
        self.title = title;
        self.des = des;
        self.bodyColor = bodyColor;
        self.BtnArr = BtnArr.copy;
        [self gmconfigViews];
    }
    return self;
}

- (instancetype)initWithTextInputTitle:(NSString *)title des:(NSString *)des keybroadtype:(UIKeyboardType)keybroad sureBtnClick:(void(^)(NSString *text))sureBtnblock cancelBtnClik:(void(^)(void))cancelBlock
{
    self = [super init];
    if (self) {
        self.style = AlertVIewStyle_TextInput;
        self.title = title;
        self.des = des;
        self.keyboardtype = keybroad;
        self.bodyColor = kWhiteColor;
        self.BtnArr = @[@"取消",@"确定"];
        self.sureClick = sureBtnblock;
        self.cancelClik = cancelBlock;
        
        [self gmconfigViews];
    }
    return self;
}

- (void)gmconfigViews{
    
    self.f_width  = kSCREEN_WIDTH - 90;
    self.f_height = 100;
    
    self.layer.cornerRadius = 5.f;
    self.layer.masksToBounds = YES;
    
    _bodyView = [UIView new];
    [self addSubview:_bodyView];
    _bodyView.f_width = self.f_width;
    _bodyView.f_height = 10;
    if (self.bodyColor) {
        _bodyView.backgroundColor = self.bodyColor;
    }else{
        _bodyView.backgroundColor = rgb(65, 168, 255);
    }

    CGFloat titleH = 50;
    
    UILabel *title = [UILabel new];
    if (self.title.length) {
        [_bodyView addSubview:title];
        title.font = FONTSize(15);
        title.textColor = kappTextColorDrak;
        title.textAlignment = NSTextAlignmentCenter;
        title.text = self.title;
        title.f_width  = self.f_width - 30;
        title.f_height = 20;
        title.f_centerY = titleH/2;
        title.f_centerX = self.f_width/2;
        self.titlelb = title;
    }
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(20, titleH, self.f_width - 40, 0.5)];
    [_bodyView addSubview:lineView];
    lineView.backgroundColor = kappBackgroundColor;
    
    
     CGFloat bodyH = 100;
    if (self.style == AlertVIewStyle_TextInput) {
        title.textColor = kappTextColorDrak;
        UITextField *textfield = [[UITextField alloc]init];
        [_bodyView addSubview:textfield];
        textfield.font = FONTSize(14);
        textfield.f_width = self.f_width - 60;
        textfield.f_height = 40;
        textfield.f_centerX = self.f_width/2;
        textfield.f_centerY = bodyH/2 + lineView.f_bottom;
        textfield.layer.borderWidth = 1.f;
        textfield.layer.borderColor = kappBackgroundColor.CGColor;
//        textfield.layer.cornerRadius = 5.f;
        textfield.backgroundColor = kWhiteColor;
        if (self.des.length) {
            textfield.text = self.des;
        }
        [textfield addTarget:self action:@selector(textfeildDidChange:) forControlEvents:UIControlEventEditingChanged];
        
        if (self.keyboardtype) {
            textfield.keyboardType = self.keyboardtype;
        }
        
        self.textField = textfield;
        
    }else{
        UILabel *Deslb = [UILabel new];
        [_bodyView addSubview:Deslb];
        Deslb.font = FONTSize(13);
        Deslb.textColor  = kappTextColorlingtGray;
        Deslb.numberOfLines = 0;
        
        CGFloat nomarlW = self.f_width - 30;
        CGFloat maxH = [self.des sc_calculateHeightInFontSize:13 withStableWidth:nomarlW];
        if (maxH < 20) {
            Deslb.textAlignment = NSTextAlignmentCenter;
        }else{
            Deslb.textAlignment = NSTextAlignmentLeft;
        }
        
        Deslb.size = CGSizeMake(nomarlW, maxH);
        Deslb.text = self.des;
        Deslb.centerX = self.f_width/2;
        Deslb.f_centerY =  bodyH/2 + lineView.f_bottom;
        self.deslb = Deslb;
    
    }
    
    _bodyView.f_height = titleH+bodyH;
    _bodyView.f_top = 0;
    _bodyView.f_left = 0;
    
    
    _bottomView = [UIView new];
    [self addSubview:_bottomView];
    _bottomView.f_width = self.f_width;
    _bottomView.f_height = 45;
    _bottomView.backgroundColor = kWhiteColor;
    _bottomView.f_top = _bodyView.f_bottom;
    _bottomView.f_left = 0;
    
    self.f_height = _bottomView.f_bottom;
    
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.size =CGSizeMake(self.f_width, _bottomView.f_height);
    leftBtn.backgroundColor = kWhiteColor;
    leftBtn.titleLabel.font = FONTSize(15);
    [leftBtn setTitleColor:kappTextColorDrak forState:UIControlStateNormal];
    [leftBtn setTitle:self.BtnArr[0] forState:UIControlStateNormal];
    

    [_bottomView addSubview:leftBtn];
    leftBtn.f_left = 0;
    leftBtn.f_top = 0;
    leftBtn.tag = 0;
    
    [leftBtn addTarget:self action:@selector(leftBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    if (self.BtnArr.count == 2) {
       
        leftBtn.size = CGSizeMake(self.f_width/2, _bottomView.f_height);
        
        UIView *lineView = [UIView new];
        [_bottomView addSubview:lineView];
        lineView.frame = CGRectMake(leftBtn.f_right, 2, 1.f, _bottomView.f_height-4);
        lineView.backgroundColor = kappBackgroundColor;
        
        UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        rightBtn.size =CGSizeMake(self.f_width/2, _bottomView.f_height);
        rightBtn.backgroundColor = kWhiteColor;
        rightBtn.titleLabel.font = FONTSize(15);
        [rightBtn setTitleColor:kappTextColorDrak forState:UIControlStateNormal];
        [rightBtn setTitle:self.BtnArr[1] forState:UIControlStateNormal];
//        STglobalButton *rightBtn = [STglobalButton buttonWithType:UIButtonTypeCustom size: title:self.BtnArr[1] style:GlobalButtonStyle_whiteColor conerRadius:0];
        [_bottomView addSubview:rightBtn];
        rightBtn.f_left = lineView.f_right+1;
        rightBtn.f_top = 0;
        rightBtn.tag = 0;
        
         [rightBtn addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
}

- (void)leftBtnClick:(UIButton *)sender{

    if (self.style == AlertVIewStyle_TextInput) {
        self.cancelClik();
    }else{
    
        if (self.alertBtnClickBlock) {
            if (self.BtnArr.count == 2) {
               self.alertBtnClickBlock(NO,sender);
            }else{
                self.alertBtnClickBlock(YES,sender);
            }
            
        }
    }
    [self dismisAlert];
}
- (void)rightBtnClick:(UIButton *)sender{
    
    if (self.style == AlertVIewStyle_TextInput) {
        self.sureClick(self.textField.text);
    }else{
    
        if (self.alertBtnClickBlock) {
            self.alertBtnClickBlock(YES,sender);
        }
    }
    [self dismisAlert];
}

- (void)alertRsponse:(void(^)(BOOL yesOrNO,UIButton *Btn))responseBlock{
    self.alertBtnClickBlock = responseBlock;
    
}

- (void)showAlert{
    
    [SKPopupHelper_shareInstance skpop_FadeInCenter:self offCenterY:0 defaultHideEnable:NO alphaBG:0.5];
    if (self.style == AlertVIewStyle_TextInput) {
        [self.textField resignFirstResponder];
        
        [self.textField becomeFirstResponder];
    }
}

- (void)dismisAlert{

    [SKPopupHelper_shareInstance skpop_FadeOut:self completion:^(UIWindow *window, UIView *view) {
        
    }];
}
#pragma mark - xxxx
- (void)textfeildDidChange:(UITextField *)textField{
    
    NSInteger kMaxLength = 30;
    
    NSString *toBeString = textField.text;
    NSString *lang = [[UIApplication sharedApplication]textInputMode].primaryLanguage; //ios7之前使用[UITextInputMode currentInputMode].primaryLanguage
    if ([lang isEqualToString:@"zh-Hans"]) { //中文输入
        UITextRange *selectedRange = [textField markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        if (!position) {// 没有高亮选择的字，则对已输入的文字进行字数统计和限制
            if (toBeString.length > kMaxLength) {
                textField.text = [toBeString substringToIndex:kMaxLength];
            }
        }
        else{//有高亮选择的字符串，则暂不对文字进行统计和限制
        }
    }else{//中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
        if (toBeString.length > kMaxLength) {
            textField.text = [toBeString substringToIndex:kMaxLength];
        }
    }
    
}

@end
