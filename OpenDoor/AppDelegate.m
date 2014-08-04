//
//  AppDelegate.m
//  OpenDoor
//
//  Created by Junaid Shabbir on 7/31/14.
//  Copyright (c) 2014 Junaid's. All rights reserved.
//

#import "AppDelegate.h"
#import <Parse/Parse.h>
#import "LoginViewController.h"
#import "WorkViewController.h"
#import "AccountViewController.h"
#import "MessagesViewController.h"

@implementation AppDelegate
@synthesize navigationController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    [Parse setApplicationId:@"aYmitkzvjSMQyMNIQWtwTTnQHwGIrKaDPsDQJCNj" clientKey:@"8WgHmpOZfA76Oo4MhKjQmwayxlf9TjuW7qHNP4ex"];
    
    [PFUser enableAutomaticUser];
    PFACL *defaultACL = [PFACL ACL];
    
    // If you would like all objects to be private by default, remove this line.
    [defaultACL setPublicReadAccess:YES];
    [PFACL setDefaultACL:defaultACL withAccessForCurrentUser:YES];
    
    if (application.applicationState != UIApplicationStateBackground) {
        // Track an app open here if we launch with a push, unless
        // "content_available" was used to trigger a background push (introduced
        // in iOS 7). In that case, we skip tracking here to avoid double
        // counting the app-open.
        BOOL preBackgroundPush = ![application respondsToSelector:@selector(backgroundRefreshStatus)];
        BOOL oldPushHandlerOnly = ![self respondsToSelector:@selector(application:didReceiveRemoteNotification:fetchCompletionHandler:)];
        BOOL noPushPayload = ![launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        if (preBackgroundPush || oldPushHandlerOnly || noPushPayload) {
            [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
        }
    }
    [application registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge|
     UIRemoteNotificationTypeAlert|
     UIRemoteNotificationTypeSound];
    
    [self switchScreen];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

+ (AppDelegate*) appDelegate {
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (void) switchScreen
{
    // Check if user already login then Work screen otherwise Login screen
    if (self.isLogin) {
        WorkViewController *workViewController = [[WorkViewController alloc] initWithNibName:@"WorkViewController" bundle:[NSBundle mainBundle]];
        AccountViewController *accountViewController = [[AccountViewController alloc] initWithNibName:@"AccountViewController" bundle:[NSBundle mainBundle]];
        MessagesViewController *messageViewController = [[MessagesViewController alloc] initWithNibName:@"MessagesViewController" bundle:[NSBundle mainBundle]];
        
        workViewController.title = @"Work";
        accountViewController.title = @"Account";
        messageViewController.title = @"Messages";

        workViewController.tabBarItem.image = [UIImage imageNamed:@"work-icon"];
        accountViewController.tabBarItem.image = [UIImage imageNamed:@"account-icon"];
        messageViewController.tabBarItem.image = [UIImage imageNamed:@"message-icon"];
        
        self.tabBarController = [[UITabBarController alloc] init];
        self.tabBarController.viewControllers = @[workViewController, accountViewController, messageViewController];
        [self.navigationController setNavigationBarHidden:YES];
        [self.navigationController pushViewController:self.tabBarController animated:YES];
        
    }
    else {
        LoginViewController *loginViewController  = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:[NSBundle mainBundle]];
        self.navigationController = [[UINavigationController alloc]initWithRootViewController:loginViewController];
        self.window.rootViewController = self.navigationController;
        self.navigationController.navigationBarHidden = true;
        [self.window makeKeyAndVisible];
    }
}

/* 
 Push Notifications 
 */

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)newDeviceToken {
    [PFPush storeDeviceToken:newDeviceToken];
    [PFPush subscribeToChannelInBackground:@"" target:self selector:@selector(subscribeFinished:error:)];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    if (error.code == 3010) {
        NSLog(@"Push notifications are not supported in the iOS Simulator.");
    } else {
        // show some alert or otherwise handle the failure to register.
        NSLog(@"application:didFailToRegisterForRemoteNotificationsWithError: %@", error);
	}
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [PFPush handlePush:userInfo];
    
    if (application.applicationState == UIApplicationStateInactive) {
        [PFAnalytics trackAppOpenedWithRemoteNotificationPayload:userInfo];
    }
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    if (application.applicationState == UIApplicationStateInactive) {
        [PFAnalytics trackAppOpenedWithRemoteNotificationPayload:userInfo];
    }
}

#pragma mark - ()

- (void)subscribeFinished:(NSNumber *)result error:(NSError *)error {
    if ([result boolValue]) {
        NSLog(@"ParseStarterProject successfully subscribed to push notifications on the broadcast channel.");
    } else {
        NSLog(@"ParseStarterProject failed to subscribe to push notifications on the broadcast channel.");
    }
}


@end
