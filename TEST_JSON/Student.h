//
//  Student.h
//  TEST_JSON
//
//  Created by Мария Водолазкая on 01.08.15.
//  Copyright (c) 2015 Мария Водолазкая. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "UPUtility.h"

@class Group;

@interface Student : NSManagedObject

@property (nonatomic, retain) NSString * surname;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * lastname;
@property (nonatomic, retain) NSNumber * identificator;
@property (nonatomic, retain) Group *group;

+ (Student *) createOrUpdateRecordWithDict:(NSDictionary *)aDict inMoc:(NSManagedObjectContext *)moc;

@end
