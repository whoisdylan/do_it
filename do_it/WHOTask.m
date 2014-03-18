//
//  WHOTask.m
//  do_it
//
//  Created by dylan on 3/17/14.
//  Copyright (c) 2014 whoisdylan. All rights reserved.
//

#import "WHOTask.h"

@implementation WHOTask

-(instancetype) initWithTask:(NSString *)task withDeadline:(NSString *)deadline {
    if (self = [super init]) {
        self.task = task;
        self.deadline = deadline;
    }
    return self;
}

@end
