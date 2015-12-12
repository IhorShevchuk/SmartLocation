//
//  SPPlace+CoreDataProperties.h
//  smartplaces
//
//  Created by Admin on 12/12/15.
//  Copyright © 2015 ihor. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "SPPlace.h"

NS_ASSUME_NONNULL_BEGIN

@interface SPPlace (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *formattedAddres;
@property (nullable, nonatomic, retain) NSNumber *lat;
@property (nullable, nonatomic, retain) NSNumber *lon;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) SPUser *user;

@end

NS_ASSUME_NONNULL_END
