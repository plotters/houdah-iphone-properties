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

#import "ItemTableViewCell.h"


@interface ItemTableViewCell ()

@property (retain) UIImageView *checkmarkView;

@end


@implementation ItemTableViewCell

@synthesize checkmarkView;

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
		CGRect imageFrame = CGRectMake(6.0, 5.0, 32.0, 32.0);
		UIImageView *imageView = [[UIImageView alloc] initWithFrame:imageFrame];
		
		imageView.autoresizingMask = UIViewAutoresizingNone;
		
		[self.contentView addSubview:imageView];
		[imageView release];

		self.checkmarkView = imageView;
		
		CGRect labelFrame = CGRectMake(30.0, 10.0, CGRectGetMaxX(self.contentView.bounds) - 100.0, 22.0);
		
		self.label.frame = labelFrame;
		
		[self setNeedsLayout];
    }
	
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

@end