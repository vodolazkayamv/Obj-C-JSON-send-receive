//
//  TESTJSONTableViewController.h
//  TEST_JSON
//
//  Created by Мария Водолазкая on 26.07.15.
//  Copyright (c) 2015 Мария Водолазкая. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Student.h"
#import "AppDelegate.h"
#import "APLResultsTableController.h"
#import "APLBaseTableViewController.h"

@interface TESTJSONTableViewController : APLBaseTableViewController

@property (nonatomic, strong) UISearchController *searchController;
@property (weak, nonatomic) IBOutlet UINavigationItem *myNavigationItem;

// for state restoration
@property BOOL searchControllerWasActive;
@property BOOL searchControllerSearchFieldWasFirstResponder;

- (void) initWithGroup:(Group *)group;

@end
