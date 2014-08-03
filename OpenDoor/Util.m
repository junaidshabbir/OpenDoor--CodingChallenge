//
//  Util.m
//  OpenDoor
//
//  Created by Junaid Shabbir on 7/31/14.
//  Copyright (c) 2014 Junaid's. All rights reserved.
//

#import "Util.h"
#import <Parse/Parse.h>

@implementation Util

+ (void) popupAlert: (NSString*) message {
    UIAlertView *playAlert = [[UIAlertView alloc] initWithTitle:@"OpenDoor" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [playAlert show];
}

+ (void) putNewDummyData {
    for (int i=100; i>0; i--) {
        [self putIntoCMS:i];
        [NSThread sleepForTimeInterval:1.0f];
    }
}

+ (void) putIntoCMS:(int) i {
    NSCalendar* calendar = [[NSCalendar alloc] initWithCalendarIdentifier: NSGregorianCalendar];
    NSDateComponents* components = [[NSDateComponents alloc] init];
    components.day = i;
    NSDate* newDate = [calendar dateByAddingComponents: components toDate: [NSDate date] options: 0];
    
    PFObject *task;
    task = [PFObject objectWithClassName:@"Task"];
    task[@"title"] = [NSString stringWithFormat:@"%@ - %d", @"Admin Test Task", i];
    task[@"desc"] = [NSString stringWithFormat:@"%@", @"Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat. "];
    task[@"address"] = [NSString stringWithFormat:@"%@ - %d", @"Singapore", i];
    task[@"earn"] = [NSString stringWithFormat:@"%d", i];
    task[@"earnCurrency"] = [NSString stringWithFormat:@"%@", @"SGD"];
    task[@"is_active"] = @YES;
    task[@"expiryDate"] = newDate;
    task[@"mode"] = @"AVAILABLE";
    [task saveInBackground];
}

@end
