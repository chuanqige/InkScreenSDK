//
//  ViewController.m
//  WTIOS-DitherDemo
//
//  Created by Witstec on 2021/3/22.
//

//Obtain screen width and height
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

#import "ViewController.h"
#import <InkScreenSDK/NFCInkScreen.h>
#import <InkScreenSDK/FMCompressUtils.h>
#import "EditImageVC.h"

@interface ViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *OldImg;
@property (weak, nonatomic) IBOutlet UIImageView *NewImg;
@property (nonatomic, strong) NFCInkScreen *nfc;
@property (nonatomic, strong) UIButton *btnReadUID;
@property (nonatomic, strong) UIButton *btnTouPin;
@property (nonatomic, strong) UILabel *lbUseTime;
@property (nonatomic, strong) UIImagePickerController *PhotoPicker;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) InkScreenSDKConfig *deviceCfg;

@property (nonatomic, assign) CGSize screenSize; // screen size
@property (nonatomic, assign) NSTimeInterval startInterval;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    self.image = [UIImage imageNamed:@"kaiconn"];
    
    self.screenSize = CGSizeMake(240, 416);
    
    self.NewImg.image = self.image;
    self.NewImg.userInteractionEnabled = YES;
    [self.NewImg addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewTap:)]];
    
    self.btnReadUID = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.btnReadUID setTitle:@"Read device information" forState:UIControlStateNormal];
    [self.btnReadUID setBackgroundColor:UIColor.blueColor];
    [self.btnReadUID addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.btnReadUID];
    
    self.btnTouPin = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.btnTouPin setTitle:@"Screen casting" forState:UIControlStateNormal];
    [self.btnTouPin setBackgroundColor:UIColor.blueColor];
    [self.btnTouPin addTarget:self action:@selector(btnToupinAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.btnTouPin];
    
    self.lbUseTime = [UILabel new];
    self.lbUseTime.textColor = UIColor.redColor;
    self.lbUseTime.font = [UIFont systemFontOfSize:14];
    self.lbUseTime.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:self.lbUseTime];
}


- (void)btnAction {
    [self.nfc getDeviceInfo:^(id  _Nonnull obj) {
        InkScreenSDKConfig *sdkConfig = (InkScreenSDKConfig *)obj;
        self.deviceCfg = sdkConfig;
        
        [self->_nfc showAlertMsg:@"Successfully read device information" invalidaSession: true];
        NSLog(@"%@", obj);
    } failure:^(id  _Nonnull error) {
        NSLog(@"%@", error);
    }];
}

- (void)btnToupinAction {
    // If device information has not been retrieved, first call getDeviceInfo to retrieve the device information and then immediately call sendImageData to perform the projection.
    // If device information has already been retrieved, you can directly call sendImageData to perform the projection.
    
    UIImage *previewImage = nil;
    if (!self.deviceCfg) {
        [self.nfc getDeviceInfo:^(id  _Nonnull obj) {
            InkScreenSDKConfig *sdkConfig = (InkScreenSDKConfig *)obj;
            self.deviceCfg = sdkConfig;
            self.deviceCfg.algorithmsType = AlgorithmsDither;
            
            if (self.deviceCfg.ratio != 0x00) {
                self.image = [self renderImageInAspectRatio:self.image targetSize:CGSizeMake(self.deviceCfg.screenWidth, self.deviceCfg.screenHeight)];
            }
            
            NSLog(@"%@", obj);
            UIImage *previewImage = nil;
            NSData *imageData = [self.nfc convertToNFCData:self.image previewImage:&previewImage deviceCfg:self.deviceCfg];

            self.NewImg.image = previewImage;
            
            self.startInterval = [[NSDate date] timeIntervalSince1970];
            
            [self.nfc sendImageData:imageData uuID:self.deviceCfg.uuID success:^(id  _Nonnull obj) {
                NSTimeInterval nowInterval = [[NSDate date] timeIntervalSince1970];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    self->_lbUseTime.text = [NSString stringWithFormat:@"TIME：%0.3fs", (nowInterval - self->_startInterval)];
                });
                NSLog(@"Screen projection successful");
            } failure:^(id  _Nonnull error) {
                NSLog(@"Screen casting failed");
            }];
        } failure:^(id  _Nonnull error) {
            NSLog(@"%@", error);
        }];
        return;
    }
    
    self.deviceCfg.algorithmsType = AlgorithmsDither;
    
    // Due to the difference between the screen pixel ratio and the actual screen width-to-height ratio, this operation simulates a scenario where a user selects an image and then edits it. When the user selects an image to be cast, editing may be required. In this case, a canvas with screenWidth and screenHeight can be generated to hold the image. Once the editing is complete, the image data can be processed and cast to the screen.
    if (self.deviceCfg.ratio != 0x00) {
        self.image = [self renderImageInAspectRatio:self.image targetSize:CGSizeMake(self.deviceCfg.screenWidth, self.deviceCfg.screenHeight)];
    }
    
    NSData *imageData = [self.nfc convertToNFCData:self.image previewImage:&previewImage deviceCfg:self.deviceCfg];

    self.NewImg.image = previewImage;
    self.startInterval = [[NSDate date] timeIntervalSince1970];
    
    [self.nfc sendImageData:imageData uuID:self.deviceCfg.uuID success:^(id  _Nonnull obj) {
        NSTimeInterval nowInterval = [[NSDate date] timeIntervalSince1970];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self->_lbUseTime.text = [NSString stringWithFormat:@"TIME：%0.3fs", (nowInterval - self->_startInterval)];
        });
        NSLog(@"Screen projection successful");
    } failure:^(id  _Nonnull error) {
        NSLog(@"Screen casting failed");
        if ([error isKindOfClass:[NSDictionary class]]) {
            if ([error[@"code"] integerValue] == 1203) {
                NSLog(@"Please wait %@ seconds", error[@"value"]);
            }
        }
    }];
}

