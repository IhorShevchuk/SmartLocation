//
//  SPPlace+Coordinates.m
//  smartplaces
//
//  Created by Admin on 12/12/15.
//  Copyright © 2015 ihor. All rights reserved.
//

#import "SPPlace+Coordinates.h"

@implementation SPPlace (Coordinates)
-(CLLocationCoordinate2D)coordinates {
    CLLocationCoordinate2D result;
    result.latitude     = [self.lat doubleValue];
    result.longitude    = [self.lon doubleValue];
    return result;
}
@end
