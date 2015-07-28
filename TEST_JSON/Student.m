//
//  Student.m
//  TEST_JSON
//
//  Created by Мария Водолазкая on 26.07.15.
//  Copyright (c) 2015 Мария Водолазкая. All rights reserved.
//

#import "Student.h"


@implementation Student

@dynamic surname;
@dynamic name;
@dynamic lastname;

+ (Student *) createOrUpdateRecordWithDict:(NSDictionary *)aDict inMoc:(NSManagedObjectContext *)moc
{
    NSString * name = aDict[@"name"];
    NSString * surname = aDict[@"surname"];
    NSString * lastname = aDict[@"lastname"];
    
    NSFetchRequest *req = [[NSFetchRequest alloc] initWithEntityName:[[self class] description]];
    req.predicate = [NSPredicate predicateWithFormat:@"name = %@ AND surname = %@ and lastname = %@", name, surname, lastname];
    NSError *error = nil;
    NSArray *result = [moc executeFetchRequest:req error:&error];
    if (!result && error) {
        
        return nil;
    }
    if (result.count > 0) {
        return result[0];
    } else {
        Student *newStudent = [NSEntityDescription insertNewObjectForEntityForName:[[self class] description] inManagedObjectContext:moc];
        if (newStudent) {
            newStudent.name = name;
            newStudent.surname = surname;
            newStudent.lastname = lastname;
        }
        return newStudent;
    }
    
}

@end
