/*
 Copyright (C) 2015 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 Base or common view controller to share a common UITableViewCell prototype between subclasses.
 */

#import "Student.h"
#import "Group.h"

@import UIKit;

@class APLProduct;

extern NSString *const kCellIdentifier;

@interface APLBaseTableViewController : UITableViewController

- (void)configureCell:(UITableViewCell *)cell forStudent:(Student *)student;
- (void)configureCell:(UITableViewCell *)cell forGroup:(Group *)group;

@end
