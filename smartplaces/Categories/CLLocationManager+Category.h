//
//  CLLocationManager+CLLocationManager_Category.h
//  Hagtap
//
//  Created by Hagtap on 12/29/14.
//  Copyright (c) 2014 Hagtap. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>
@interface CLLocationManager (Category)
//messages and errors
-(BOOL)checkAuthorizationStatusAndShowErrorViews;
@end
