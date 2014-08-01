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

@interface WorkViewController ()

@end

@implementation WorkViewController
@synthesize customSegment;
@synthesize taskObjects;
@synthesize tableView;
@synthesize indicator;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self queryTaskObjects];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) queryTaskObjects {
    [indicator startAnimating];
    PFQuery *query = [PFQuery queryWithClassName:@"Task"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        [indicator stopAnimating];
        if (!error) {
            // The find succeeded.
            taskObjects = objects;
            [tableView reloadData];
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

- (void) onSegmentValueChange:(id)sender {
    if (self.customSegment.selectedSegmentIndex == 0) {
        
    }
    else {
        
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [taskObjects count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PFObject *currentObject = [taskObjects objectAtIndex:indexPath.section];
    
    [[NSBundle mainBundle] loadNibNamed:@"WorkCell" owner:self options:nil];
    WorkCell *workCell = self.workCell;
    self.workCell = nil;
    
    workCell.lblTitle.text = [currentObject objectForKey:@"title"];
    workCell.lblDesc.text = [currentObject objectForKey:@"desc"];
    workCell.lblAddress.text = [currentObject objectForKey:@"address"];
    
    return workCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}


@end
