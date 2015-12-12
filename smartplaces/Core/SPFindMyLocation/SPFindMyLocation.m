//
//  SPFindMyLocation.m
//  smartplaces
//
//  Created by Admin on 12/12/15.
//  Copyright © 2015 ihor. All rights reserved.
//

#import "SPFindMyLocation.h"
#import "CLLocationManager+Category.h"
#import <CoreLocation/CoreLocation.h>
#import "AFNetworking.h"
@interface SPFindMyLocation()<CLLocationManagerDelegate>
@property(nonatomic, strong) CLLocationManager *locationManager;
@property(nonatomic, assign) CLLocationCoordinate2D foundLocation;
@property(nonatomic, assign) BOOL locationWasFound;
@property(nonatomic, strong) SPFindMyLocationCallback callBack;

@end
@implementation SPFindMyLocation
static SPFindMyLocation *_sharedInstance = nil;
+(instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[SPFindMyLocation alloc] init];
    });
    
    return _sharedInstance;
}
-(instancetype)init {
    if(_sharedInstance != nil) {
        return _sharedInstance;
    }
    self = [super init];
    return self;
}
+(instancetype)allocWithZone:(struct _NSZone *)zone {
    if(_sharedInstance != nil) {
        return _sharedInstance;
    }
    return [super allocWithZone:zone];
}
#pragma mark - Public
+(void)findMyLocation:(SPFindMyLocationCallback)findLocationBlock
{
    if(findLocationBlock == nil) {
        return;
    }
    [[SPFindMyLocation sharedInstance] setCallBackBlock:findLocationBlock];
    CLLocationCoordinate2D fakeResult;
    fakeResult.longitude = 0.0;
    fakeResult.latitude = 0.0;
    //Cheking settings and internet connection for abillity to get location
    CLLocationManager *locationManager = [[CLLocationManager alloc]init];
    if (![locationManager checkAuthorizationStatusAndShowErrorViews])
    {
        
        findLocationBlock(fakeResult,nil);
        _sharedInstance = nil;
        return;
    }
    
    if (![AFNetworkReachabilityManager sharedManager].reachable)
    {
        NSString *text = NSLocalizedString(@"Can't get your location. Please check your internet connection.", @"Can't get your location. Please check your internet connection.");
        
        NSError *error = [[NSError alloc]initWithDomain:@"NoConnection" code:404 userInfo:@{@"message":text}];
        findLocationBlock(fakeResult,error);
        _sharedInstance = nil;
        return;
    }
    [[AFNetworkReachabilityManager sharedManager] stopMonitoring];
    
    [[SPFindMyLocation sharedInstance] initExploreNearbyValues];
    [[SPFindMyLocation sharedInstance] doExploreNearbySearch];
}
#pragma mark - Private
-(void)setCallBackBlock:(SPFindMyLocationCallback)newBlock
{
    self.callBack = newBlock;
}
-(void)dealloc
{
    self.callBack = nil;
}
- (void)initExploreNearbyValues {
    self.locationWasFound = NO;
    //Location manager
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
}
- (void)doExploreNearbySearch {
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])
    {
        [self.locationManager requestWhenInUseAuthorization];
    }
    self.locationManager.delegate = self;
    // Check for iOS 8. Without this guard the code will crash with "unknown selector" on iOS 7.
    if ([CLLocationManager locationServicesEnabled])
    {
        [self.locationManager startUpdatingLocation];
    }
}
#pragma mark CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    if (![manager checkAuthorizationStatusAndShowErrorViews])
    {
        [manager stopUpdatingLocation];
        return;
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    if (self.locationWasFound)
    {
        return;
    }
    [manager stopUpdatingLocation];
    self.locationWasFound = YES;
    CLLocation *location = [locations lastObject];
    CLLocationCoordinate2D coordinate = location.coordinate;
    self.foundLocation = coordinate;
    [manager stopUpdatingLocation];
    
    self.callBack(coordinate,nil);
}
@end
