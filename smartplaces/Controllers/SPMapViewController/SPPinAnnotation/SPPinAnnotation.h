//
//  SPPinAnnotation.h
//  smartplaces
//
//  Created by Admin on 12/12/15.
//  Copyright © 2015 ihor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface SPPinAnnotation : NSObject<MKAnnotation>
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, readonly, copy, nullable) NSString *title;
@property (nonatomic, readonly, copy, nullable) NSString *subtitle;
// add an init method so you can set the coordinate property on startup
- (id) initWithCoordinate:(CLLocationCoordinate2D)coord andTitle:(nullable NSString *)title andSubTitle:(nullable NSString *)subTitle;
@end
