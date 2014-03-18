//
//  WHONewTaskFormViewController.m
//  do_it
//
//  Created by dylan on 3/17/14.
//  Copyright (c) 2014 whoisdylan. All rights reserved.
//

#import "WHONewTaskFormViewController.h"

@interface WHONewTaskFormViewController ()
@property (nonatomic, strong) NSDateFormatter* formatter;
@property (nonatomic, strong) NSString* deadline;
@end

@implementation WHONewTaskFormViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.formatter = [[NSDateFormatter alloc] init];
        [self.formatter setDateFormat: @"eee',' M/d/yy 'at' h:mm a"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.taskDeadline setDate:[NSDate dateWithTimeIntervalSinceNow:86400]];
    UIBarButtonItem* submitButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(submit:)];
    self.navigationItem.rightBarButtonItem = submitButton;
    [self.taskField addTarget:self action:@selector(taskView:) forControlEvents:UIControlEventEditingDidEndOnExit];
}

- (void)submit:(id)sender {
    self.deadline = [self.formatter stringFromDate:self.taskDeadline.date];
    [self.delegate receivedNewTask:self.taskField.text withDeadline:self.deadline];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)taskView:(id)sender {
    [self.taskField resignFirstResponder];
}
@end
