#ifdef __OBJC__
#import <UIKit/UIKit.h>
#endif

@interface FMCompressUtils : NSObject

//Compression
+ (BOOL)FMCompressData:(unsigned char *)inData inLen:(size_t)inLen outData:(unsigned char *)outData outLen:(size_t *)outLen;

//Decompression
+ (BOOL)FMDecompressData:(unsigned char *)inData inLen:(size_t)inLen outData:(unsigned char *)outData outLen:(size_t *)outLen;

@end
