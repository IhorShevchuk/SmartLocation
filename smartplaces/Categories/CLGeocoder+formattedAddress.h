//
//  CLGeocoder+formattedAddress.h
//  smartplaces
//
//  Created by Admin on 12/12/15.
//  Copyright © 2015 ihor. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

@interface CLGeocoder (formattedAddress)
-(void)reverseGeocodeWithFormatedAddressLocation:(CLLocation*)coordinates completionHandler:(void (^)(NSString *formattedAddres,CLLocationCoordinate2D coordinates,NSError *error))completionHandler;
@end
