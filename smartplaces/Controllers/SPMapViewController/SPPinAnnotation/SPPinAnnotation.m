//
//  SPPinAnnotation.m
//  smartplaces
//
//  Created by Admin on 12/12/15.
//  Copyright © 2015 ihor. All rights reserved.
//

#import "SPPinAnnotation.h"

@implementation SPPinAnnotation
- (id) initWithCoordinate:(CLLocationCoordinate2D)coord andTitle:(nullable NSString *)title andSubTitle:(nullable NSString *)subTitle
{
    self = [super init];
    if(self) {
        _coordinate = coord;
        _title = title;
        _subtitle = subTitle;
    }
    return self;
}
@end
