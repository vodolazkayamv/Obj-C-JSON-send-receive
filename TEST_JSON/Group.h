//
//  Group.h
//  TEST_JSON
//
//  Created by Мария Водолазкая on 01.08.15.
//  Copyright (c) 2015 Мария Водолазкая. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "UPUtility.h"

@class Student;

@interface Group : NSManagedObject

@property (nonatomic, retain) NSNumber * identificator;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSSet *students;

+ (Group *) createOrUpdateRecordWithDict:(NSDictionary *)aDict inMoc:(NSManagedObjectContext *)moc;

@end
