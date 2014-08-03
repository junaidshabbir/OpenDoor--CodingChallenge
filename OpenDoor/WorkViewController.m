//
//  WorkViewController.m
//  OpenDoor
//
//  Created by Junaid Shabbir on 8/1/14.
//  Copyright (c) 2014 Junaid's. All rights reserved.
//

#import "WorkViewController.h"
#import <Parse/Parse.h>
#import "WorkCell.h"
#import "User.h"

@interface WorkViewController ()

@end

@implementation WorkViewController

int const TASK_CHUNK_LIMIT = 50;
int totalDataCount = 0;
int fetchedDataCount = 0;
UIView *footerLoadingView;
PFObject *selectedTask;
User *user;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        availableObjects = [[NSMutableArray alloc] init];
        reservedObjects = [[NSMutableArray alloc] init];
        user = [ODPersistent getObjectForKey:KEY_USER];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addTaskListView];
    [self initFooterView];
    [self checkIfAnyTaskStarted];
}

- (void) initTaskList {
    [self addTaskListView];
    [self fetchTasksCount];
    [self queryTaskObjects: 0];
}

- (void) addTaskListView {
    self.taskListView.hidden = false;
    [self.mainBodyView addSubview:self.taskListView];
    self.taskDetailView.hidden = true;
}

- (void) addTaskDetailView {
    self.taskDetailView.hidden = false;
    [self.mainBodyView addSubview:self.taskDetailView];
    self.taskListView.hidden = true;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) queryTaskObjects:(int) firstSkipCount {
    [self startLoading];
    PFQuery *query = [PFQuery queryWithClassName:CLASS_TASK];
    query.limit = TASK_CHUNK_LIMIT;
    query.skip = firstSkipCount;
    [query whereKey:KEY_IS_ACTIVE equalTo:@YES];
    [query whereKey:KEY_EXPIRY_DATE greaterThan:[NSDate date]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        [self stopLoading];
        if (!error) {
            for (PFObject *object in objects) {
                if([[object objectForKey:KEY_MODE] isEqual: TASK_AVAILABLE]) {
                    [availableObjects addObject:object];
                }
                else if([[object objectForKey:KEY_MODE] isEqual: TASK_RESERVED]) {
                    [reservedObjects addObject:object];
                }
            }
            fetchedDataCount += [objects count];
            [self.tableView reloadData];
        }
    }];
}

- (void) fetchTasksCount {
    PFQuery *query = [PFQuery queryWithClassName:CLASS_TASK];
    [query whereKey:KEY_IS_ACTIVE equalTo:@YES];
    [query whereKey:KEY_EXPIRY_DATE greaterThan:[NSDate date]];
    [query countObjectsInBackgroundWithBlock:^(int count, NSError *error) {
        if (!error) {
            totalDataCount = count;
        }
    }];
}

- (void) onSegmentValueChange:(id)sender {
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[self getVisibleArray] count];
}

