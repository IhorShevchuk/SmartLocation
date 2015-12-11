//
//  JASidePanelController+fakeSharedInstance.m
//  smartplaces
//
//  Created by Admin on 12/11/15.
//  Copyright © 2015 ihor. All rights reserved.
//

#import "JASidePanelController+fakeSharedInstance.h"
#import "AppDelegate.h"

@implementation JASidePanelController (fakeSharedInstance)
+(JASidePanelController*)sharedInstance {
    AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    if([appDelegate.window.rootViewController isKindOfClass:[JASidePanelController class]]) {
        return (JASidePanelController*)appDelegate.window.rootViewController;
    }
    return nil;
}
@end
