//
//  CLPlacemark+FormattedAddress.m
//  smartplaces
//
//  Created by Admin on 12/12/15.
//  Copyright © 2015 ihor. All rights reserved.
//

#import "CLPlacemark+FormattedAddress.h"

@implementation CLPlacemark (FormattedAddress)
-(NSString *)address {
    NSMutableString * address;
    address = [self.country mutableCopy];
    if(self.country == nil) {
        address = [self.ocean mutableCopy];
    }
    if(self.locality != nil)
    {
        [address appendString:@" "];
        [address appendString:self.locality];
    }
    if(self.thoroughfare != nil)
    {
        [address appendString:@" "];
        [address appendString:self.thoroughfare];
    }
    if(self.subThoroughfare != nil)
    {
        [address appendString:@" "];
        [address appendString:self.subThoroughfare];
    }
    return address;
}
@end
