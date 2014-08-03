//
//  AccountViewController.h
//  OpenDoor
//
//  Created by Junaid Shabbir on 8/1/14.
//  Copyright (c) 2014 Junaid's. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AccountViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *lblMobileNo;
@property (weak, nonatomic) IBOutlet UILabel *lblFirstName;
@property (weak, nonatomic) IBOutlet UILabel *lblLastName;
@property (weak, nonatomic) IBOutlet UILabel *lblAccountType;
@property (weak, nonatomic) IBOutlet UILabel *lblAccountId;
@property (weak, nonatomic) IBOutlet UILabel *lblPendingPayment;
@property (weak, nonatomic) IBOutlet UILabel *lblLifeTimeEarning;
@property (weak, nonatomic) IBOutlet UILabel *lblHome;
@property (weak, nonatomic) IBOutlet UILabel *lblWork;
@property (weak, nonatomic) IBOutlet UILabel *lblOther;

- (IBAction)onClickLogout:(id)sender;

@end
