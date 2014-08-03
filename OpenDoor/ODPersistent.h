//
//  ODPersistent.h
//  OpenDoor
//
//  Created by Junaid Shabbir on 8/3/14.
//  Copyright (c) 2014 Junaid's. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ODPersistent : NSObject

+ (void) saveObject:(id)object forKey:(NSString*)key;
+ (id) getObjectForKey:(NSString*) key;


#define KEY_USER          @"USER"

@end
