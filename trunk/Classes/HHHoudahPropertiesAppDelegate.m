//
//  HoudahPropertiesAppDelegate.m
//  HoudahProperties
//
//  Created by Pierre Bernard on 25/03/2009.
//  Copyright Houdah Software 2009. All rights reserved.
//

#import "HHHoudahPropertiesAppDelegate.h"

#import "HHUserDefaultsViewController.h"


@interface HHHoudahPropertiesAppDelegate ()

@property (retain) UINavigationController *navigationController;

@end


@implementation HHHoudahPropertiesAppDelegate

@synthesize window;
@synthesize navigationController;

- (void)applicationDidFinishLaunching:(UIApplication *)application
{	
	HHUserDefaultsViewController *viewController = [[HHUserDefaultsViewController alloc] init];
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