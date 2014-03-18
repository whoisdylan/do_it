//
//  WHOTask.h
//  do_it
//
//  Created by dylan on 3/17/14.
//  Copyright (c) 2014 whoisdylan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WHOTask : NSObject
-(instancetype) initWithTask:(NSString *)task withDeadline:(NSString *)deadline;
@property (nonatomic, strong) NSString *task;
@property (nonatomic, strong) NSString *deadline;
@end
