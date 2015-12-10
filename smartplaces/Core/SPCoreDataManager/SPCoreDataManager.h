//
//  SPCoreDataManager.h
//  smartplaces
//
//  Created by Admin on 12/10/15.
//  Copyright © 2015 ihor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SPPlace.h"
#import "SPUser.h"

@interface SPCoreDataManager : NSObject
+(SPUser*)getCurrentUser;
+(void)saveContext;
@end
