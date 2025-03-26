//
//  EditImageVC.h
//  NFCTaggage
//
//  Created by mac on 2019/11/27.
//  Copyright © 2019 NFCTaggage. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JPImageresizerView.h"

//Obtain the width and height of self view
#define SELF_VIEW_W self.view.frame.size.width
#define SELF_VIEW_H self.view.frame.size.height

#define ImageNamed(_pointer) [UIImage imageNamed:_pointer]

NS_ASSUME_NONNULL_BEGIN

@interface EditImageVC : UIViewController

// 未改变的Image
@property (nonatomic, strong) UIImage *inputImage;

// 图像比例
@property (nonatomic, assign) CGFloat imageScale;


typedef void (^imageBlock)(UIImage *image);
@property (nonatomic, copy) imageBlock imageBlock;

@end

NS_ASSUME_NONNULL_END
