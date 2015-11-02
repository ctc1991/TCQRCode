//
//  TCQRCode.h
//  TCQRCodeDemo
//
//  Created by 程天聪 on 15/11/2.
//  Copyright © 2015年 CTC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "TCQRCodeMacro.h"



@interface TCQRCode : NSObject

+ (UIImage *)QRCodeImageWithContent:(NSString *)content
                               size:(CGFloat)size
                       colorWithRed:(CGFloat)red
                              green:(CGFloat)green
                               blue:(CGFloat)blue;
+ (UIImageView *)QRCodeImageViewWithContent:(NSString *)content
                               colorWithRed:(CGFloat)red
                                      green:(CGFloat)green
                                       blue:(CGFloat)blue
                                centerImage:(UIImage *)centerImage
                                      frame:(CGRect)frame;

@end
