//
//  DAO.m
//  iWish
//
//  Created by Водолазкий В.В. on 09.11.14.
//  Copyright (c) 2014 Geomatix Laboratoriess S.R.O. All rights reserved.
//

#import "DAO.h"
#import "AppDelegate.h"
#import "UPUtility.h"


@implementation DAO

+ (id)sharedInstance {
	static DAO *sharedDAO = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		sharedDAO = [[self alloc] init];
	});
	return sharedDAO;
}


- (id) init
{
	if (self = [super init]) {
		AppDelegate *d = (AppDelegate *)[[UIApplication sharedApplication] delegate];
		moc = d.managedObjectContext;
		NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
		[nc addObserver:self selector:@selector(updateGroupList:) name:NOTIFY_LoadedStudentsData object:nil];
	}
	return self;
}

- (void) save
{
	[moc save:nil];
}


#pragma mark - общий fetchedResultsController

- (NSFetchedResultsController *) fetchedResultsControllerByKey:(NSString *)key substring:(NSString *)substring
												   entityName:(NSString *)name
												 andPredicate:(NSPredicate *)predicate
{
	
	if (key == nil) {
		key = @"name";
	}
	NSFetchRequest *req = [[NSFetchRequest alloc] initWithEntityName:name];
	NSSortDescriptor *srt = [NSSortDescriptor sortDescriptorWithKey:key ascending:YES];
	
	if (predicate != nil) {
		[req setPredicate:predicate];
	}
	
	[req setSortDescriptors:[NSArray arrayWithObject:srt]];
	NSError __block *error = nil;
	NSFetchedResultsController __block *fetchController = nil;
	fetchController = [[NSFetchedResultsController alloc] initWithFetchRequest:req managedObjectContext:moc sectionNameKeyPath:nil cacheName:[NSString stringWithFormat:@"cache%@",name]];
	[fetchController performFetch:&error];
	if (error) {
		//DLog(@"DAO :: %@ --> %@", NSStringFromSelector(_cmd), error);
		return nil;
	}
	
	return fetchController;
}

- (NSFetchedResultsController *) facebookedFriendsWithPredicate:(NSString *)aPredicate
{
	NSString *substring = (aPredicate ? [NSString stringWithFormat:@"username contains[c] %@",aPredicate] : nil);
	NSPredicate *pred = [NSPredicate predicateWithFormat:@"facebookId <> NULL"];
	
	return [self fetchedResultsControllerByKey:@"userName" substring:substring entityName:@"Friends" andPredicate:pred];
}

- (NSFetchedResultsController *) addrBookFriendsWithPredicate:(NSString *)aPredicate
{
	NSString *substring = (aPredicate ? [NSString stringWithFormat:@"username contains[c] %@",aPredicate] : nil);
	NSPredicate *pred = [NSPredicate predicateWithFormat:@"userId <> NULL"];
	
	return [self fetchedResultsControllerByKey:@"userName" substring:substring entityName:@"Friends" andPredicate:pred];
	
}

- (NSFetchedResultsController *) wishesWithPredicate:(NSString *) aPredicate
{
	NSString *substring = (aPredicate ? [NSString stringWithFormat:@"note contains[c] %@",aPredicate] : nil);
	return [self fetchedResultsControllerByKey:@"dateCreated" substring:substring entityName:@"Wish" andPredicate:nil];

}

- (NSFetchedResultsController *) studentsWithPredicate:(NSString *) aPredicate
{
    NSString *substring = (aPredicate ? [NSString stringWithFormat:@"surname contains[c] %@",aPredicate] : nil);
    return [self fetchedResultsControllerByKey:@"surname" substring:substring entityName:@"Student" andPredicate:nil];
}


#pragma mark - Селекторы

- (void) updateGroupList:(NSNotification *) note
{
	NSArray *result = [note object];
    for (NSDictionary *record in result) {
        Student *s = [Student createOrUpdateRecordWithDict:record inMoc:moc];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_DataUpdated object:nil];
}




@end
