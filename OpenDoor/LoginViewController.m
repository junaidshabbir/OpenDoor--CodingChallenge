//
//  LoginViewController.m
//  OpenDoor
//
//  Created by Junaid Shabbir on 7/31/14.
//  Copyright (c) 2014 Junaid's. All rights reserved.
//

#import "LoginViewController.h"
#import "AppDelegate.h"
#import <Parse/Parse.h>

@implementation LoginViewController

@synthesize indicator;
@synthesize loginButton;

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)onClickLogin:(id)sender {
    [self startLoginProcess];
    [PFUser logInWithUsernameInBackground:self.mobileNo.text password:self.password.text
                                    block:^(PFUser *user, NSError *error) {
                                        [self endLoginProcess];
                                        if (user) {
                                            // Do stuff after successful login.
                                            [AppDelegate appDelegate].isLogin = true;
                                            [[AppDelegate appDelegate] switchScreen];
                                        } else {
                                            // The login failed. Check error to see why.
                                            [Util popupAlert:@"The login failed."];
                                        }
                                    }];
}

- (void) startLoginProcess {
    [indicator startAnimating];
    [loginButton setEnabled:false];
}

- (void) endLoginProcess {
    [indicator stopAnimating];
    [loginButton setEnabled:true];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return true;
}

@end
