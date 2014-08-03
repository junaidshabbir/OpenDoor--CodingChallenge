//
//  User.h
//  OpenDoor
//
//  Created by Junaid Shabbir on 8/3/14.
//  Copyright (c) 2014 Junaid's. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject {
    NSString *objectId;
    NSString *mobileNo;
    NSString *firstName;
    NSString *lastName;
    NSString *accountType;
    NSString *accountId;
    NSString *work;
    NSString *home;
    NSString *other;
}

@property (nonatomic) NSString *objectId;
@property (nonatomic) NSString *mobileNo;
@property (nonatomic) NSString *firstName;
@property (nonatomic) NSString *lastName;
@property (nonatomic) NSString *accountType;
@property (nonatomic) NSString *accountId;
@property (nonatomic) NSString *work;
@property (nonatomic) NSString *home;
@property (nonatomic) NSString *other;

@end
