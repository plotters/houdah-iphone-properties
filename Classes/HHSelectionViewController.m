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

#import "HHSelectionViewController.h"


#import "HHItemTableViewCell.h"
#import "HHStandbyTableViewCell.h"


@interface HHSelectionViewController ()

@property (retain) NSObject *container;

@end


@implementation HHSelectionViewController

#pragma mark -
#pragma mark Initialization

- (id)initWithContainer:(NSObject*)properties descriptor:(NSDictionary*)dictionary
{
	if ((self = [super initWithNibName:@"SelectionViewController" bundle:nil]) != nil) {
		self.container = properties;
		self.property = dictionary;
	}
	
	return self;
}

- (void)viewDidLoad
{
	[super viewDidLoad];

	self.title = [self.property valueForKey:@"label"]; 
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
	
	NSArray *items = [self.property objectForKey:@"items"];
	NSObject *selection = [self.container valueForKey:[property objectForKey:@"name"]];
	
	if ([selection isKindOfClass:[NSSet class]]) {
		NSMutableSet *selectionSet = [NSMutableSet setWithSet:(NSSet*)selection];
		
		[selectionSet intersectSet:[NSSet setWithArray:items]];
		selection = selectionSet;
	}
	else {
		if (![items containsObject:selection]) {
			selection = nil;
		}
	}

	[self.container setValue:selection forKey:[property objectForKey:@"name"]];

}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}


#pragma mark -
#pragma mark Accessors

@synthesize container;
@synthesize property;


#pragma mark -
#pragma mark Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)sectionIndex
//{
//	return NSLocalizedString(@"Select from list", @"Select from list");
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{	
	NSArray *items = [self.property objectForKey:@"items"];
	
	return ((items == nil) ? 1 : [items count]);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{	
	NSArray *items = [self.property objectForKey:@"items"];

	if (items != nil) {
		static NSString *ItemCellIdentifier = @"ItemCellIdentifier";
	
		HHItemTableViewCell *itemCell = (HHItemTableViewCell*)[self.tableView dequeueReusableCellWithIdentifier:ItemCellIdentifier];
		
		if (itemCell == nil) {
			itemCell = [[[HHItemTableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:ItemCellIdentifier] autorelease];
		}
		
		NSArray *items = [self.property objectForKey:@"items"];
		NSObject *item = [items objectAtIndex:indexPath.row];
		NSObject *selection = [self.container valueForKey:[property objectForKey:@"name"]];

		if ([selection isKindOfClass:[NSSet class]]) {
			NSSet *selectionSet = (NSSet*)selection;

			if ([selectionSet containsObject:item]) {
				itemCell.checkmarkView.image = [UIImage imageNamed:@"checkmark.png"];
			}
			else {
				itemCell.checkmarkView.image = nil;
			}
		}
		else {
			if ([selection isEqual:item]) {
				itemCell.checkmarkView.image = [UIImage imageNamed:@"checkmark.png"];
			}
			else {
				itemCell.checkmarkView.image = nil;
			}
		}

		NSFormatter *formatter = [self.property objectForKey:@"formatter"];
		
		itemCell.label.text = ((formatter != nil) ? [formatter stringForObjectValue:item] : [item description]);

		return itemCell;
	}
	else {
		static NSString *StandbyCellIdentifier = @"StandbyCellIdentifier";
		
		HHStandbyTableViewCell *standbyTableViewCell = (HHStandbyTableViewCell*)[self.tableView dequeueReusableCellWithIdentifier:StandbyCellIdentifier];
		
		if (standbyTableViewCell == nil) {
			standbyTableViewCell = [[[HHStandbyTableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:StandbyCellIdentifier] autorelease];
		}
		
		return standbyTableViewCell;
	}
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSArray *items = [self.property objectForKey:@"items"];
	
	if (items != nil) {
		NSObject *item = [items objectAtIndex:indexPath.row];
		NSObject *selection = [self.container valueForKey:[property objectForKey:@"name"]];

		if ([selection isKindOfClass:[NSSet class]]) {
			if (! [selection isKindOfClass:[NSMutableSet class]]) {
				selection = [NSMutableSet setWithSet:((NSSet*)selection)];
			}

			NSMutableSet *selectionSet = (NSMutableSet*)selection;
					
			if ([selectionSet containsObject:item]) {
				[selectionSet removeObject:item];
			}
			else {
				[selectionSet addObject:item];
			}
		}
		else {
			if ([selection isEqual:item]) {
				selection = nil;
			}
			else {
				selection = item;
			}
		}

		[self.container setValue:selection forKey:[property objectForKey:@"name"]];

		[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
		[self.tableView reloadData];
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
	self.property = nil;
	
	[super dealloc];
}

@end