- (NSMutableArray*) getVisibleArray {
    if (self.customSegment.selectedSegmentIndex == 0) {
        return availableObjects;
    }
    else {
        return reservedObjects;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PFObject *task = [[self getVisibleArray] objectAtIndex:indexPath.section];
    
    [[NSBundle mainBundle] loadNibNamed:@"WorkCell" owner:self options:nil];
    WorkCell *workCell = self.workCell;
    self.workCell = nil;
    
    workCell.lblTitle.text = [task objectForKey:KEY_TITLE];
    workCell.lblDesc.text = [task objectForKey:KEY_DESC];
    workCell.lblAddress.text = [task objectForKey:KEY_ADDRESS];
    
    return workCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    PFObject *task = [[self getVisibleArray] objectAtIndex:indexPath.section];
    [self showTaskDetails:task];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(self.customSegment.selectedSegmentIndex == 0 &&
       indexPath.section == [availableObjects count]-1 &&
       fetchedDataCount < totalDataCount) {
        [self startLoading];
        [self queryTaskObjects: fetchedDataCount];
    }
}

- (void) showTaskDetails: (PFObject *)task{
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd MMMM yyyy"];
    
    selectedTask = task;
    
    self.lblTitle.text = [task objectForKey:KEY_TITLE];
    self.lblEarn.text = [NSString stringWithFormat:@"%@ %@",[task objectForKey:KEY_EARN_CURRENCY],
                         [task objectForKey:KEY_EARN]];
    self.lblPostedOn.text = [dateFormat stringFromDate:task.createdAt];
    NSDate *expiryDate = [task objectForKey:KEY_EXPIRY_DATE];
    self.lblExpiresOn.text = [dateFormat stringFromDate:expiryDate];
    self.tvDesc.text = [NSString stringWithFormat:@"%@",[task objectForKey:KEY_DESC]];
    
    [self addTaskDetailView];
    
}

- (void) startLoading {
    self.tableView.tableFooterView = footerLoadingView;
    [(UIActivityIndicatorView *)[footerLoadingView viewWithTag:10] startAnimating];
}

- (void) stopLoading {
    self.tableView.tableFooterView = nil;
    [(UIActivityIndicatorView *)[footerLoadingView viewWithTag:10] stopAnimating];
}

- (void)initFooterView {
    footerLoadingView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 40.0)];
    UIActivityIndicatorView *actInd = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    actInd.tag = 10;
    actInd.frame = CGRectMake(150.0, 5.0, 20.0, 20.0);
    actInd.hidesWhenStopped = YES;
    [footerLoadingView addSubview:actInd];
    actInd = nil;
}

- (IBAction)onClickActionButton:(id)sender {
    UIButton *button = (UIButton *)sender;
    
    if([button.titleLabel.text isEqualToString:BUTTON_START]){
        if([[selectedTask objectForKey:KEY_MODE] isEqual: TASK_AVAILABLE]) {
            [self updateViewOnTaskStart];
            [self updateTask:selectedTask Mode: TASK_START];
        } else {
            [Util popupAlert:@"Task can't started as it is alredy Reseved."];
        }
    }
    else{
        [self updateViewOnTaskCompleted];
        [self updateTask:selectedTask Mode: TASK_AVAILABLE];
    }
}

- (void) updateViewOnTaskStart {
    [self.btnAction setTitle:BUTTON_COMPLETED forState:UIControlStateNormal];
    [self setTabBarEnabled:false];
}

- (void) updateViewOnTaskCompleted {
    [self.btnAction setTitle:BUTTON_START forState:UIControlStateNormal];
    [self setTabBarEnabled:true];
}

- (void) updateTask:(PFObject *)task Mode:(NSString *)mode {
    //Note: So far below is not a syncronized process. For multiple users, we should first retrived an updated object (using objectId) from CMS then checked it's availablity and then updated its mode to start.
    
    task[KEY_MODE] = mode;
    [task saveInBackground];
}

- (void) setTabBarEnabled:(BOOL) enabled {
    [[[[self.tabBarController tabBar]items]objectAtIndex:1]setEnabled:enabled];
    [[[[self.tabBarController tabBar]items]objectAtIndex:2]setEnabled:enabled];
}

- (IBAction)onClickBack:(id)sender {
    if([self.btnAction.titleLabel.text isEqualToString:BUTTON_START]) {
        if(totalDataCount == 0) {
            [self initTaskList];
        } else {
            [self addTaskListView];
        }
    } else {
        [Util popupAlert:@"Please complete your task first."];
    }
}

- (void) checkIfAnyTaskStarted {
    PFQuery *query = [PFQuery queryWithClassName:CLASS_TASK];
    query.limit = 1;
    [query whereKey:KEY_MODE equalTo:TASK_START];
    [self startLoading];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        [self stopLoading];
        if (!error) {
            if(objects.count > 0) {
                PFObject *task = objects[0];
                [self showTaskDetails:task];
                [self updateViewOnTaskStart];
            } else {
                [self initTaskList];
            }
        }
    }];
}

@end
