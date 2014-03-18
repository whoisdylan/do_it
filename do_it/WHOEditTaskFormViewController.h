//
//  WHOEditTaskFormViewController.h
//  do_it
//
//  Created by dylan on 3/17/14.
//  Copyright (c) 2014 whoisdylan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WHOEditTaskProtocol <NSObject>
- (void)receivedEdittedTask:(NSString *)task withIndexPath:(NSIndexPath *)indexPath;
@end

@interface WHOEditTaskFormViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *taskField;
- (IBAction)taskView:(id)sender;
@property (strong, nonatomic) id<WHOEditTaskProtocol> delegate;
@property (strong, nonatomic) NSIndexPath* indexPath;
@end
