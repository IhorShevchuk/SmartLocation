//
//  SPFacebookUser+Converter.m
//  smartplaces
//
//  Created by Admin on 12/10/15.
//  Copyright © 2015 ihor. All rights reserved.
//

#import "SPFacebookUser+Converter.h"

@implementation SPFacebookUser (Converter)
+(instancetype)userFromFacebookResponce:(NSDictionary*)parameters {
    SPFacebookUser *result = [[SPFacebookUser alloc]init];
    result.identifire   = [parameters objectForKey:@"id"];
    result.name         = [parameters objectForKey:@"name"];
    result.avatarUrl    = [[[parameters objectForKey:@"picture"] objectForKey:@"data"] objectForKey:@"url"];
    NSLog(@"resultis:%@",parameters);
    return result;
}
- (void)encodeWithCoder:(NSCoder *)encoder
{
    //Encode properties, other class variables, etc
    [encoder encodeObject:self.identifire forKey:@"id"];
    [encoder encodeObject:self.avatarUrl forKey:@"avatar"];
    [encoder encodeObject:self.name forKey:@"name"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if ((self = [super init]))
    {
        self.identifire          = [decoder decodeObjectForKey:@"id"];
        self.avatarUrl               = [decoder decodeObjectForKey:@"avatar"];
        self.name                = [decoder decodeObjectForKey:@"name"];
    }
    return self;
}@end
