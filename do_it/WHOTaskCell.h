//
//  WHOTaskCell.h
//  do_it
//
//  Created by dylan on 3/17/14.
//  Copyright (c) 2014 whoisdylan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SWTableViewCell.h>

@interface WHOTaskCell : SWTableViewCell
@property (strong, nonatomic) IBOutlet UILabel *taskLabel;
@property (strong, nonatomic) IBOutlet UILabel *deadlineLabel;

@end
