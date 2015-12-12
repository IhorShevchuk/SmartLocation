//
//  SPUser+CoreDataProperties.h
//  smartplaces
//
//  Created by Admin on 12/12/15.
//  Copyright © 2015 ihor. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "SPUser.h"


NS_ASSUME_NONNULL_BEGIN
@class  SPPlace;
@interface SPUser (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *identifire;
@property (nullable, nonatomic, retain) NSSet<SPPlace *> *places;

@end

@interface SPUser (CoreDataGeneratedAccessors)

- (void)addPlacesObject:(SPPlace *)value;
- (void)removePlacesObject:(SPPlace *)value;
- (void)addPlaces:(NSSet<SPPlace *> *)values;
- (void)removePlaces:(NSSet<SPPlace *> *)values;

@end

NS_ASSUME_NONNULL_END
