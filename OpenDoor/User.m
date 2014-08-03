//
//  User.m
//  OpenDoor
//
//  Created by Junaid Shabbir on 8/3/14.
//  Copyright (c) 2014 Junaid's. All rights reserved.
//

#import "User.h"

@implementation User
@synthesize objectId;
@synthesize mobileNo;
@synthesize firstName;
@synthesize lastName;
@synthesize accountType;
@synthesize accountId;
@synthesize work;
@synthesize home;
@synthesize other;

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:objectId forKey:@"objectId"];
    [encoder encodeObject:mobileNo forKey:@"mobileNo"];
    [encoder encodeObject:firstName forKey:@"firstName"];
    [encoder encodeObject:lastName forKey:@"lastName"];
    [encoder encodeObject:accountType forKey:@"accountType"];
    [encoder encodeObject:accountId forKey:@"accountId"];
    [encoder encodeObject:work forKey:@"work"];
    [encoder encodeObject:home forKey:@"home"];
    [encoder encodeObject:other forKey:@"other"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        objectId = [decoder decodeObjectForKey:@"objectId"];
        mobileNo = [decoder decodeObjectForKey:@"mobileNo"];
        firstName = [decoder decodeObjectForKey:@"firstName"];
        lastName = [decoder decodeObjectForKey:@"lastName"];
        accountType = [decoder decodeObjectForKey:@"accountType"];
        accountId = [decoder decodeObjectForKey:@"accountId"];
        work = [decoder decodeObjectForKey:@"work"];
        home = [decoder decodeObjectForKey:@"home"];
        other = [decoder decodeObjectForKey:@"other"];
    }
    return self;
}

@end
