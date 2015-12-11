//
//  UIImage+ImageWithColor.h
//  smartplaces
//
//  Created by Admin on 12/11/15.
//  Copyright © 2015 ihor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (ImageWithColor)
+ (UIImage *)imageWithColor:(UIColor *)color;
+ (UIImage *)imageWithColor:(UIColor *)color andSize:(CGSize)size;
@end
