//
//  NFCInkScreen.h
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "InkScreenSDKConfig.h"

/**********************************************
 @Code      1201        Screen casting failed
 @Code      1202        OTA failure
 @Code      1203        Please wait
 @Code      1299        Other errors
 **********************************************/

NS_ASSUME_NONNULL_BEGIN

typedef void(^SuccessBlock)(id obj);
typedef void(^FailedBlock)(id error);

typedef void (^CompressBlock)(unsigned char *inData, size_t inLen, unsigned char *outData, size_t *outLen);

@interface NFCInkScreen : NSObject

@property (nonatomic, copy) void(^NFCError)(NSError *error);
@property (nonatomic, copy) void(^handleDeviceCfgNotmatch)(void);
@property (nonatomic, copy) CompressBlock compressBlock;


@property(nonatomic, assign) NSInteger nInterval;  // Interval casting time,default is 20s
@property(nonatomic, assign) BOOL bShowLog; // Log Switch
@property(nonatomic, assign) BOOL bUseEnhanceMode; // Whether to use enhance mode, default is NO

+ (instancetype)shareInstance;

/**
 Generate corresponding images based on image algorithms

 @param     inputImage      Pending images
 @param     previewImage    Preview pictures
 @param     deviceCfg       Screen configuration
*/
- (NSData*)convertToNFCData:(UIImage*)inputImage previewImage:(UIImage *_Nonnull*_Nullable)previewImage deviceCfg:(InkScreenSDKConfig*)deviceCfg;

/**
 Screen casting

 @param     imageData   Pending screen projection image data
 @param     uuID        Device uuID
 @param     success     Successful callback
 @param     failure     Failed callback
*/
- (void)sendImageData:(NSData *)imageData uuID:(NSString *)uuID success:(SuccessBlock)success failure:(FailedBlock)failure;

/**
 Read device information
 
 @param     success     Successful callback
 @param     failure     Failed callback
*/
- (void)getDeviceInfo:(SuccessBlock)success failure:(FailedBlock) failure;

/**
 Display prompt information

 @param     message             Prompt
 @param     isInvalidaSession   Do you want to end the conversation
*/
- (void)showAlertMsg:(NSString *)message invalidaSession:(BOOL)isInvalidaSession;

@end

NS_ASSUME_NONNULL_END

