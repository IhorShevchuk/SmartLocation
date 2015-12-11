//
//  SPUserManager.m
//  smartplaces
//
//  Created by Admin on 12/10/15.
//  Copyright © 2015 ihor. All rights reserved.
//

#import "SPUserManager.h"
#import "UICKeyChainStore.h"

#define SPUserKeyChainKey @"SPFacebookUser"
#define BundleIdentifier [[NSBundle mainBundle] bundleIdentifier]
@implementation SPUserManager
+ (void)saveToKeyChainUser:(SPFacebookUser*)user {
    NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:user];
     [UICKeyChainStore setData:encodedObject forKey:SPUserKeyChainKey service:BundleIdentifier];
}
+ (SPFacebookUser*)getCurrentUser {
    NSData *encodedObject = [UICKeyChainStore dataForKey:SPUserKeyChainKey service:BundleIdentifier];
    return (SPFacebookUser *)[NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
}
+ (void)clearCurrentUser {
    [UICKeyChainStore removeItemForKey:SPUserKeyChainKey service:BundleIdentifier];
}
@end
