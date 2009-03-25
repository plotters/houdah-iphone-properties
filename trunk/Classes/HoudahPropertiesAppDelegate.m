//
//  HoudahPropertiesAppDelegate.m
//  HoudahProperties
//
//  Created by Pierre Bernard on 25/03/2009.
//  Copyright Houdah Software 2009. All rights reserved.
//

#import "HoudahPropertiesAppDelegate.h"

#import "UserDefaultsViewController.h"


@interface HoudahPropertiesAppDelegate ()

@property (retain) UINavigationController *navigationController;

@end


@implementation HoudahPropertiesAppDelegate

@synthesize window;
@synthesize navigationController;

- (void)applicationDidFinishLaunching:(UIApplication *)application
{	
	UserDefaultsViewController *viewController = [[UserDefaultsViewController alloc] init];
	UINavigationController *controller = [[UINavigationController alloc] initWithRootViewController:viewController];
		
	[window addSubview:[controller view]];
	[window makeKeyAndVisible];

	self.navigationController = controller;
	
	[controller release];
	[viewController release];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
	// Save data if appropriate
}

- (void)dealloc
{
	self.navigationController = nil;
	self.window = nil;
	
	[super dealloc];
}

@end