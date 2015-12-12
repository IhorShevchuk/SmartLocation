//
//  SPPlace+Coordinates.h
//  smartplaces
//
//  Created by Admin on 12/12/15.
//  Copyright © 2015 ihor. All rights reserved.
//

#import "SPPlace.h"
#import <MapKit/MapKit.h>
@interface SPPlace (Coordinates)
-(CLLocationCoordinate2D)coordinates;
@end
