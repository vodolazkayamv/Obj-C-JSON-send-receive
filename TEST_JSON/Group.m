//
//  Group.m
//  TEST_JSON
//
//  Created by Мария Водолазкая on 01.08.15.
//  Copyright (c) 2015 Мария Водолазкая. All rights reserved.
//

#import "Group.h"
#import "Student.h"


@implementation Group

@dynamic identificator;
@dynamic title;
@dynamic students;

+ (Group *) createOrUpdateRecordWithDict:(NSDictionary *)aDict inMoc:(NSManagedObjectContext *)moc
{
    NSNumber * ID = @([aDict[@"id"] integerValue]);
    NSString * title = aDict[@"title"];
    
    NSFetchRequest *req = [[NSFetchRequest alloc] initWithEntityName:[[self class] description]];
    req.predicate = [NSPredicate predicateWithFormat:@"identificator = %@", ID];
    
    //DLog("predicate = %@", req.predicate);
    
    NSError *error = nil;
    NSArray *result = [moc executeFetchRequest:req error:&error];
    if (!result && error) {
        DLog(@"error = %@" , [error localizedDescription]);
        return nil;
    }
    if (result.count > 0) {
        Group *currentGroup = result[0];
        currentGroup.identificator = ID;
        currentGroup.title = title;
        return currentGroup;
    } else {
        Group *newGroup = [NSEntityDescription insertNewObjectForEntityForName:[[self class] description] inManagedObjectContext:moc];
        if (newGroup) {
            newGroup.identificator = ID;
            newGroup.title = title;
        }
        return newGroup;
    }
    
}

@end
