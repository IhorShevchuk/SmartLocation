//
//  UIImage+ImageWithColor.m
//  smartplaces
//
//  Created by Admin on 12/11/15.
//  Copyright © 2015 ihor. All rights reserved.
//

#import "UIImage+ImageWithColor.h"

@implementation UIImage (ImageWithColor)
+ (UIImage *)imageWithColor:(UIColor *)color
{
    return [UIImage imageWithColor:color andSize:CGSizeMake(1.0, 1.0)];
}
+ (UIImage *)imageWithColor:(UIColor *)color andSize:(CGSize)size
{
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width,  size.height);
    
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
@end
