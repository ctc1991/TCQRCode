//
//  CALayer+CGColorForSb.m
//  HombotControl
//
//  Created by 程天聪 on 15/8/20.
//  Copyright (c) 2015年 robotechn. All rights reserved.
//

#import "CALayer+CGColorForSb.h"

@implementation CALayer (CGColorForSb)

- (void)setBorderColorFromUIColor:(UIColor *)color
{
    self.borderColor = color.CGColor;
}

@end
