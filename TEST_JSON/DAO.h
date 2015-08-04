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
#import "Group.h"

@interface DAO : NSObject {
	NSManagedObjectContext *moc;
}

@property (nonatomic, retain) Group *currentGroup;

+ (DAO *) sharedInstance;

- (void) save;

- (NSFetchedResultsController *) facebookedFriendsWithPredicate:(NSString *)aPredicate;
- (NSFetchedResultsController *) addrBookFriendsWithPredicate:(NSString *)aPredicate;

- (NSFetchedResultsController *) groupsWithPredicate:(NSString *) aPredicate;
//- (NSFetchedResultsController *) studentsWithPredicate:(NSString *) aPredicate;
- (NSFetchedResultsController *) studentsWithPredicate:(NSPredicate *) aPredicate;

@end
