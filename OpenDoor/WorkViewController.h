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
    NSArray* taskObjects;
}

@property (nonatomic, retain) NSArray* taskObjects;

@property (retain, nonatomic) IBOutlet UISegmentedControl *customSegment;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator;

@property (strong, nonatomic) IBOutlet WorkCell *workCell;

- (IBAction)onSegmentValueChange:(id)sender;


@end
