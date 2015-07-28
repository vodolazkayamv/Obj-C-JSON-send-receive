//
//  Student.h
//  TEST_JSON
//
//  Created by Мария Водолазкая on 26.07.15.
//  Copyright (c) 2015 Мария Водолазкая. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Student : NSManagedObject

@property (nonatomic, retain) NSString * surname;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * lastname;

+ (Student *) createOrUpdateRecordWithDict:(NSDictionary *)aDict inMoc:(NSManagedObjectContext *)moc;

@end
