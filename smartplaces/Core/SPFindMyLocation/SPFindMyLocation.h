//
//  SPFindMyLocation.h
//  smartplaces
//
//  Created by Admin on 12/12/15.
//  Copyright © 2015 ihor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
typedef void (^SPFindMyLocationCallback) (CLLocationCoordinate2D coordinates, NSError *errorMessage);
@interface SPFindMyLocation : NSObject
+ (void)findMyLocation:(SPFindMyLocationCallback)findLocationBlock;
@end
