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
@property (nonatomic, strong) UIButton* loginButton2;
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
//    [PFUser logOut];
   
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
//    [self.loginButton addTarget:self action:@selector(lightenOnTouch:) forControlEvents:UIControlEventTouchDown|UIControlEventTouchDragEnter];
//    [self.loginButton addTarget:self action:@selector(darkenOnRelease:) forControlEvents:UIControlEventTouchUpInside|UIControlEventTouchDragExit];
    [self.loginButton addTarget:self action:@selector(selectOtherButton) forControlEvents:UIControlEventTouchDown];
    [self.loginButton addTarget:self action:@selector(highlightOtherButton) forControlEvents:UIControlEventTouchDragEnter];
    [self.loginButton addTarget:self action:@selector(unselectOtherButton) forControlEvents:UIControlEventTouchDragExit|UIControlEventTouchUpInside];
    self.loginButton.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.loginButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.loginButton setTitle:@"Stop procrastinating\nand" forState:UIControlStateNormal];
    [self.loginButton setTitleColor:[UIColor colorWithWhite:1.0 alpha:0.85] forState:UIControlStateNormal];
    self.loginButton.titleLabel.font = [UIFont fontWithName:@"Superclarendon-Black" size:24.0];
    
    //shadow stuff
    // Constants
//    static const CGFloat kHPTTitleLabelShadowOffsetWidth = 0;
//    static const CGFloat kHPTTitleLabelShadowOffsetHeight = 10;
//    static const CGFloat kHPTTitleLabelShadowRadius = 8.0;
//    static const CGFloat kHPTTitleLabelShadowOpacity = 0.85;
    
//    self.loginButton.layer.shadowColor = [UIColor darkGrayColor].CGColor;
//    self.loginButton.layer.shadowOffset = CGSizeMake(kHPTTitleLabelShadowOffsetWidth,
//                                                    kHPTTitleLabelShadowOffsetHeight);
//    self.loginButton.layer.shadowRadius = kHPTTitleLabelShadowRadius;
//    self.loginButton.layer.shadowOpacity = kHPTTitleLabelShadowOpacity;
    
//    self.loginButton.frame = (CGRect) {
//        .origin = CGPointZero,
//        .size = { .width = 290.0, .height = 200.0 }
//    };
    [self.loginButton sizeToFit];
    [self.loginButton setCenter:(CGPoint) {
        .x = CGRectGetMidX(screenRect),
        .y = CGRectGetMidY(screenRect)-30
    }];
    
    self.loginButton2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.loginButton2 addTarget:self action:@selector(loginButtonHandler:) forControlEvents:UIControlEventTouchUpInside];
//    [self.loginButton addTarget:self action:@selector(lightenOnTouch:) forControlEvents:UIControlEventTouchDown|UIControlEventTouchDragEnter];
//    [self.loginButton addTarget:self action:@selector(darkenOnRelease:) forControlEvents:UIControlEventTouchUpInside|UIControlEventTouchDragExit];
    [self.loginButton2 addTarget:self action:@selector(selectOtherButton2) forControlEvents:UIControlEventTouchDown];
    [self.loginButton2 addTarget:self action:@selector(highlightOtherButton2) forControlEvents:UIControlEventTouchDragEnter];
    [self.loginButton2 addTarget:self action:@selector(unselectOtherButton2) forControlEvents:UIControlEventTouchDragExit|UIControlEventTouchUpInside];
    self.loginButton2.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.loginButton2.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.loginButton2 setTitle:@"Do It" forState:UIControlStateNormal];
    [self.loginButton2 setTitleColor:[UIColor colorWithWhite:1.0 alpha:0.85] forState:UIControlStateNormal];
    self.loginButton2.titleLabel.font = [UIFont fontWithName:@"Superclarendon-BlackItalic" size:40.0];
    [self.loginButton2 sizeToFit];
    [self.loginButton2 setCenter:(CGPoint) {
        .x = CGRectGetMidX(screenRect),
        .y = CGRectGetMaxY(self.loginButton.frame) + (self.loginButton2.frame.size.height/3)
    }];
    
    [self.view addSubview:self.loginButton];
    [self.view addSubview:self.loginButton2];
}

- (IBAction)loginButtonHandler:(id)sender {
    // Set permissions required from the facebook user account
//    NSArray *permissionsArray = @[ @"user_about_me", @"user_relationships", @"user_birthday", @"user_location"];
    NSArray* permissionsArray = @[@"publish_actions"];
    
    // Login PFUser using facebook
    [PFFacebookUtils logInWithPermissions:permissionsArray block:^(PFUser *user, NSError *error) {
        if (!user) {
            if (!error) {
                NSLog(@"The user cancelled the Facebook login.");
//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Log In Error" message:@"The user cancelled the Facebook login." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Dismiss", nil];
//                [alert show];
            } else {
                NSLog(@"An error occurred: %@", error);
//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Log In Error" message:[error description] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Dismiss", nil];
//                [alert show];
            }
        } else if (user.isNew) {
            NSLog(@"User with facebook signed up and logged in!");
            self.loginButton.hidden = YES;
            self.loginButton2.hidden = YES;
            UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:[[WHOTaskTableViewController alloc] initWithStyle:UITableViewStylePlain]];
            [self presentViewController:nav animated:NO completion:nil];
        } else {
            NSLog(@"User with facebook logged in!");
            self.loginButton.hidden = YES;
            self.loginButton2.hidden = YES;
            UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:[[WHOTaskTableViewController alloc] initWithStyle:UITableViewStylePlain]];
            [self presentViewController:nav animated:NO completion:nil];
        }
    }];
}

- (void) selectOtherButton {
    NSLog(@"selecting button 2");
    [self.loginButton2 setAlpha:.2];
}

- (void)unselectOtherButton {
    NSLog(@"unselecting button 2");
    [UIView animateWithDuration:.3 animations:^{
        [self.loginButton2 setAlpha:1.0];
    }];
}

- (void)highlightOtherButton {
    NSLog(@"highlighting button 2");
    [UIView animateWithDuration:.3 animations:^{
        [self.loginButton2 setAlpha:.2];
    }];
}

- (void) selectOtherButton2 {
    NSLog(@"selecting button 1");
    [self.loginButton setAlpha:.2];
}

- (void)unselectOtherButton2 {
    NSLog(@"unselecting button 1");
    [UIView animateWithDuration:.3 animations:^{
        [self.loginButton setAlpha:1.0];
    }];
}

- (void)highlightOtherButton2 {
    NSLog(@"highlighting button 1");
    [UIView animateWithDuration:.3 animations:^{
        [self.loginButton setAlpha:.2];
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

/*
- (void) lightenOnTouch:(id)sender {
    sender = (UIButton *) sender;
    CGFloat R,G,B,a;
    [[sender backgroundColor] getRed:&R green:&G blue:&B alpha:&a];
    [UIView animateWithDuration:0.125 animations:^{
        [sender setBackgroundColor:[UIColor colorWithRed:(R*255+30)/255 green:(G*255+30)/255 blue:(B*255+30)/255 alpha:a]];
    }];
}

- (void) darkenOnRelease:(id)sender {
    sender = (UIButton *) sender;
    CGFloat R,G,B,a;
    [[sender backgroundColor] getRed:&R green:&G blue:&B alpha:&a];
    [UIView animateWithDuration:0.125 animations:^{
        [sender setBackgroundColor:[UIColor colorWithRed:(R*255-30)/255 green:(G*255-30)/255 blue:(B*255-30)/255 alpha:a]];
    }];
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
