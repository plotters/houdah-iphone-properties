/*
 * Modified MIT License
 * 
 * Copyright (c) 2009 Houdah Software s.à r.l.
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * Except as contained in this notice, the name(s) of the above copyright holders
 * shall not be used in advertising or otherwise to promote the sale, use or other 
 * dealings in this Software without prior written authorization.
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 **/

#import "PropertiesViewController.h"

#import "BoolTableViewCell.h"
#import "ButtonTableViewCell.h"
#import "LongTableViewCell.h"
#import "LongTextViewController.h"
#import "PropertyTableViewCell.h"
#import "SelectionTableViewCell.h"
#import "SelectionViewController.h"
#import "SubPropertyTableViewCell.h"
#import "TextTableViewCell.h"

@interface PropertiesViewController ()

- (id)initWithContainer:(NSObject*)container;

@property (retain) NSObject *container;
@property (copy) NSArray *descriptors;

- (UITableViewCell *)boolCellForProperty:(NSDictionary*)property;
- (UITableViewCell *)textCellForProperty:(NSDictionary*)property;
- (UITableViewCell *)longCellForProperty:(NSDictionary*)property;
- (UITableViewCell *)secureCellForProperty:(NSDictionary*)property;
- (UITableViewCell *)selectionCellForProperty:(NSDictionary*)property;
- (UITableViewCell *)subPropertyCellForProperty:(NSDictionary*)property;
- (UITableViewCell *)buttonCellForProperty:(NSDictionary*)property;

- (NSDictionary*)propertyForName:(NSString*)name;

- (void)performActionForRowWithIndexPath:(NSIndexPath *)indexPath;

@end


@implementation PropertiesViewController

#pragma mark -
#pragma mark Initialization

- (id)initWithContainer:(NSObject*)properties descriptors:(NSArray*)sections
{
	if ((self = [super initWithNibName:@"PropertiesViewController" bundle:nil]) != nil) {
		self.container = properties;
		self.descriptors = sections;
		self.title = NSLocalizedString(@"Properties", @"Properties"); 
	}
	
	return self;
}

- (id)initWithContainer:(NSObject*)container
{
	[self release];
	
	return nil;
}

