//
//  SPFacebookUser+Converter.h
//  smartplaces
//
//  Created by Admin on 12/10/15.
//  Copyright © 2015 ihor. All rights reserved.
//

#import "SPFacebookUser.h"

@interface SPFacebookUser (Converter)
+(instancetype)userFromFacebookResponce:(NSDictionary*)parameters;
@end
