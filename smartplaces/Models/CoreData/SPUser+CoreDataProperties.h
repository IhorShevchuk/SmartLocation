//
//  SPUser+CoreDataProperties.h
//  smartplaces
//
//  Created by Admin on 12/10/15.
//  Copyright © 2015 ihor. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "SPUser.h"

NS_ASSUME_NONNULL_BEGIN

@interface SPUser (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *identifire;
@property (nullable, nonatomic, retain) NSManagedObject *places;

@end

NS_ASSUME_NONNULL_END
