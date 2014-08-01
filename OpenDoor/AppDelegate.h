//
//  AppDelegate.h
//  OpenDoor
//
//  Created by Junaid Shabbir on 7/31/14.
//  Copyright (c) 2014 Junaid's. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *navigationController;
@property (nonatomic, strong) IBOutlet UITabBarController *tabBarController;

@property (nonatomic) bool isLogin;

- (void) switchScreen;
+ (AppDelegate*) appDelegate;

@end
