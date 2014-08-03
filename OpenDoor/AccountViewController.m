//
//  AccountViewController.m
//  OpenDoor
//
//  Created by Junaid Shabbir on 8/1/14.
//  Copyright (c) 2014 Junaid's. All rights reserved.
//

#import "AccountViewController.h"
#import "AppDelegate.h"
#import "User.h"


@interface AccountViewController ()

@end

@implementation AccountViewController
User *user;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        user = [ODPersistent getObjectForKey:KEY_USER];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.scrollView setContentSize: CGSizeMake(self.view.frame.size.width, self.view.frame.size.height)];
    if(user != nil) {
        [self loadUserData];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onClickLogout:(id)sender {
    [AppDelegate appDelegate].isLogin = false;
    [[AppDelegate appDelegate] switchScreen];
}

- (void) loadUserData {
    self.lblMobileNo.text = user.mobileNo;
    self.lblFirstName.text = user.firstName;
    self.lblLastName.text = user.lastName;
    self.lblAccountType.text = user.accountType;
    self.lblAccountId.text = user.accountId;
    self.lblWork.text = user.work;
    self.lblHome.text = user.home;
    self.lblOther.text = user.other;
    
    self.lblPendingPayment.text = @"Required Payment class, where each user have payment details";
    self.lblLifeTimeEarning.text = @"Required Payment class, where each user have payment details";
}


@end
