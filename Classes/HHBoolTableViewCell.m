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

#import "HHBoolTableViewCell.h"


@interface HHBoolTableViewCell ()

@property (retain) UISwitch *propertySwitch;

@end


@implementation HHBoolTableViewCell

@synthesize propertySwitch;

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {

		CGRect frame = CGRectMake(CGRectGetMaxX(self.contentView.bounds) - 100.0, 7.0, 160.0, 32.0);
		UISwitch *stateSwitch = [[UISwitch alloc] initWithFrame:frame];
		
		stateSwitch.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
		
		[stateSwitch addTarget:self action:@selector(stateSwitchFlipped:forEvent:) forControlEvents:UIControlEventValueChanged];
		
		self.propertySwitch = stateSwitch;
	
		[self.contentView addSubview:stateSwitch];
		[stateSwitch release];

		[self setNeedsLayout];
    }
	
    return self;
}

- (void)stateSwitchFlipped:(id)sender forEvent:(UIEvent *)event
{
	[UIApp sendAction:@selector(propertySwitchFlipped:) to:nil from:self forEvent:event];
}

- (void)dealloc
{
	self.propertySwitch = nil;

    [super dealloc];
}

@end