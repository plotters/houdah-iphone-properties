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

#import "TextTableViewCell.h"


@interface TextTableViewCell () <UITextFieldDelegate>

@property (retain) UITextField *propertyText;

@end


@implementation TextTableViewCell

@synthesize propertyText;
@synthesize editable;

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
		CGRect frame = CGRectMake(CGRectGetMaxX(self.contentView.bounds) - 155.0, 9.0, 120.0, 32.0);
		UITextField *textField = [[UITextField alloc] initWithFrame:frame];
		
		textField.delegate = self;

		textField.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
		textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
		textField.autocorrectionType = UITextAutocorrectionTypeNo;
		textField.textAlignment = UITextAlignmentRight;
		textField.returnKeyType = UIReturnKeyDone;
				
		[textField addTarget:self action:@selector(textEditingDidEnd:forEvent:) forControlEvents:UIControlEventEditingDidEnd];
		
		self.propertyText = textField;
		
		[self.contentView addSubview:textField];
		[textField release];

		self.editable = YES;
		
		[self setNeedsLayout];
    }
	
    return self;
}

- (void)textEditingDidEnd:(id)sender forEvent:(UIEvent *)event
{
	[UIApp sendAction:@selector(textEditingDidEnd:) to:nil from:self forEvent:event];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
	return self.editable;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[textField resignFirstResponder];
	
	return YES;
}

- (void)dealloc
{
	self.propertyText = nil;
	
    [super dealloc];
}

@end