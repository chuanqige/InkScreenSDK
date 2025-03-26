//
//  InkScreenSDKConfig.h
//  WTIOS-DitherDemo
//
//  Created by mac on 2023/7/11.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#define DIC_KEY_BLACK               @"000"              //BLACK
#define DIC_KEY_WHITE               @"001"              //WHITE
#define DIC_KEY_RED                 @"010"              //RED
#define DIC_KEY_YELLOW              @"011"              //YELLOW

#define DIC_KEY_GREEN               @"100"              //GREEN
#define DIC_KEY_BLUE                @"101"              //BLUE
#define DIC_KEY_ORANGE              @"110"              //ORANGE

// Screen type
typedef NS_ENUM(NSUInteger, ScreenType) {
    ScreenTypeBW            = 0,        //Black, white
    ScreenTypeBWR           = 1,        //Black, white, red
    ScreenTypeBWRY          = 2,        //Black, white, red, yellow
    ScreenTypeBWRYGB        = 3,        //Black, white, red, yellow, green, blue
    ScreenTypeBWRYGBO       = 4,        //Black, white, red, yellow, green, blue, orange
};

// Image processing algorithm
typedef NS_ENUM(NSUInteger, AlgorithmsType) {
    AlgorithmsBlackWhite          = 0,        //BlackWhite
    AlgorithmsColorGradation      = 1,        //Gradation
    AlgorithmsDither              = 2,        //Dither
};

// Image synthesis mode
typedef NS_ENUM(NSUInteger, CombineType) {
    SingleType              = 0,        //Single mode
    ComplexType             = 1,        //Dual mode
    Color4Type              = 2,        //Four mode
    Color6Type              = 3,        //Six mode
    Color7Type              = 4         //Seven mode
};

// Image scanning mode
typedef NS_ENUM(NSUInteger, ScanType) {
    HorizontalType          = 0,        //Horizontal scan
    VerticalType            = 1         //Vertical scan
};

@interface InkScreenSDKConfig : NSObject

/**
 Image Processing - default - AlgorithmsDither
 */
@property (nonatomic, assign) AlgorithmsType algorithmsType;

/**
 Screen type - default - ScreenTypeBWRY
 */
@property (nonatomic, assign) ScreenType screenType;

/**
 Image synthesis mode - default - Color4Type
 */
@property (nonatomic, assign) CombineType combineType;

/**
 Image scanning mode - default - HorizontalType
 */
@property (nonatomic, assign) ScanType scanType;

/**
 The color value is determined by the screen factory driver
 eg:
 Black,white                black："00"  white："01"
 Black,white,red            black："02" white："00" red："01"
 Black,white,red,yellow     black："00" white："01" red："03" yellow："02" (default)
 */
@property (nonatomic, strong) NSDictionary *colorDic;

//Do you need to flip the image horizontally
//YES - Need to flip horizontally
//NO - 不需要水平翻转
@property (nonatomic, assign) BOOL flipHorizontal;
//Do you need to flip the image vertically
//YES - Need to flip vertically
//NO - No need to flip vertically
@property (nonatomic, assign) BOOL flipVertical;

//Screen width - default - 240
@property (nonatomic, assign) NSInteger screenWidth;
//Screen height - default - 416
@property (nonatomic, assign) NSInteger screenHeight;
//Screen pixels - width - default - 240
@property (nonatomic, assign) NSInteger pixelsWidth;
//Screen pixels - height - default - 416
@property (nonatomic, assign) NSInteger pixelsHeight;
//Does it support compression - default - false
@property (nonatomic, assign) BOOL supportCompress;
//Batch number - default - 0x00
@property (nonatomic, assign) NSInteger batchNumber;
//Manufacturer ID - default - 0x00
@property (nonatomic, assign) NSInteger manufacturerNumber;
//identifier
@property (nonatomic, strong) NSString *uuID;
//firmwareVersion
@property (nonatomic, strong) NSString *firmwareVersion;
//Ratio - default - 0x00
/**
 - 0x00 According to the return width ratio
 - 0x01 2:3
 - 0x02 4:3
 - 0x03 16:9
 - 0x04 56:53
 */
@property (nonatomic, assign) NSInteger ratio;
//Default 0x00
/**
 - 0x00 Single screen
 - 0x01 Dual screen
 */
@property (nonatomic, assign) NSInteger comboType;
//Default 0x00
/**
 - 0x00 Single screen data
 - 0x02 Dual screen data
 */
@property (nonatomic, assign) NSInteger packetPerType;
//Protocol version - default - 0x00
@property (nonatomic, assign) NSInteger protocolVersion;

/**
 Default initialization method
 */
+ (InkScreenSDKConfig *)defaultConfig;

// Define methods for users to set prompts
void setNearThePhoneMessage(NSString *message);
void setLowOSVersionMessage(NSString *message);
void setModelNotSupportMessage(NSString *message);
void setOtherFailMessageMessage(NSString *message);
void setTagNotSupportMessage(NSString *message);
void setConnectedFailedMessage(NSString *message);
void setRefreshFailedMessage(NSString *message);
void setRefreshSuccessfulMessage(NSString *message);
void setOperationFailedMessage(NSString *message);
void setDataSendingProgressMessage(NSString *message);
void setDataCannotBeEmptyMessage(NSString *message);
void setReadDeviceInfoMessage(NSString *message);
void setRefreshingMessage(NSString *message);
void setNotMatchMessage(NSString *message);
void setChannelMismatchMessage(NSString *message);
void setPleaseWaitMessage(NSString *message);
void setImageSendingProgressMessage(NSString *message);
@end

NS_ASSUME_NONNULL_END
