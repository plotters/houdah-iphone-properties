//
//  UserDefaultsViewController.m
//  HoudahProperties
//
//  Created by Pierre Bernard on 25/03/2009.
//  Copyright 2009 Houdah Software. All rights reserved.
//

#import "HHUserDefaultsViewController.h"

#import "HHPrivacyFormatter.h"
#import "HHResolutionFormatter.h"


@interface HHUserDefaultsViewController ()

+ (NSArray*)propertyDescriptors;

@end


@implementation HHUserDefaultsViewController

#pragma mark -
#pragma mark Initialization

- (id)init
{
	if ((self = [super initWithContainer:[NSUserDefaults standardUserDefaults]
							 descriptors:[HHUserDefaultsViewController propertyDescriptors]]) != nil) {
	}
	
	return self;
}

+ (NSArray*)propertyDescriptors
{
	static NSArray *propertyDescriptors = nil;
	
	if (propertyDescriptors == nil) {
		NSMutableArray *mutableArray = [NSMutableArray array];
		
		NSMutableDictionary *sectionOne = [NSMutableDictionary dictionary];
		NSMutableArray *sectionOneProperties = [NSMutableArray array];
		
		[sectionOne setObject:sectionOneProperties forKey:@"properties"];
		[sectionOne setObject:NSLocalizedString(@"Account", @"Account") forKey:@"title"];
		[mutableArray addObject:sectionOne];
		
		NSMutableDictionary *userNameProperty =  [NSMutableDictionary dictionary];
		
		[userNameProperty setObject:@"locrUserName" forKey:@"name"];
		[userNameProperty setObject:NSLocalizedString(@"User Name", @"User Name")  forKey:@"label"];
		[userNameProperty setObject:[NSNumber numberWithInt:PVCTextPropertyType] forKey:@"type"];
		[sectionOneProperties addObject:userNameProperty];
		
		NSMutableDictionary *passwordProperty =  [NSMutableDictionary dictionary];
		
		[passwordProperty setObject:@"locrPassword" forKey:@"name"];
		[passwordProperty setObject:NSLocalizedString(@"Password", @"Password")  forKey:@"label"];
		[passwordProperty setObject:[NSNumber numberWithInt:PVCSecurePropertyType] forKey:@"type"];
		[sectionOneProperties addObject:passwordProperty];		
		
		NSMutableDictionary *sectionTwo = [NSMutableDictionary dictionary];
		NSMutableArray *sectionTwoProperties = [NSMutableArray array];
		
		[sectionTwo setObject:sectionTwoProperties forKey:@"properties"];
		[sectionTwo setObject:NSLocalizedString(@"Settings", @"Settings") forKey:@"title"];
		[mutableArray addObject:sectionTwo];
		
		NSMutableDictionary *sizeProperty =  [NSMutableDictionary dictionary];
		
		[sizeProperty setObject:@"size" forKey:@"name"];
		[sizeProperty setObject:NSLocalizedString(@"Max Size", @"Max Size")  forKey:@"label"];
		[sizeProperty setObject:[NSArray arrayWithObjects:
								 [NSNumber numberWithInt:1600],
								 [NSNumber numberWithInt:1024],
								 [NSNumber numberWithInt:800],
								 [NSNumber numberWithInt:500],
								 [NSNumber numberWithInt:240],
								 [NSNumber numberWithInt:128],
								 [NSNumber numberWithInt:100], nil]  forKey:@"items"];
		[sizeProperty setObject:[[[HHResolutionFormatter alloc] init] autorelease] forKey:@"formatter"];
		[sizeProperty setObject:[NSNumber numberWithInt:PVCSelectionPropertyType] forKey:@"type"];
		[sectionTwoProperties addObject:sizeProperty];
				
		NSMutableDictionary *publicProperty =  [NSMutableDictionary dictionary];
		
		[publicProperty setObject:@"public" forKey:@"name"];
		[publicProperty setObject:NSLocalizedString(@"Public", @"Public") forKey:@"label"];
		[publicProperty setObject:[NSNumber numberWithInt:PVCBoolPropertyType] forKey:@"type"];
		[sectionTwoProperties addObject:publicProperty];
		
		NSMutableDictionary *sectionThree = [NSMutableDictionary dictionary];
		NSMutableArray *sectionThreeProperties = [NSMutableArray array];
		
		[sectionThree setObject:sectionThreeProperties forKey:@"properties"];
		[sectionThree setObject:NSLocalizedString(@"Details", @"Details") forKey:@"title"];
		[mutableArray addObject:sectionThree];
		
		NSMutableDictionary *nameProperty =  [NSMutableDictionary dictionary];
		
		[nameProperty setObject:@"name" forKey:@"name"];
		[nameProperty setObject:NSLocalizedString(@"Name", @"Name") forKey:@"label"];
		[nameProperty setObject:[NSNumber numberWithInt:PVCTextPropertyType] forKey:@"type"];
		[sectionThreeProperties addObject:nameProperty];
		
		NSMutableDictionary *captionProperty =  [NSMutableDictionary dictionary];
		
		[captionProperty setObject:@"caption" forKey:@"name"];
		[captionProperty setObject:NSLocalizedString(@"Caption", @"Caption") forKey:@"label"];
		[captionProperty setObject:[NSNumber numberWithInt:PVCTextPropertyType] forKey:@"type"];
		[sectionThreeProperties addObject:captionProperty];
		
		NSMutableDictionary *descriptionProperty =  [NSMutableDictionary dictionary];
		
		[descriptionProperty setObject:@"description" forKey:@"name"];
		[descriptionProperty setObject:NSLocalizedString(@"Description", @"Description") forKey:@"label"];
		[descriptionProperty setObject:[NSNumber numberWithInt:PVCLongPropertyType] forKey:@"type"];
		[sectionThreeProperties addObject:descriptionProperty];
		
		NSMutableDictionary *previewProperty =  [NSMutableDictionary dictionary];
		
		[previewProperty setObject:@"preview" forKey:@"name"];
		[previewProperty setObject:NSLocalizedString(@"Preview", @"Preview") forKey:@"label"];
		[previewProperty setObject:[NSNumber numberWithInt:PVCButtonPropertyType] forKey:@"type"];
		[previewProperty setObject:@"preview:" forKey:@"action"];
		[sectionThreeProperties addObject:previewProperty];

		propertyDescriptors = [[NSArray alloc] initWithArray:mutableArray];
	}
	
	return propertyDescriptors;
}


#pragma mark -
#pragma mark Finalization

- (void)dealloc
{
	[super dealloc];
}

@end