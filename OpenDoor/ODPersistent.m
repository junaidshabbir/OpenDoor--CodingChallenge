//
//  ODPersistent.m
//  OpenDoor
//
//  Created by Junaid Shabbir on 8/3/14.
//  Copyright (c) 2014 Junaid's. All rights reserved.
//

#import "ODPersistent.h"

@implementation ODPersistent


+ (void) saveObject:(id)object forKey:(NSString*)key {
	NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
	[defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:object] forKey:key];
	[defaults synchronize];
}

+ (id) getObjectForKey:(NSString*) key {
	NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
	NSData *objectData = [defaults objectForKey:key];
	if (objectData != nil) {
		id object = [NSKeyedUnarchiver unarchiveObjectWithData:objectData];
		return object;
	}
	return nil;
}

@end
