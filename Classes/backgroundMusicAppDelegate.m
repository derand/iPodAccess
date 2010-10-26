//
//  backgroundMusicAppDelegate.m
//  backgroundMusic
//
//  Created by maliy on 7/15/10.
//  Copyright interMobile 2010. All rights reserved.
//

#import "backgroundMusicAppDelegate.h"
#import "mainViewController.h"


@implementation backgroundMusicAppDelegate

@synthesize window;
@synthesize navigationController;


#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    // Override point for customization after app launch    
	
	navigationController = [[UINavigationController alloc] init];
	mainViewController *vc = [[mainViewController alloc] init];
	navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
	[navigationController setViewControllers:[NSArray arrayWithObject:vc]];
	[vc release];
	
 	self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	[window addSubview:navigationController.view];
    [window makeKeyAndVisible];
	
	return YES;
}


- (void)applicationWillTerminate:(UIApplication *)application {
	// Save data if appropriate
}


#pragma mark -
#pragma mark Memory management

- (void)dealloc {
	[navigationController release];
	[window release];
	[super dealloc];
}


@end

