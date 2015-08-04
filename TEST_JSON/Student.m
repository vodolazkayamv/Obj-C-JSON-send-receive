//
//  Student.m
//  TEST_JSON
//
//  Created by Мария Водолазкая on 01.08.15.
//  Copyright (c) 2015 Мария Водолазкая. All rights reserved.
//

#import "Student.h"
#import "Group.h"
#import "DAO.h"


@implementation Student

@dynamic surname;
@dynamic name;
@dynamic lastname;
@dynamic identificator;
@dynamic group;

+ (Student *) createOrUpdateRecordWithDict:(NSDictionary *)aDict inMoc:(NSManagedObjectContext *)moc
{
    NSNumber * ID = @([aDict[@"id"] integerValue]);
    NSString * name = aDict[@"name"];
    NSString * surname = aDict[@"surname"];
    NSString * lastname = aDict[@"lastname"];
    
    NSFetchRequest *req = [[NSFetchRequest alloc] initWithEntityName:[[self class] description]];
    req.predicate = [NSPredicate predicateWithFormat:@"identificator = %@", ID];
    
    DLog("predicate = %@", req.predicate);
    
    NSError *error = nil;
    NSArray *result = [moc executeFetchRequest:req error:&error];
    if (!result && error) {
        DLog(@"error = %@" , [error localizedDescription]);
        return nil;
    }
    if (result.count > 0) {
        Student *currentStudent = result[0];
        currentStudent.identificator = ID;
        currentStudent.surname = surname;
        currentStudent.name = name;
        currentStudent.lastname = lastname;
        return currentStudent;
    } else {
        Student *newStudent = [NSEntityDescription insertNewObjectForEntityForName:[[self class] description] inManagedObjectContext:moc];
        if (newStudent) {
            newStudent.identificator = @([ID integerValue]);
            newStudent.name = name;
            newStudent.surname = surname;
            newStudent.lastname = lastname;
            Group *group = [DAO sharedInstance].currentGroup;
            if (group == nil)
            {
                DLog(@"[DAO sharedInstance].currentGroup = nil!!!");
            }
            else {
                newStudent.group = group;
            }
        }
        return newStudent;
    }
    
}


@end
