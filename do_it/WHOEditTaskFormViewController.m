//
//  WHOEditTaskFormViewController.m
//  do_it
//
//  Created by dylan on 3/17/14.
//  Copyright (c) 2014 whoisdylan. All rights reserved.
//

#import "WHOEditTaskFormViewController.h"

@interface WHOEditTaskFormViewController ()
@end

@implementation WHOEditTaskFormViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UIBarButtonItem* submitButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(submit:)];
    self.navigationItem.rightBarButtonItem = submitButton;
    [self.taskField addTarget:self action:@selector(taskView:) forControlEvents:UIControlEventEditingDidEndOnExit];
}

- (void)submit:(id)sender {
    [self.delegate receivedEdittedTask:self.taskField.text withIndexPath:self.indexPath];
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
