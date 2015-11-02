//
//  TCQRCode.m
//  TCQRCodeDemo
//
//  Created by 程天聪 on 15/11/2.
//  Copyright © 2015年 CTC. All rights reserved.
//

#import "TCQRCode.h"

@implementation TCQRCode
+ (UIImage *)QRCodeImageWithContent:(NSString *)content
                               size:(CGFloat)size
                       colorWithRed:(CGFloat)red
                              green:(CGFloat)green
                               blue:(CGFloat)blue {
    return [self changeImage:[self createNonInterpolatedUIImageFormCIImage:[self createQRForString:content] withSize:size] ColorWithRed:red green:green blue:blue];
}

+ (UIImageView *)QRCodeImageViewWithContent:(NSString *)content
                               colorWithRed:(CGFloat)red
                                      green:(CGFloat)green
                                       blue:(CGFloat)blue
                                centerImage:(UIImage *)centerImage
                                      frame:(CGRect)frame {
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
    imageView.image = [self changeImage:[self createNonInterpolatedUIImageFormCIImage:[self createQRForString:content] withSize:frame.size.width] ColorWithRed:red green:green blue:blue];
    [self shadowForImageView:imageView];
    CGFloat size = frame.size.width*0.2;
    UIImageView *centerIv = [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width*0.5-size*0.5, frame.size.width*0.5-size*0.5, size, size)];
    centerIv.image = centerImage;
    centerIv.layer.borderWidth = 2.5;
    centerIv.layer.borderColor = [UIColor whiteColor].CGColor;
    centerIv.layer.masksToBounds = YES;
    centerIv.layer.cornerRadius = 4.0;
    [imageView addSubview:centerIv];
    return imageView;
}

#pragma mark - QRCodeGenerator
+ (CIImage *)createQRForString:(NSString *)qrString {
    // Need to convert the string to a UTF-8 encoded NSData object
    NSData *stringData = [qrString dataUsingEncoding:NSUTF8StringEncoding];
    // Create the filter
    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // Set the message content and error-correction level
    [qrFilter setValue:stringData forKey:@"inputMessage"];
    // Level: L(7%) M(15%) Q(25%) H(30%)
    [qrFilter setValue:@"M" forKey:@"inputCorrectionLevel"];
    // Send the image back
    return qrFilter.outputImage;
}

#pragma mark - InterpolatedUIImage
+ (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size {
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    // create a bitmap image that we'll draw into a bitmap context at the desired size;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    // Create an image with the contents of our bitmap
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    // Cleanup
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}

//对二维码进行颜色填充，并转换为透明背景，使用遍历图片像素来更改图片颜色
void ProviderReleaseData (void *info, const void *data, size_t size){
    free((void*)data);
}

+ (UIImage*)changeImage:(UIImage *)image
           ColorWithRed:(CGFloat)red
                  green:(CGFloat)green
                   blue:(CGFloat)blue {
    const int imageWidth = image.size.width;
    const int imageHeight = image.size.height;
    size_t      bytesPerRow = imageWidth * 4;
    uint32_t* rgbImageBuf = (uint32_t*)malloc(bytesPerRow * imageHeight);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(rgbImageBuf, imageWidth, imageHeight, 8, bytesPerRow, colorSpace,
                                                 kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);
    CGContextDrawImage(context, CGRectMake(0, 0, imageWidth, imageHeight), image.CGImage);
    // 遍历像素
    int pixelNum = imageWidth * imageHeight;
    uint32_t* pCurPtr = rgbImageBuf;
    for (int i = 0; i < pixelNum; i++, pCurPtr++){
        if ((*pCurPtr & 0xFFFFFF00) < 0x99999900)    // 将白色变成透明
        {
            // 改成下面的代码，会将图片转成想要的颜色
            uint8_t* ptr = (uint8_t*)pCurPtr;
            ptr[3] = red; //0~255
            ptr[2] = green;
            ptr[1] = blue;
        }
        else
        {
            uint8_t* ptr = (uint8_t*)pCurPtr;
            ptr[0] = 0;
        }
    }
    // 输出图片
    CGDataProviderRef dataProvider = CGDataProviderCreateWithData(NULL, rgbImageBuf, bytesPerRow * imageHeight, ProviderReleaseData);
    CGImageRef imageRef = CGImageCreate(imageWidth, imageHeight, 8, 32, bytesPerRow, colorSpace,
                                        kCGImageAlphaLast | kCGBitmapByteOrder32Little, dataProvider,
                                        NULL, true, kCGRenderingIntentDefault);
    CGDataProviderRelease(dataProvider);
    UIImage* resultUIImage = [UIImage imageWithCGImage:imageRef];
    // 清理空间
    CGImageRelease(imageRef);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    return resultUIImage;
}

+ (void)shadowForImageView:(UIImageView *)imageView {
    imageView.layer.shadowOffset = CGSizeMake(0, 1.0);  // 设置阴影的偏移量
    imageView.layer.shadowRadius = 1;  // 设置阴影的半径
    imageView.layer.shadowColor = [UIColor blackColor].CGColor; // 设置阴影的颜色为黑色
    imageView.layer.shadowOpacity = 0.3; // 设置阴影的不透明度
}

@end
