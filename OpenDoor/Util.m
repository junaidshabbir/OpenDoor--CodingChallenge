//
//  Util.m
//  OpenDoor
//
//  Created by Junaid Shabbir on 7/31/14.
//  Copyright (c) 2014 Junaid's. All rights reserved.
//

#import "Util.h"

@implementation Util

+ (void) popupAlert: (NSString*) message {
    UIAlertView *playAlert = [[UIAlertView alloc] initWithTitle:@"OpenDoor" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [playAlert show];
}

@end
