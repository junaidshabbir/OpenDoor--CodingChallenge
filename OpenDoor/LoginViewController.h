//
//  LoginViewController.h
//  OpenDoor
//
//  Created by Junaid Shabbir on 7/31/14.
//  Copyright (c) 2014 Junaid's. All rights reserved.
//

@interface LoginViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *mobileNo;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator;

- (IBAction)onClickLogin:(id)sender;

@end
