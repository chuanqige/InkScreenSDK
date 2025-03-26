#import "FMCompressUtils.h"
#import "minilzo.h"
#import "lzoconf.h"
#import "lzodefs.h"

#define HEAP_ALLOC(var,size) \
    lzo_align_t __LZO_MMODEL var [ ((size) + (sizeof(lzo_align_t) - 1)) / sizeof(lzo_align_t) ]

static HEAP_ALLOC(wrkmem, LZO1X_1_MEM_COMPRESS);

@interface FMCompressUtils()

@end

@implementation FMCompressUtils

//数据压缩
+ (BOOL)FMCompressData:(unsigned char *)inData inLen:(size_t)inLen outData:(unsigned char *)outData outLen:(size_t *)outLen
{
    //压缩算法初始化
    if (lzo_init() != LZO_E_OK)
    {
        NSLog(@"lzo init error");
        return NO;
    }
    
    int r = 0;
    //清空outData
    lzo_memset(outData, 0, *outLen);
    //压缩数据
    r = lzo1x_1_compress(inData, inLen, outData, &(*outLen), wrkmem);
    if (r != LZO_E_OK){
        NSLog(@"compress error: %d", r);
        return NO;
    }
    return  YES;
}

//数据解压缩
+ (BOOL)FMDecompressData:(unsigned char *)inData inLen:(size_t)inLen outData:(unsigned char *)outData outLen:(size_t *)outLen
{
    //压缩算法初始化
    if (lzo_init() != LZO_E_OK)
    {
        NSLog(@"lzo init error");
        return NO;
    }
    
    int r = 0;
    //清空outData
    lzo_memset(outData, 0, *outLen);
    //压缩数据
    r = lzo1x_decompress(inData, inLen, outData, &(*outLen), NULL);
    if (r != LZO_E_OK){
        NSLog(@"decompress error: %d", r);
        return NO;
    }
    printf("decompressed %lu bytes into %lu bytes\n",
        (unsigned long) inLen, (unsigned long) outLen);
    return  YES;
}

@end
