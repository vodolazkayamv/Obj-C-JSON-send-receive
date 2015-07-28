//
//  DAO.h
//  iWish
//
//  Created by Водолазкий В.В. on 09.11.14.
//  Copyright (c) 2014 Geomatix Laboratoriess S.R.O. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#import "Student.h"

@interface DAO : NSObject {
	NSManagedObjectContext *moc;
}

+ (DAO *) sharedInstance;

- (void) save;

- (NSFetchedResultsController *) facebookedFriendsWithPredicate:(NSString *)aPredicate;
- (NSFetchedResultsController *) addrBookFriendsWithPredicate:(NSString *)aPredicate;

- (NSFetchedResultsController *) wishesWithPredicate:(NSString *) aPredicate;


- (NSFetchedResultsController *) studentsWithPredicate:(NSString *) aPredicate;

@end