// After simulating the selection of an image, the editing action requires converting the image to a specific size.
- (UIImage *)renderImageInAspectRatio:(UIImage *)image targetSize:(CGSize)targetSize {
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, targetSize.width, targetSize.height)];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.image = image;
    
    UIGraphicsBeginImageContextWithOptions(targetSize, NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (context) {
        [imageView.layer renderInContext:context];
    }
    UIImage *renderedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return renderedImage;
}

#pragma mark - Pop up image selector
-(void)pushImagePicker{
    self.PhotoPicker = [[UIImagePickerController alloc] init];
    self.PhotoPicker.delegate = self;
//    self.PhotoPicker.allowsEditing = YES;
    self.PhotoPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:self.PhotoPicker animated:YES completion:nil];
}

#pragma mark - deselect
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:^{ }];
}

#pragma mark - Select photos
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info {
    
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    [self dismissViewControllerAnimated:YES completion:^{
        EditImageVC *VC = [[EditImageVC alloc] init];
        VC.imageScale = self.screenSize.width/(self.screenSize.height * 1.0f);
        // It should be the aspect ratio of the screen
        VC.inputImage = image;
        VC.imageBlock = ^(UIImage * _Nonnull newImage) {
            self.NewImg.image = newImage;
            self.image = newImage;
        };
        [self presentViewController:VC animated:true completion:nil];
    }];
}

- (void)imageViewTap:(UITapGestureRecognizer *)tap
{
    [self pushImagePicker];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.OldImg.frame = CGRectZero;
    
    self.NewImg.frame = CGRectMake(SCREEN_WIDTH/2-self.screenSize.width/2, 100, self.screenSize.width, self.screenSize.height);
    [self.btnReadUID setFrame:CGRectMake(CGRectGetMinX(self.NewImg.frame), CGRectGetMaxY(self.NewImg.frame)+66, self.screenSize.width, 42)];
    self.lbUseTime.frame = CGRectMake(CGRectGetMinX(self.NewImg.frame), 50, self.screenSize.width, 42);
    [self.btnTouPin setFrame:CGRectMake(CGRectGetMinX(self.NewImg.frame), CGRectGetMaxY(self.btnReadUID.frame)+32, self.screenSize.width, 42)];
}

- (NFCInkScreen *)nfc
{
    if (!_nfc) {
        _nfc = [NFCInkScreen shareInstance];
        _nfc.bShowLog = true;
        _nfc.nInterval = 20;
        
        _nfc.handleDeviceCfgNotmatch = ^{
            NSLog(@"Device mismatch");
            [self->_nfc getDeviceInfo:^(id  _Nonnull obj) {
                InkScreenSDKConfig *sdkConfig = (InkScreenSDKConfig *)obj;
                self.deviceCfg = sdkConfig;
                [self->_nfc showAlertMsg:@"You can read device information here and continue screen mirroring" invalidaSession: true];  // If only device information is retrieved, you can call this method to end the current session.
            } failure:^(id  _Nonnull error) {
                
            }];
        };
        
        _nfc.compressBlock = ^(unsigned char * _Nonnull inData, size_t inLen, unsigned char * _Nonnull outData, size_t * _Nonnull outLen) {
            [FMCompressUtils FMCompressData:inData inLen:inLen outData:outData outLen:outLen];
        };
    }
    
    // Once After Language Switch
    setNearThePhoneMessage(@"Custom Prompt Text");
    
    return _nfc;
}

@end
