//
//  WorkViewController.h
//  OpenDoor
//
//  Created by Junaid Shabbir on 8/1/14.
//  Copyright (c) 2014 Junaid's. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WorkCell;
@interface WorkViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    NSMutableArray *availableObjects;
    NSMutableArray *reservedObjects;
}

@property (retain, nonatomic) IBOutlet UISegmentedControl *customSegment;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet WorkCell *workCell;
@property (strong, nonatomic) IBOutlet UIView *mainBodyView;
@property (strong, nonatomic) IBOutlet UIView *taskListView;
@property (strong, nonatomic) IBOutlet UIView *taskDetailView;

@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblEarn;
@property (weak, nonatomic) IBOutlet UILabel *lblPostedOn;
@property (weak, nonatomic) IBOutlet UILabel *lblExpiresOn;
@property (weak, nonatomic) IBOutlet UIButton *btnAction;
@property (weak, nonatomic) IBOutlet UITextView *tvDesc;

- (IBAction)onClickActionButton:(id)sender;
- (IBAction)onSegmentValueChange:(id)sender;
- (IBAction)onClickBack:(id)sender;


#define KEY_TITLE           @"title"
#define KEY_MODE            @"mode"
#define KEY_DESC            @"desc"
#define KEY_ADDRESS         @"address"
#define KEY_IS_ACTIVE       @"is_active"
#define KEY_EARN            @"earn"
#define KEY_EARN_CURRENCY   @"earnCurrency"
#define KEY_EXPIRY_DATE     @"expiryDate"

#define CLASS_TASK          @"Task"
#define TASK_AVAILABLE      @"AVAILABLE"
#define TASK_RESERVED       @"RESERVED"
#define TASK_START          @"START"

#define BUTTON_START        @"Start"
#define BUTTON_COMPLETED    @"Completed"

@end
