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
#import <Parse/Parse.h>

@interface WHOLoginViewController () <FBLoginViewDelegate>

@property (nonatomic, strong) UIButton* loginButton;
@property (nonatomic) BOOL isUserLoggedIn;

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


- (void)viewDidAppear:(BOOL)animated {
    if (self.isUserLoggedIn) {
        NSLog(@"User already logged in to Facebook and Parse, skipping log in screen");
        UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:[[WHOTaskTableViewController alloc] initWithStyle:UITableViewStylePlain]];
        [self presentViewController:nav animated:NO completion:nil];
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
   
    if ([PFUser currentUser] && [PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]) {
        self.isUserLoggedIn = YES;
        return;
    }
    else {
        self.isUserLoggedIn = NO;
    }
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    
    //make and place login view with facebook button
//    FBLoginView* loginView = [[FBLoginView alloc] initWithPublishPermissions:@[@"publish_actions"] defaultAudience:FBSessionDefaultAudienceFriends];
//    loginView.delegate = self;
//    [loginView setCenter:(CGPoint) {
//        .x = CGRectGetMidX(screenRect),
//        .y = CGRectGetMaxY(screenRect) - 100
//    }];
//    [self.view addSubview:loginView];
//    loginView.hidden = YES;
    
    //make custom button for parse and facebook login
    self.loginButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.loginButton addTarget:self action:@selector(loginButtonHandler:) forControlEvents:UIControlEventTouchUpInside];
    [self.loginButton setTitle:@"Log in to Do It" forState:UIControlStateNormal];
    self.loginButton.frame = CGRectMake(80.0, 210.0, 160.0, 40.0);
    [self.loginButton setCenter:(CGPoint) {
        .x = CGRectGetMidX(screenRect),
        .y = CGRectGetMaxY(screenRect) - 150
    }];
    [self.view addSubview:self.loginButton];
}

- (IBAction)loginButtonHandler:(id)sender {
    // Set permissions required from the facebook user account
//    NSArray *permissionsArray = @[ @"user_about_me", @"user_relationships", @"user_birthday", @"user_location"];
    self.loginButton.hidden = YES;
    NSArray* permissionsArray = @[@"publish_actions"];
    
    // Login PFUser using facebook
    [PFFacebookUtils logInWithPermissions:permissionsArray block:^(PFUser *user, NSError *error) {
        if (!user) {
            if (!error) {
                NSLog(@"The user cancelled the Facebook login.");
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Log In Error" message:@"The user cancelled the Facebook login." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Dismiss", nil];
                [alert show];
            } else {
                NSLog(@"An error occurred: %@", error);
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Log In Error" message:[error description] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Dismiss", nil];
                [alert show];
            }
        } else if (user.isNew) {
            NSLog(@"User with facebook signed up and logged in!");
            UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:[[WHOTaskTableViewController alloc] initWithStyle:UITableViewStylePlain]];
            [self presentViewController:nav animated:NO completion:nil];
        } else {
            NSLog(@"User with facebook logged in!");
            UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:[[WHOTaskTableViewController alloc] initWithStyle:UITableViewStylePlain]];
            [self presentViewController:nav animated:NO completion:nil];
        }
    }];
}

/*
- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView {
    loginView.hidden = NO;
    
}

- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView {
    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:[[WHOTaskTableViewController alloc] initWithStyle:UITableViewStylePlain]];
    [self presentViewController:nav animated:NO completion:nil];
}
*/

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
