//
//  WHOTaskTableViewController.m
//  do_it
//
//  Created by dylan on 3/17/14.
//  Copyright (c) 2014 whoisdylan. All rights reserved.
//

#import "WHOTaskTableViewController.h"
#import "WHONewTaskFormViewController.h"
#import "WHOTask.h"
#import "WHOTaskCell.h"

@interface WHOTaskTableViewController () <WHOTaskProtocol, SWTableViewCellDelegate>

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
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    UIBarButtonItem* newTaskButton = [[UIBarButtonItem alloc] initWithTitle:@"New task" style:UIBarButtonItemStylePlain target:self action:@selector(newTask:)];
    self.navigationItem.rightBarButtonItem = newTaskButton;
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    [self.tableView registerNib:[UINib nibWithNibName:@"WHOTaskCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"TaskCell"];
    [self.tableView reloadData];
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
    [self.tasks addObject:newTask];
    [self.tableView reloadData];
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    switch (index) {
        case 0: {
            //did it
            NSIndexPath* cellIndexPath = [self.tableView indexPathForCell:cell];
            [self.tasks removeObjectAtIndex:cellIndexPath.row];
            [self.tableView deleteRowsAtIndexPaths:@[cellIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
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
    if (!cell) {
        cell = [[WHOTaskCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TaskCell"];
    }
    
    NSMutableArray* rightUtilityButtons = [NSMutableArray new];
    [rightUtilityButtons sw_addUtilityButtonWithColor:[UIColor colorWithRed:30.0/255.0 green:252.0/255.0 blue:152.0/255.0 alpha:1.0] title:@"Did it!"];
    cell.rightUtilityButtons = rightUtilityButtons;
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
