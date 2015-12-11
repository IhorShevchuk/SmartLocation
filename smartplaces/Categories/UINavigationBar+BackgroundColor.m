//
//  UINavigationBar+BackgroundColor.m
//  smartplaces
//
//  Created by Admin on 12/11/15.
//  Copyright © 2015 ihor. All rights reserved.
//

#import "UINavigationBar+BackgroundColor.h"
#import "UIImage+ImageWithColor.h"

@implementation UINavigationBar (BackgroundColor)

-(void)showWithColor:(UIColor *)color
{
    [self setBackgroundImage:[UIImage imageWithColor:color andSize:CGSizeMake(self.bounds.size.width, self.bounds.size.height + 20)]
               forBarMetrics:UIBarMetricsDefault];
    [self setShadowImage:[UIImage new]];
    self.barStyle = UIBarStyleDefault;
    self.backgroundColor = [UIColor clearColor];
}
@end
