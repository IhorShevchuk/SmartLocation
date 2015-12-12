//
//  CLGeocoder+formattedAddress.m
//  smartplaces
//
//  Created by Admin on 12/12/15.
//  Copyright © 2015 ihor. All rights reserved.
//

#import "CLGeocoder+formattedAddress.h"
#import "CLPlacemark+FormattedAddress.h"
#import <MapKit/MapKit.h>

@implementation CLGeocoder (formattedAddress)
-(void)reverseGeocodeWithFormatedAddressLocation:(CLLocation*)coordinates completionHandler:(void (^)(NSString *formattedAddres,CLLocationCoordinate2D coordinates,NSError *error))completionHandler {
    
    if(completionHandler == nil) {
        return;
    }
    
    [self reverseGeocodeLocation:coordinates completionHandler:^(NSArray *placemarks, NSError *error)
     {
         if (placemarks && placemarks.count > 0)
         {
             CLPlacemark *placemark = [placemarks objectAtIndex:0];
             completionHandler([placemark address],coordinates.coordinate,error);
         }
     }];
}
@end
