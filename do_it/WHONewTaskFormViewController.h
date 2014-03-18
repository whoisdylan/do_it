//
//  WHONewTaskFormViewController.h
//  do_it
//
//  Created by dylan on 3/17/14.
//  Copyright (c) 2014 whoisdylan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WHOTaskProtocol <NSObject>
- (void)receivedNewTask:(NSString *)task withDeadline:(NSString *)deadline;
@end

@interface WHONewTaskFormViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *taskField;
- (IBAction)taskView:(id)sender;
@property (strong, nonatomic) IBOutlet UIDatePicker *taskDeadline;
@property (strong, nonatomic) id<WHOTaskProtocol> delegate;
@end
