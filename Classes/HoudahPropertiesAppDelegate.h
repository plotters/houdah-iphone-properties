//
//  HoudahPropertiesAppDelegate.h
//  HoudahProperties
//
//  Created by Pierre Bernard on 25/03/2009.
//  Copyright Houdah Software 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HoudahPropertiesAppDelegate : NSObject <UIApplicationDelegate>
{    
    UIWindow *window;
    UINavigationController *navigationController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@end