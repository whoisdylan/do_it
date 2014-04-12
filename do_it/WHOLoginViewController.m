//
//  WHOLoginViewController.m
//  do_it
//
//  Created by dylan on 4/10/14.
//  Copyright (c) 2014 whoisdylan. All rights reserved.
//

#import "WHOLoginViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import "WHOTaskTableViewController.h"

@interface WHOLoginViewController () <FBLoginViewDelegate>

@end

@implementation WHOLoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    
    //make and place login view
    FBLoginView* loginView = [[FBLoginView alloc] initWithPublishPermissions:@[@"publish_actions"] defaultAudience:FBSessionDefaultAudienceFriends];
    loginView.delegate = self;
    [loginView setCenter:(CGPoint) {
        .x = CGRectGetMidX(screenRect),
        .y = CGRectGetMaxY(screenRect) - 100
    }];
    [self.view addSubview:loginView];
    loginView.hidden = YES;
}

- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView {
    loginView.hidden = NO;
    
}

- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView {
        UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:[[WHOTaskTableViewController alloc] initWithStyle:UITableViewStylePlain]];
        [self presentViewController:nav animated:NO completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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