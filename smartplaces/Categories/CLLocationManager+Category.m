//
//  CLLocationManager+CLLocationManager_Category.m
//  Hagtap
//
//  Created by Hagtap on 12/29/14.
//  Copyright (c) 2014 Hagtap. All rights reserved.
//

#import "CLLocationManager+Category.h"
#import "UIViewController+topViewController.h"
@implementation CLLocationManager (Category)

-(BOOL)checkAuthorizationStatusAndShowErrorViews
{
    if (![CLLocationManager locationServicesEnabled])
    {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Can't get your location!",@"Can't get your location!") message:NSLocalizedString(@"You can't use this option becouse your location servises is disabled.\nPlease go to 'Settings' -> 'Privacy' -> 'Location Services' and turn them on.",@"You can't use this option becouse your location servises is disabled. Please go to 'Settings' -> 'Privacy' -> 'Location Services' and turn them on.") delegate:nil cancelButtonTitle:NSLocalizedString(@"Ok",@"Ok") otherButtonTitles: nil];
        [alertView show];
        return NO;
    }
    if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied)
    {
        if([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
        {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Can't get your location!",@"Can't get your location!") message:NSLocalizedString(@"You can't use this option because you disabled location services for Hagtap.\nYou can turn them on in Settings.",@"You can't use this option because you disabled location services for Hagtap.\nYou can turn them on in Settings.") preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"No",@"No") style:UIAlertActionStyleCancel handler:nil]];
            [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Go to Settings",@"Go to Settings") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
            }]];
            [[UIViewController topViewController] presentViewController:alertController animated:YES completion:nil];
        }
        else
        {
            UIAlertView *alertView;
            alertView = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Can't get your location!",@"Can't get your location!") message:NSLocalizedString(@"Hey silly, you need to turn on your ‘Location Services’ to use this option.\nPlease go to 'Settings' -> 'Privacy' -> 'Location Services' and turn them on.",@"Hey silly, you need to turn on your ‘Location Services’ to use this option.\nPlease go to 'Settings' -> 'Privacy' -> 'Location Services' and turn them on.") delegate:nil cancelButtonTitle:NSLocalizedString(@"Ok",@"Ok") otherButtonTitles: nil];
            [alertView show];
        }
        
        return NO;
    }
    
    return YES;
}
@end