//
//  WHOTaskCell.m
//  do_it
//
//  Created by dylan on 3/17/14.
//  Copyright (c) 2014 whoisdylan. All rights reserved.
//

#import "WHOTaskCell.h"
//@interface WHOTaskCell () <UITextFieldDelegate>
//@end
@implementation WHOTaskCell

//- (void)awakeFromNib
//{
//    // Initialization code
//}

//- (id)initWithCoder:(NSCoder *)aDecoder {
//    self = [super initWithCoder:aDecoder];
//    if (self) {
//        self.taskField.delegate = self;
//    }
//    return self;
//}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    NSLog(@"creating new cell");
    if (self) {
        NSLog(@"hello");
//        self.taskField.delegate = self;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//#pragma mark - UITextFieldDelegate
//-(BOOL)textFieldShouldReturn:(UITextField *)textField {
//    // close the keyboard on enter
//    NSLog(@"TRYING TO CLOSE CELL KEYBOARD");
//    [textField resignFirstResponder];
//    return NO;
//}

//-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
//    // disable editing of completed to-do items
//    return !self.todoItem.completed;
//}

//-(void)textFieldDidEndEditing:(UITextField *)textField {
//    // set the model object state when an edit has complete
//    self.taskField.text = textField.text;
//}

@end
