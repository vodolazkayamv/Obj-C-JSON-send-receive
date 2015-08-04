/*
 Copyright (C) 2015 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 Base or common view controller to share a common UITableViewCell prototype between subclasses.
 */

#import "APLBaseTableViewController.h"


NSString *const kCellIdentifier = @"cellID";
NSString *const kTableCellNibName = @"TableCell";

@implementation APLBaseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // we use a nib which contains the cell's view and this class as the files owner
    [self.tableView registerNib:[UINib nibWithNibName:kTableCellNibName bundle:nil] forCellReuseIdentifier:kCellIdentifier];
}

- (void)configureCell:(UITableViewCell *)cell forStudent:(Student *)student
{
    cell.textLabel.text = student.surname;

    NSString *detailedStr = [NSString stringWithFormat:@"%@ %@", student.name, student.lastname];
    cell.detailTextLabel.text = detailedStr;
}

- (void)configureCell:(UITableViewCell *)cell forGroup:(Group *)group
{
    cell.textLabel.text = group.title;
    
    NSString *detailedStr = [NSString stringWithFormat:@"id = %@", [group.identificator stringValue]];
    cell.detailTextLabel.text = detailedStr;
}

@end
