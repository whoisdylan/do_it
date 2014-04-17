//
//  WHOTaskTableViewController.m
//  do_it
//
//  Created by dylan on 3/17/14.
//  Copyright (c) 2014 whoisdylan. All rights reserved.
//

#import "WHOTaskTableViewController.h"
#import "WHONewTaskFormViewController.h"
#import "WHOEditTaskFormViewController.h"
#import "WHOTask.h"
#import "WHOTaskCell.h"
#import <Parse/Parse.h>

@interface WHOTaskTableViewController () <WHOTaskProtocol, WHOEditTaskProtocol, SWTableViewCellDelegate>

@end

@implementation WHOTaskTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        self.tasks = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //load the current user's tasks from Parse
    PFQuery* query = [PFQuery queryWithClassName:@"Task"];
    [query whereKey:@"user" equalTo:[PFUser currentUser]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        for (PFObject* obj in objects) {
            WHOTask* task = [[WHOTask alloc] initWithTask:obj[@"task"] withDeadline:obj[@"deadline"]];
            task.pf_id = obj.objectId;
            [self.tasks addObject:task];
        }
        [self sortTasks];
        [self.tableView reloadData];
        [self checkForExpiredTasks];
    }];
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
//    UIBarButtonItem* newTaskButton = [[UIBarButtonItem alloc] initWithTitle:@"add a task" style:UIBarButtonItemStylePlain target:self action:@selector(newTask:)];
    UIBarButtonItem* newTaskButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(newTask:)];
    self.navigationItem.rightBarButtonItem = newTaskButton;
//    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    [self.tableView setRowHeight:85.0];
    [self.tableView registerNib:[UINib nibWithNibName:@"WHOTaskCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"TaskCell"];
    
    //set timer to check if any tasks expire every 60 seconds
    [NSTimer scheduledTimerWithTimeInterval:60.0 target:self selector:@selector(checkForExpiredTasks) userInfo:nil repeats:YES];
}

- (void)newTask:(id)sender {
    WHONewTaskFormViewController* form = [[WHONewTaskFormViewController alloc] init];
    form.delegate = self;
    [self.navigationController pushViewController:form animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)receivedNewTask:(NSString *)task withDeadline:(NSString *)deadline {
    WHOTask* newTask = [[WHOTask alloc] initWithTask:task withDeadline:deadline];
    PFObject* pf = [PFObject objectWithClassName:@"Task"];
//    [pf setObject:task forKey:@"task"];
//    [pf setObject:deadline forKey:@"deadline"];
    pf[@"task"] = task;
    pf[@"deadline"] = deadline;
    pf[@"user"] = [PFUser currentUser];
    [pf saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded && !error) {
            [pf refreshInBackgroundWithBlock:^(PFObject *object, NSError *error) {
                //get the object ID from Parse
            }];
            newTask.pf_id = pf.objectId;
        }
    }];
    [self.tasks addObject:newTask];
    [self sortTasks];
    [self.tableView reloadData];
}

- (void)receivedEdittedTask:(NSString *)task withIndexPath:(NSIndexPath *)indexPath {
//    WHOTaskCell* cell = (WHOTaskCell* ) [self.tableView cellForRowAtIndexPath:indexPath];
    WHOTask* taskObject = [self.tasks objectAtIndex:indexPath.row];
    PFQuery* query = [PFQuery queryWithClassName:@"Task"];
    [query getObjectInBackgroundWithId:taskObject.pf_id block:^(PFObject *object, NSError *error) {
        object[@"task"] = task;
        [object saveInBackground];
    }];
//    cell.taskLabel.text = task;
    taskObject.task = task;
    [self.tableView reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    NSLog(@"selected cell");
    WHOEditTaskFormViewController* form = [[WHOEditTaskFormViewController alloc] init];
    form.delegate = self;
    form.indexPath = indexPath;
    [self.navigationController pushViewController:form animated:YES];
}

- (void)sortTasks {
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat: @"eee',' M/d/yy 'at' h:mm a"];
    [self.tasks sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSDate* date1 = [formatter dateFromString:((WHOTask* )obj1).deadline];
        NSDate* date2 = [formatter dateFromString:((WHOTask* )obj2).deadline];
        return [date1 compare:date2];
    }];
}

- (void)checkForExpiredTasks {
    NSLog(@"Checking for expired tasks");
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat: @"eee',' M/d/yy 'at' h:mm a"];
    for (int i = 0; i < [self.tasks count]; i++) {
        WHOTask* currTask = [self.tasks objectAtIndex:i];
        NSDate* currTaskDeadlineDate = [formatter dateFromString:currTask.deadline];
        if ([currTaskDeadlineDate timeIntervalSinceNow] < 0.0) {
            [self postFailureOfTask: currTask];
            PFQuery* query = [PFQuery queryWithClassName:@"Task"];
            [query getObjectInBackgroundWithId:currTask.pf_id block:^(PFObject *object, NSError *error) {
                [object deleteInBackground];
            }];
            [self.tasks removeObjectAtIndex:i];
            i--;
        }
        else {
            //break because the list is sorted
            break;
        }
    }
    [self.tableView reloadData];
}

- (void)postFailureOfTask:(WHOTask *) task {
    NSLog(@"Posting failure to Facebook");
    NSString* facebookPost = [NSString stringWithFormat:@"Let it be known that on this day I have failed to complete the most important task of %@", task.task];
    [FBRequestConnection startForPostStatusUpdate:facebookPost completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            // Status update posted successfully to Facebook
//            NSLog([NSString stringWithFormat:@"result: %@", result]);
        } else {
            // An error occurred, we need to handle the error
            // See: https://developers.facebook.com/docs/ios/errors
//            NSLog([NSString stringWithFormat:@"%@", error.description]);
        }
    }];
}

#pragma mark - SWTableViewCell stuff

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    switch (index) {
        case 0: {
            //did it
            NSIndexPath* cellIndexPath = [self.tableView indexPathForCell:cell];
            WHOTask* task = [self.tasks objectAtIndex:cellIndexPath.row];
            PFQuery* query = [PFQuery queryWithClassName:@"Task"];
            [query getObjectInBackgroundWithId:task.pf_id block:^(PFObject *object, NSError *error) {
                [object deleteInBackground];
            }];
            [self.tasks removeObjectAtIndex:cellIndexPath.row];
            [self.tableView deleteRowsAtIndexPaths:@[cellIndexPath] withRowAnimation:UITableViewRowAnimationRight];
            break;
        }
    }
}

#pragma mark - Table view data source
/*
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 0;
}
*/

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.tasks.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WHOTaskCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TaskCell"];
//    if (!cell) {
//        cell = [[WHOTaskCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TaskCell"];
//    }
    
    NSMutableArray* rightUtilityButtons = [NSMutableArray new];
//    [rightUtilityButtons sw_addUtilityButtonWithColor:[UIColor colorWithRed:255.0/255.0 green:216.0/255.0 blue:191.0/255.0 alpha:1.0] title:@"Edit"];
    [rightUtilityButtons sw_addUtilityButtonWithColor:[UIColor colorWithRed:30.0/255.0 green:252.0/255.0 blue:152.0/255.0 alpha:1.0] title:@"Did it!"];
    cell.rightUtilityButtons = rightUtilityButtons;
    cell.containingTableView = self.tableView;
    cell.delegate = self;
    
    WHOTask* task = [self.tasks objectAtIndex:indexPath.row];
    cell.taskLabel.text = task.task;
    cell.deadlineLabel.text = task.deadline;
    [cell setCellHeight:cell.frame.size.height];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 85.0;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
