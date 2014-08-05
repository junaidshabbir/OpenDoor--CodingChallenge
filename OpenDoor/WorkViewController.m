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
BOOL isAnyTaskModified;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        availableObjects = [[NSMutableArray alloc] init];
        reservedObjects = [[NSMutableArray alloc] init];
        completedObjects = [[NSMutableArray alloc] init];
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
    isAnyTaskModified = false;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) queryTaskObjects:(int) firstSkipCount {
    [self startLoading];

    PFQuery *query = [self getCombineQueryForAvailableAndReservedTasks];
    query.limit = TASK_CHUNK_LIMIT;
    query.skip = firstSkipCount;
    [query whereKey:KEY_IS_ACTIVE equalTo:@YES];
    [query whereKey:KEY_EXPIRY_DATE greaterThan:[NSDate date]];
    [query orderByDescending:@"updatedAt"];
    
    if(firstSkipCount == 0) {
        [availableObjects removeAllObjects];
        [reservedObjects removeAllObjects];
        [self.tableView reloadData];
        fetchedDataCount = 0;
    }
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
            if([availableObjects count] == 0) { // Tasks are not available, so we have to show Complete tasks if any.
                [self.lblTaskNotAvailable setHidden:false];
                [self queryCompletedTaskObjects];
            }
            else if([[self.customSegment titleForSegmentAtIndex:0] isEqual: SEGMENT_COMPLETED]) {
                [self.lblTaskNotAvailable setHidden:true];
                [self.customSegment setTitle:SEGMENT_AVAILABLE forSegmentAtIndex:0];            
            }
        }
    }];
}

- (void) queryCompletedTaskObjects {
    [self startLoading];
    
    PFQuery *query = [PFQuery queryWithClassName:CLASS_TASK];
    [query whereKey:KEY_IS_ACTIVE equalTo:@YES];
    [query whereKey:KEY_MODE equalTo:TASK_COMPLETED];
    [query whereKey:KEY_WORKER_ID equalTo:user.objectId];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        [self stopLoading];
        if (!error && [objects count] > 0) {
            completedObjects = [[NSMutableArray alloc]initWithArray:objects];
            [self.customSegment setTitle:SEGMENT_COMPLETED forSegmentAtIndex:0];
            [self.tableView reloadData];
        }
    }];
}

- (void) fetchTasksCount {
    PFQuery *query = [self getCombineQueryForAvailableAndReservedTasks];
    [query whereKey:KEY_IS_ACTIVE equalTo:@YES];
    [query whereKey:KEY_EXPIRY_DATE greaterThan:[NSDate date]];
    [query countObjectsInBackgroundWithBlock:^(int count, NSError *error) {
        if (!error) {
            totalDataCount = count;
        }
    }];
}

- (PFQuery *) getCombineQueryForAvailableAndReservedTasks {
    PFQuery *available = [PFQuery queryWithClassName:CLASS_TASK];
    [available whereKey:KEY_MODE equalTo:TASK_AVAILABLE];
    
    PFQuery *reserved = [PFQuery queryWithClassName:CLASS_TASK];
    [reserved whereKey:KEY_MODE equalTo:TASK_RESERVED];
    
    return [PFQuery orQueryWithSubqueries:@[available,reserved]];
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
        if([availableObjects count] > 0) {
            return availableObjects;
        } else {
            return completedObjects;
        }
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
            [self updateTask:selectedTask Mode: TASK_START WorkerId:user.objectId];
        } else {
            NSString *msg = [NSString stringWithFormat:@"Task is not available to start. It's already %@",[selectedTask objectForKey:KEY_MODE]];
            [Util popupAlert:msg];
        }
    }
    else{
        [self updateViewOnTaskCompleted];
        [self updateTask:selectedTask Mode: TASK_COMPLETED WorkerId:nil];
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

- (void) updateTask:(PFObject *)task Mode:(NSString *)mode WorkerId:(NSString *) workerId {
    //Note: So far below is not a syncronized process. For multiple users, we should first retrived an updated object (using objectId) from CMS then checked it's availablity and then updated its mode to start.

    if(workerId != nil) {
        task[KEY_WORKER_ID] = workerId;
    }
    task[KEY_MODE] = mode;
    [task saveInBackground];
    isAnyTaskModified = true;
}

- (void) setTabBarEnabled:(BOOL) enabled {
    [[[[self.tabBarController tabBar]items]objectAtIndex:1]setEnabled:enabled];
    [[[[self.tabBarController tabBar]items]objectAtIndex:2]setEnabled:enabled];
}

- (IBAction)onClickBack:(id)sender {
    if([self.btnAction.titleLabel.text isEqualToString:BUTTON_START]) {
        if(totalDataCount == 0 || isAnyTaskModified) {
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
    [query whereKey:KEY_WORKER_ID equalTo:user.objectId];
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
