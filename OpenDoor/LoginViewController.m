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
#import "User.h"

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
                                            [self saveLoginUser:user];
                                            [AppDelegate appDelegate].isLogin = true;
                                            [[AppDelegate appDelegate] switchScreen];
                                        } else {
                                            // The login failed. Check error to see why.
                                            [Util popupAlert:@"The login failed."];
                                        }
                                    }];
    
}

- (void) saveLoginUser:(PFUser*) pfUser {
    User *user = [[User alloc] init];

    user.objectId = pfUser.objectId;
    user.mobileNo = [pfUser objectForKey:@"username"];
    user.firstName = [pfUser objectForKey:@"firstName"];
    user.lastName = [pfUser objectForKey:@"lastName"];
    user.accountType = [pfUser objectForKey:@"accountType"];
    user.accountId = [pfUser objectForKey:@"accountId"];
    user.home = [pfUser objectForKey:@"home"];
    user.work = [pfUser objectForKey:@"work"];
    user.other = [pfUser objectForKey:@"other"];
    
    [ODPersistent saveObject:user forKey:KEY_USER];
}

- (void) startLoginProcess {
    [indicator startAnimating];
    [loginButton setEnabled:false];
    
//    [Util putNewDummyData];    
}

- (void) endLoginProcess {
    [indicator stopAnimating];
    [loginButton setEnabled:true];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return true;
}

- (void)saveCustomObject:(User *)object key:(NSString *)key {
    NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:object];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:encodedObject forKey:key];
    [defaults synchronize];
}

- (User *)loadCustomObjectWithKey:(NSString *)key {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *encodedObject = [defaults objectForKey:key];
    User *object = [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
    return object;
}

@end
