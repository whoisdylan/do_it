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
@property (nonatomic, strong) UILabel* titleLabel;
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
    [PFUser logOut];
   
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
    
    //add app title
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.titleLabel.text = @"Do It";
//    self.titleLabel.font = [UIFont systemFontOfSize:50.0];
    self.titleLabel.font = [UIFont fontWithName:@"Superclarendon-Regular" size:72.0];
    self.titleLabel.textColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:.75];
    // Constants
    // The width of the shadow offset of our label.
    static const CGFloat kHPTTitleLabelShadowOffsetWidth = 1;
    // The height of the shadow offset of our label.
    static const CGFloat kHPTTitleLabelShadowOffsetHeight = 1;
    // The shadow radius of our label.
    static const CGFloat kHPTTitleLabelShadowRadius = 5.0;
    // The shadow opacity of our label.
    static const CGFloat kHPTTitleLabelShadowOpacity = 1.0;
    // The offset between the top of the screen, and our main label.
    
    // Handle the label's shadow.
    self.titleLabel.layer.shadowColor = [UIColor darkGrayColor].CGColor;
    self.titleLabel.layer.shadowOffset = CGSizeMake(kHPTTitleLabelShadowOffsetWidth,
                                                    kHPTTitleLabelShadowOffsetHeight);
    self.titleLabel.layer.shadowRadius = kHPTTitleLabelShadowRadius;
    self.titleLabel.layer.shadowOpacity = kHPTTitleLabelShadowOpacity;
    
    [self.titleLabel sizeToFit];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    static const CGFloat kHPTLabelTopOffset = 100.0;
    self.titleLabel.center = (CGPoint) {
        .x = CGRectGetMidX(screenRect),
        .y = kHPTLabelTopOffset
    };
    [self.view addSubview:self.titleLabel];

    
    //make custom button for parse and facebook login
    self.loginButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.loginButton addTarget:self action:@selector(loginButtonHandler:) forControlEvents:UIControlEventTouchUpInside];
    [self.loginButton addTarget:self action:@selector(lightenOnTouch:) forControlEvents:UIControlEventTouchDown|UIControlEventTouchDragEnter];
    [self.loginButton addTarget:self action:@selector(darkenOnRelease:) forControlEvents:UIControlEventTouchUpInside|UIControlEventTouchDragExit];
    [self.loginButton setTitle:@"Stop procrastinating" forState:UIControlStateNormal];
    [self.loginButton setTitleColor:[UIColor colorWithWhite:1.0 alpha:0.85] forState:UIControlStateNormal];
    [self.loginButton setBackgroundColor:[UIColor colorWithRed:68.0/255.0 green:140.0/255.0 blue:203.0/255.0 alpha:0.85]];
    self.loginButton.layer.cornerRadius = 4.0;
//    self.loginButton.titleLabel.font = [UIFont systemFontOfSize:24.0];
    self.loginButton.titleLabel.font = [UIFont fontWithName:@"Superclarendon-Regular" size:20.0];
    self.loginButton.frame = (CGRect) {
        .origin = CGPointZero,
        .size = { .width = 290.0, .height = 44.0 }
    };
//    [self.loginButton sizeToFit];
    [self.loginButton setCenter:(CGPoint) {
        .x = CGRectGetMidX(screenRect),
        .y = CGRectGetMaxY(screenRect) - 150
    }];
    [self.view addSubview:self.loginButton];
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
            UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:[[WHOTaskTableViewController alloc] initWithStyle:UITableViewStylePlain]];
            [self presentViewController:nav animated:NO completion:nil];
        } else {
            NSLog(@"User with facebook logged in!");
            self.loginButton.hidden = YES;
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