- (void)viewDidLoad
{	
	[super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
	[self.tableView reloadData]; 
	
	[super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	if (self.editing) {
		self.editing = NO;
	}
	
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}


#pragma mark -
#pragma mark Accessors

@synthesize container;
@synthesize descriptors;


#pragma mark -
#pragma mark Instance methods

- (void)endEditing
{
	// HACK: suggestions welcome
	int sCount = [self numberOfSectionsInTableView:self.tableView];

	for (int s = 0; s < sCount; s++) {
		int rCount = [self tableView:self.tableView numberOfRowsInSection:s];
		
		for (int r = 0; r < rCount; r++) {
			NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
			UITableViewCell *tableViewCell = [self.tableView cellForRowAtIndexPath:indexPath];
			
			if ([tableViewCell isKindOfClass:[TextTableViewCell class]]) {
				TextTableViewCell *textTableViewCell = (TextTableViewCell*)tableViewCell;
				
				[textTableViewCell.propertyText endEditing:YES];
			}
		}
	}
}


#pragma mark -
#pragma mark Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return [self.descriptors count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)sectionIndex
{
	NSDictionary *section = [self.descriptors objectAtIndex:sectionIndex];

	return [section objectForKey:@"title"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{	
	NSDictionary *section = [self.descriptors objectAtIndex:sectionIndex];
	NSArray *sectionProperties = [section objectForKey:@"properties"];
	
	return [sectionProperties count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{	
	NSDictionary *section = [self.descriptors objectAtIndex:indexPath.section];
	NSArray *sectionProperties = [section objectForKey:@"properties"];
	NSDictionary *property = [sectionProperties objectAtIndex:indexPath.row];
	NSNumber *type = [property objectForKey:@"type"];
	
	switch ([type intValue]) {
		case PVCBoolPropertyType:
			return [self boolCellForProperty:property];
		case PVCTextPropertyType:
			return [self textCellForProperty:property];
		case PVCLongPropertyType:
			return [self longCellForProperty:property];
		case PVCSecurePropertyType:
			return [self secureCellForProperty:property];
		case PVCSelectionPropertyType:
			return [self selectionCellForProperty:property];
		case PVCSubPropertyPropertyType:
			return [self subPropertyCellForProperty:property];
		case PVCButtonPropertyType:
			return [self buttonCellForProperty:property];
	}
	
	return nil;
}

- (UITableViewCell *)boolCellForProperty:(NSDictionary*)property
{
	static NSString *BoolCellIdentifier = @"BoolCellIdentifier";
	
	BoolTableViewCell *boolCell = (BoolTableViewCell*)[self.tableView dequeueReusableCellWithIdentifier:BoolCellIdentifier];
	
	if (boolCell == nil) {
		boolCell = [[[BoolTableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:BoolCellIdentifier] autorelease];
	}
	
	boolCell.propertyName = [property objectForKey:@"name"];
	boolCell.label.text = [property objectForKey:@"label"];
	boolCell.propertySwitch.on = [[self.container valueForKey:[property objectForKey:@"name"]] boolValue];
	
	return boolCell;
}

- (UITableViewCell *)textCellForProperty:(NSDictionary*)property
{
	static NSString *TextCellIdentifier = @"TextCellIdentifier";
	
	TextTableViewCell *textCell = (TextTableViewCell*)[self.tableView dequeueReusableCellWithIdentifier:TextCellIdentifier];
	
	if (textCell == nil) {
		textCell = [[[TextTableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:TextCellIdentifier] autorelease];
	}
	
	textCell.propertyName = [property objectForKey:@"name"];
	textCell.label.text = [property objectForKey:@"label"];
	
	NSFormatter *formatter = [property objectForKey:@"formatter"];
	NSObject *object = [self.container valueForKey:[property objectForKey:@"name"]];
	
	textCell.propertyText.text = ((formatter != nil) ? [formatter stringForObjectValue:object] : [object description]);
	
	NSNumber *editable = [property objectForKey:@"editable"];
	
	if (editable != nil) {
		textCell.editable = [editable boolValue];
	}
	else {
		textCell.editable = YES;
	}
	
	return textCell;
}

- (UITableViewCell *)longCellForProperty:(NSDictionary*)property;
{
	static NSString *LongCellIdentifier = @"LongCellIdentifier";
	
	LongTableViewCell *longTableViewCell = (LongTableViewCell*)[self.tableView dequeueReusableCellWithIdentifier:LongCellIdentifier];
	
	if (longTableViewCell == nil) {
		longTableViewCell = [[[LongTableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:LongCellIdentifier] autorelease];
	}
	
	longTableViewCell.propertyName = [property objectForKey:@"name"];
	longTableViewCell.label.text = [property objectForKey:@"label"];
	
	NSString *value = [self.container valueForKey:[property objectForKey:@"name"]];
	
	longTableViewCell.propertyLabel.text = value;
	
	return longTableViewCell;
}

- (UITableViewCell *)secureCellForProperty:(NSDictionary*)property
{
	static NSString *SecureCellIdentifier = @"SecureCellIdentifier";
	
	TextTableViewCell *textCell = (TextTableViewCell*)[self.tableView dequeueReusableCellWithIdentifier:SecureCellIdentifier];
	
	if (textCell == nil) {
		textCell = [[[TextTableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:SecureCellIdentifier] autorelease];

		textCell.propertyText.secureTextEntry = YES;
	}
	
	textCell.propertyName = [property objectForKey:@"name"];
	textCell.label.text = [property objectForKey:@"label"];
	
	NSFormatter *formatter = [property objectForKey:@"formatter"];
	NSObject *object = [self.container valueForKey:[property objectForKey:@"name"]];
	
	textCell.propertyText.text = ((formatter != nil) ? [formatter stringForObjectValue:object] : [object description]);
	
	return textCell;
}

- (UITableViewCell *)subPropertyCellForProperty:(NSDictionary*)property
{
	static NSString *SubPropertyCellIdentifier = @"SubPropertyCellIdentifier";
	
	SubPropertyTableViewCell *subPropertyCell = (SubPropertyTableViewCell*)[self.tableView dequeueReusableCellWithIdentifier:SubPropertyCellIdentifier];
	
	if (subPropertyCell == nil) {
		subPropertyCell = [[[SubPropertyTableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:SubPropertyCellIdentifier] autorelease];
	}
	
	subPropertyCell.propertyName = [property objectForKey:@"name"];
	subPropertyCell.label.text = [property objectForKey:@"label"];
	
	NSFormatter *formatter = [property objectForKey:@"formatter"];
	NSObject *object = [self.container valueForKey:[property objectForKey:@"name"]];
	
	NSString *value = ((formatter != nil) ? [formatter stringForObjectValue:object] : [object description]);

	if ([value length] != 0) {
		subPropertyCell.label.text = value;
	}
	
	return subPropertyCell;
}

- (UITableViewCell *)selectionCellForProperty:(NSDictionary*)property
{
	static NSString *SelectionCellIdentifier = @"SelectionCellIdentifier";
	
	SelectionTableViewCell *selectionCell = (SelectionTableViewCell*)[self.tableView dequeueReusableCellWithIdentifier:SelectionCellIdentifier];
	
	if (selectionCell == nil) {
		selectionCell = [[[SelectionTableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:SelectionCellIdentifier] autorelease];
	}
	
	selectionCell.propertyName = [property objectForKey:@"name"];
	selectionCell.label.text = [property objectForKey:@"label"];
	
	NSFormatter *formatter = [property objectForKey:@"formatter"];
	NSObject *object = [self.container valueForKey:[property objectForKey:@"name"]];
	
	selectionCell.propertyLabel.text = ((formatter != nil) ? [formatter stringForObjectValue:object] : [object description]);
	
	return selectionCell;
}

- (UITableViewCell *)buttonCellForProperty:(NSDictionary*)property
{
	static NSString *ButtonCellIdentifier = @"ButtonCellIdentifier";
	
	ButtonTableViewCell *buttonCell = (ButtonTableViewCell*)[self.tableView dequeueReusableCellWithIdentifier:ButtonCellIdentifier];
	
	if (buttonCell == nil) {
		buttonCell = [[[ButtonTableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:ButtonCellIdentifier] autorelease];
	}
	
	buttonCell.propertyName = [property objectForKey:@"name"];
	
	[buttonCell.propertyButton setTitle:[property objectForKey:@"label"] forState:UIControlStateNormal];
		
	return buttonCell;
}

- (UITableViewCellAccessoryType)tableView:(UITableView *)tableView accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath
{	
	NSDictionary *section = [self.descriptors objectAtIndex:indexPath.section];
	NSArray *sectionProperties = [section objectForKey:@"properties"];
	NSDictionary *property = [sectionProperties objectAtIndex:indexPath.row];
	NSNumber *type = [property objectForKey:@"type"];
	
	if ([type intValue] == PVCLongPropertyType) {
		return UITableViewCellAccessoryDisclosureIndicator;
	}
	else if ([type intValue] == PVCSelectionPropertyType) {
		return UITableViewCellAccessoryDisclosureIndicator;
	}
	else if ([type intValue] == PVCSubPropertyPropertyType) {
		return UITableViewCellAccessoryDetailDisclosureButton;
	}
	
	return UITableViewCellAccessoryNone;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
	return NO;
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
	[self performActionForRowWithIndexPath:indexPath];
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[self performActionForRowWithIndexPath:indexPath];
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	return nil;	
}

- (NSIndexPath *)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	return nil;	
}

- (void)performActionForRowWithIndexPath:(NSIndexPath *)indexPath
{
	NSDictionary *section = [self.descriptors objectAtIndex:indexPath.section];
	NSArray *sectionProperties = [section objectForKey:@"properties"];
	NSDictionary *property = [sectionProperties objectAtIndex:indexPath.row];
	NSNumber *type = [property objectForKey:@"type"];
	
	if ([type intValue] == PVCLongPropertyType) {
		[self pushLongTextViewControllerForProperty:property];
	}
	else if ([type intValue] == PVCSelectionPropertyType) {
		[self pushSelectionViewControllerForProperty:property];
	}
	else if ([type intValue] == PVCSubPropertyPropertyType) {
		[self pushSubViewControllerForProperty:property];
	}
}

- (void)pushLongTextViewControllerForProperty:(NSDictionary*)property
{
	NSString *className = [property objectForKey:@"className"];
	
	if ([className length] == 0) {
		className = @"LongTextViewController";
	}
	
	Class longTextViewControllerClass = NSClassFromString(className);
	LongTextViewController *longTextViewController =  [(LongTextViewController*)[longTextViewControllerClass alloc] initWithContainer:self.container descriptor:property];
	
	[self.navigationController pushViewController:longTextViewController animated:YES];
	[longTextViewController release];
}

- (void)pushSelectionViewControllerForProperty:(NSDictionary*)property
{
	NSString *className = [property objectForKey:@"className"];
	
	if ([className length] == 0) {
		className = @"SelectionViewController";
	}
	
	Class selectionViewControllerClass = NSClassFromString(className);
	SelectionViewController *selectionViewController =  [(SelectionViewController*)[selectionViewControllerClass alloc] initWithContainer:self.container descriptor:property];
	
	[self.navigationController pushViewController:selectionViewController animated:YES];
	[selectionViewController release];
}

- (void)pushSubViewControllerForProperty:(NSDictionary*)property
{
	NSString *className = [property objectForKey:@"className"];
	
	if ([className length] == 0) {
		className = @"PropertiesViewController";
	}
	
	Class propertiesViewControllerClass = NSClassFromString(className);
	NSArray *sections = [property objectForKey:@"descriptors"];
	PropertiesViewController *propertiesViewController = nil;
	
	if (sections != nil) {
		propertiesViewController = [(PropertiesViewController*)[propertiesViewControllerClass alloc] initWithContainer:self.container descriptors:sections];
	}
	else {
		propertiesViewController = [(PropertiesViewController*)[propertiesViewControllerClass alloc] initWithContainer:self.container];
	}
	
	NSString *propertyTitle = [property objectForKey:@"title"];
	
	if (propertyTitle != nil) {
		propertiesViewController.title = propertyTitle;
	}
	else {
		NSString *propertyLabel = [property objectForKey:@"label"];

		if (propertyLabel != nil) {
			propertiesViewController.title = propertyLabel;
		}
	}
	
	[self.navigationController pushViewController:propertiesViewController animated:YES];
	[propertiesViewController release];
}

- (void)propertySwitchFlipped:(id)sender
{
	BoolTableViewCell *boolCell = (BoolTableViewCell*)sender;
	NSString *propertyName = boolCell.propertyName;
	BOOL propertyValue = boolCell.propertySwitch.on;
	
	[self.container setValue:[NSNumber numberWithBool:propertyValue] forKey:propertyName];
}

- (void)buttonClicked:(id)sender
{
	ButtonTableViewCell *buttonCell = (ButtonTableViewCell*)sender;
	NSString *propertyName = buttonCell.propertyName;
	NSDictionary *property = [self propertyForName:propertyName];
	NSString *actionString = [property objectForKey:@"action"];
	
	if ([actionString length] > 0) {
		SEL actionSelector = NSSelectorFromString(actionString);

		[UIApp sendAction:actionSelector to:nil from:self forEvent:nil];
	}
}

- (void)textEditingDidEnd:(id)sender
{
	TextTableViewCell *textCell = (TextTableViewCell*)sender;
	NSString *propertyName = textCell.propertyName;
	NSDictionary *property = [self propertyForName:propertyName];
	NSFormatter *formatter = [property objectForKey:@"formatter"];
	NSObject *propertyValue = textCell.propertyText.text;

	if (formatter != nil) {
		NSString *errorDescription = nil;
		NSString *propertyString = (NSString *)propertyValue;
		BOOL success = [formatter getObjectValue:&propertyValue forString:propertyString errorDescription:&errorDescription];

		if (! success) {
			propertyValue = errorDescription;
		}
	}
		
	[self.container setValue:propertyValue forKey:propertyName];
}

- (NSDictionary*)propertyForName:(NSString*)name
{
	for (NSDictionary *section in self.descriptors) {
		NSArray *sectionProperties = [section objectForKey:@"properties"];
		
		for (NSDictionary *property in sectionProperties) {
			if ([name isEqual:[property objectForKey:@"name"]]) {
				return property;
			}
		}
	}
	
	return nil;
}


#pragma mark -
#pragma mark View

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	// Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
	// Release anything that's not essential, such as cached data
}


#pragma mark -
#pragma mark Finalization

- (void)dealloc
{
	self.container = nil;
	self.descriptors = nil;
	
	[super dealloc];
}

@end