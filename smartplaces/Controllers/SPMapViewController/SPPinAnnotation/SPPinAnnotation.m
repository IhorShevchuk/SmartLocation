//
//  SPPinAnnotation.m
//  smartplaces
//
//  Created by Admin on 12/12/15.
//  Copyright © 2015 ihor. All rights reserved.
//

#import "SPPinAnnotation.h"
@interface SPPinAnnotation()

@end
@implementation SPPinAnnotation
- (id) initWithPlace:(SPPlace *)place
{
    self = [super init];
    if(self) {
        
        _coordinate.latitude = [place.lat doubleValue];
        _coordinate.longitude = [place.lon doubleValue];
        _title = place.name;
        _subtitle = place.formattedAddres;
        _place = place;
    }
    return self;
}
@end
