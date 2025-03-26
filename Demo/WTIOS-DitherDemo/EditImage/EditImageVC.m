//
//  EditImageVC.m
//  NFCTaggage
//
//  Created by mac on 2019/11/27.
//  Copyright © 2019 NFCTaggage. All rights reserved.
//

#import "EditImageVC.h"
#import "UIView+Extension.h"

@interface EditImageVC ()
@property (nonatomic, strong) JPImageresizerView *imageresizerView;
@property (nonatomic, strong) UIButton *anticlockwiseBtn;
@property (nonatomic, strong) UIButton *clockwiseBtn;
@property (nonatomic, strong) UIButton *verMirrorBtn;
@property (nonatomic, strong) UIButton *horMirrorBtn;
@property (nonatomic, strong) UIButton *fulfillBtn;
//@property (nonatomic, strong) UIButton *

@end

@implementation EditImageVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(70, 10, (40 + 30 + 30 + 10 + 40), 10);
    if ([UIScreen mainScreen].bounds.size.height > 736.0) {
        contentInsets.top += 24;
        contentInsets.bottom += 34;
    }
    JPImageresizerConfigure *configure = [JPImageresizerConfigure blurMaskTypeConfigureWithResizeImage:_inputImage isLight:YES make:^(JPImageresizerConfigure *configure) {
        configure
        .jp_contentInsets(contentInsets)
        .jp_strokeColor(UIColor.whiteColor);
    }];
    
    __weak typeof(self) wSelf = self;
    _imageresizerView = [JPImageresizerView imageresizerViewWithConfigure:configure imageresizerIsCanRecovery:^(BOOL isCanRecovery) {
        __strong typeof(wSelf) sSelf = wSelf;
        if (!sSelf) return;
        // 当不需要重置设置按钮不可点
        // sSelf.recoveryBtn.enabled = isCanRecovery;
    } imageresizerIsPrepareToScale:^(BOOL isPrepareToScale) {
        __strong typeof(wSelf) sSelf = wSelf;
        if (!sSelf) return;
        // 当预备缩放设置按钮不可点，结束后可点击
        BOOL enabled = !isPrepareToScale;
        sSelf.anticlockwiseBtn.enabled = enabled;
        sSelf.clockwiseBtn.enabled = enabled;
        sSelf.verMirrorBtn.enabled = enabled;
        sSelf.horMirrorBtn.enabled = enabled;
        sSelf.fulfillBtn.enabled = enabled;
    }];
    
    [_imageresizerView setResizeWHScale:_imageScale isToBeArbitrarily:NO animated:YES];
    _imageresizerView.frameType = JPClassicFrameType;
    _imageresizerView.isLockResizeFrame = NO;

    [self.view addSubview:_imageresizerView];
    //       self.configure = nil;
    
    // initialResizeWHScale默认为初始化时的resizeWHScale，此后可自行修改initialResizeWHScale的值
    // self.imageresizerView.initialResizeWHScale = 16.0 / 9.0; // 可随意修改该参数
    
    // 调用recoveryByInitialResizeWHScale方法进行重置，则resizeWHScale会重置为initialResizeWHScale的值
    // 调用recoveryByCurrentResizeWHScale方法进行重置，则resizeWHScale不会被重置
    // 调用recoveryByResizeWHScale:方法进行重置，可重置为任意resizeWHScale
    

    [self.view addSubview:self.anticlockwiseBtn];
    [self.view addSubview:self.clockwiseBtn];
    [self.view addSubview:self.verMirrorBtn];
    [self.view addSubview:self.horMirrorBtn];
    [self.view addSubview:self.fulfillBtn];
}


- (void)buttonAction:(UIButton *)button{
    // 逆时针旋转
    if (button == _anticlockwiseBtn) {
        _imageresizerView.isClockwiseRotation = NO;
        [_imageresizerView rotation];
    }
    // 顺时针旋转
    if (button == _clockwiseBtn) {
        _imageresizerView.isClockwiseRotation = YES;
        [_imageresizerView rotation];
    }
    // 垂直镜像
    if (button == _verMirrorBtn) {
        _imageresizerView.verticalityMirror = !_imageresizerView.verticalityMirror;
    }
    // 水平镜像
    if (button == _horMirrorBtn) {
        _imageresizerView.horizontalMirror = !_imageresizerView.horizontalMirror;
    }
    // 完成
    if (button == _fulfillBtn) {
        [self.imageresizerView originImageresizerWithComplete:^(UIImage *resizeImage) {
            [self imageresizerDone:resizeImage];
        }];
    }
}

- (void)imageresizerDone:(UIImage *)resizeImage {
    if (resizeImage) {
        self.imageBlock(resizeImage);
        [self dismissViewControllerAnimated:true completion:nil];
    }
}


- (UIButton *)anticlockwiseBtn
{
    if (!_anticlockwiseBtn) {
        _anticlockwiseBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _anticlockwiseBtn.frame = CGRectMake(15, SELF_VIEW_H - 140, (SELF_VIEW_W - 90)/5, 45);
        [_anticlockwiseBtn setImage:ImageNamed(@"nishizhenxuanzhuan") forState:UIControlStateNormal];
        [_anticlockwiseBtn setTintColor:UIColor.blueColor];
        [_anticlockwiseBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchDown];
    }
    return _anticlockwiseBtn;
}

- (UIButton *)clockwiseBtn{
    if (!_clockwiseBtn) {
        _clockwiseBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _clockwiseBtn.frame = CGRectMake(_anticlockwiseBtn.right+15, _anticlockwiseBtn.y, _anticlockwiseBtn.width, _anticlockwiseBtn.height);
        [_clockwiseBtn setImage:ImageNamed(@"shunshizhenxuanzhuan") forState:UIControlStateNormal];
        [_clockwiseBtn setTintColor:UIColor.blueColor];
        [_clockwiseBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchDown];
    }
    return _clockwiseBtn;
}

- (UIButton *)verMirrorBtn{
    if (!_verMirrorBtn) {
        _verMirrorBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _verMirrorBtn.frame = CGRectMake(_clockwiseBtn.right+15, _anticlockwiseBtn.y, _anticlockwiseBtn.width, _anticlockwiseBtn.height);
        [_verMirrorBtn setImage:ImageNamed(@"chuizhijingxiang") forState:UIControlStateNormal];
        [_verMirrorBtn setTintColor:UIColor.blueColor];
        [_verMirrorBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchDown];
    }
    return _verMirrorBtn;
}

- (UIButton *)horMirrorBtn{
    if (!_horMirrorBtn) {
        _horMirrorBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _horMirrorBtn.frame = CGRectMake(_verMirrorBtn.right+15, _anticlockwiseBtn.y, _anticlockwiseBtn.width, _anticlockwiseBtn.height);
        [_horMirrorBtn setImage:ImageNamed(@"shuipingjingxiang") forState:UIControlStateNormal];
        [_horMirrorBtn setTintColor:UIColor.blueColor];
        [_horMirrorBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchDown];
    }
    return _horMirrorBtn;
}

- (UIButton *)fulfillBtn{
    if (!_fulfillBtn) {
        _fulfillBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _fulfillBtn.frame = CGRectMake(_horMirrorBtn.right+15, _anticlockwiseBtn.y, _anticlockwiseBtn.width, _anticlockwiseBtn.height);
        [_fulfillBtn setImage:ImageNamed(@"wancheng") forState:UIControlStateNormal];
        [_fulfillBtn setTintColor:UIColor.blueColor];
        [_fulfillBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchDown];
    }
    return _fulfillBtn;
}

- (void)dealloc{
    NSLog(@"%s", __func__);
}
@end
