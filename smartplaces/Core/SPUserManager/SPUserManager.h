//
//  SPUserManager.h
//  smartplaces
//
//  Created by Admin on 12/10/15.
//  Copyright © 2015 ihor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SPFacebookUser.h"
@interface SPUserManager : NSObject
+ (void)saveToKeyChainUser:(SPFacebookUser*)user;
+ (SPFacebookUser*)getCurrentUser;
+ (void)clearCurrentUser;
@end
