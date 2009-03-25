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

#import "LongTextViewController.h"


@interface LongTextViewController () <UITextViewDelegate>

@property (retain) NSObject *container;
@property (copy) NSDictionary *property;
@property (nonatomic, retain) IBOutlet UITextView *propertyText;

@end


@implementation LongTextViewController

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
	
	[self.propertyText becomeFirstResponder];
    [self.propertyText setSelectedRange:NSMakeRange(0, [self.propertyText.text length])];
}

- (void)viewWillDisappear:(BOOL)animated
{
	if (self.editing) {
		self.editing = NO;
	}
	
	NSString *propertyValue = self.propertyText.text;
	NSString *propertyName = [self.property valueForKey:@"name"];
	
	if (propertyValue != nil) {
		[self.container setValue:propertyValue forKey:propertyName];
	}
	else {
		[self.container setValue:[NSNull null] forKey:propertyName];
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
@synthesize property;
@synthesize propertyText;


#pragma mark -
#pragma mark Table View

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    static NSString *LongTextCellIdentifier = @"LongTextCellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LongTextCellIdentifier];
   
	if (cell == nil)  {
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:LongTextCellIdentifier] autorelease];
       
		UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(10.0, 10.0, 280.0, 140.0)];
        
		textView.editable = YES;
        textView.font = [UIFont systemFontOfSize:14.0];
        
        [[cell contentView] addSubview:textView];
        [textView release];
 
		self.propertyText = textView;
	}
	
	NSString *stringValue = [self.container valueForKey:[property objectForKey:@"name"]];
	
	self.propertyText.text = stringValue;
	self.propertyText.delegate = self;
	
    return cell;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	return nil;	
}

- (NSIndexPath *)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	return nil;	
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 160.0;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
	NSString *propertyValue = textView.text;
	NSString *propertyName = [self.property valueForKey:@"name"];
	
	if (propertyValue != nil) {
		[self.container setValue:propertyValue forKey:propertyName];
	}
	else {
		[self.container setValue:[NSNull null] forKey:propertyName];
	}
}


#pragma mark -
#pragma mark Finalization

- (void)dealloc 
{
	self.container = nil;
	self.property = nil;
	self.propertyText = nil;
    
	[super dealloc];
}

@end
