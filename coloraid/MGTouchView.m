//
//  MGTouchView.m
//  TouchTest
//
//  Created by Matt Gemmell on 08/05/2010.
//

#import "MGTouchView.h"
#import <QuartzCore/QuartzCore.h>


@implementation MGTouchView


#pragma mark Setup and teardown


- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        self.color = [UIColor colorWithWhite:1.0 alpha:0.8];
		self.opaque = NO;
		self.showArrows = NO;
    }
    return self;
}


- (void)dealloc
{
	self.color = nil;
	
}


#pragma mark Drawing

#define kCornerRadius 8

- (void)drawRect:(CGRect)theRect
{
	// Outer ring.
	CGRect rect = self.bounds;
	UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:rect];
	rect = CGRectInset(rect, 5, 5);
	[path appendPath:[UIBezierPath bezierPathWithOvalInRect:rect]];
	path.usesEvenOddFillRule = YES;
	[self.color set];
	[path fill];
	
	
	[self.layer setCornerRadius:kCornerRadius];    
	self.layer.masksToBounds = NO;
	self.layer.shadowColor = self.layer.shadowColor;;
	self.layer.backgroundColor = self.layer.shadowColor;
 //made some modification for my use
	self.layer.shadowPath = [UIBezierPath
								 bezierPathWithRoundedRect:CGRectMake(-0.5*kCornerRadius, -0.5*kCornerRadius, self.bounds.size.width+1.0*kCornerRadius, self.bounds.size.height+1.0*kCornerRadius)
								 cornerRadius:kCornerRadius].CGPath;
	self.layer.cornerRadius = kCornerRadius;
	self.layer.shadowOffset = CGSizeMake(0.0, 0.0);
	self.layer.shadowRadius = kCornerRadius;
	self.layer.shadowOpacity = 0.3;
	self.layer.opacity = 0.3;
	[self.layer setShouldRasterize:YES];


	
	// Inner disc.
	rect = CGRectInset(rect, 20, 20);
	path = [UIBezierPath bezierPathWithOvalInRect:rect];
	[path fill];
	
	// Arrows.
	if (showArrows) {
		// Top.
		path = [UIBezierPath bezierPath];
		float baseWidth = 14.0;
		float height = 12.0;
		CGPoint pt = CGPointMake(rect.origin.x + ((rect.size.width / 2.0) - (baseWidth / 2.0)), rect.origin.y - (10 + (height / 2.0)));
		[path moveToPoint:pt];
		pt.x += baseWidth;
		[path addLineToPoint:pt];
		pt.x -= (baseWidth / 2.0);
		pt.y += height;
		[path addLineToPoint:pt];
		[path closePath];
		[path fill];
		
		// Bottom.
		path = [UIBezierPath bezierPath];
		pt = CGPointMake(rect.origin.x + ((rect.size.width / 2.0) - (baseWidth / 2.0)), 
						 rect.origin.y  + rect.size.height + (10 + (height / 2.0)));
		[path moveToPoint:pt];
		pt.x += baseWidth;
		[path addLineToPoint:pt];
		pt.x -= (baseWidth / 2.0);
		pt.y -= height;
		[path addLineToPoint:pt];
		[path closePath];
		[path fill];
		
		// Left.
		path = [UIBezierPath bezierPath];
		pt = CGPointMake(rect.origin.x - (10 + (height / 2.0)),
						 rect.origin.y + ((rect.size.height / 2.0) - (baseWidth / 2.0)));
		[path moveToPoint:pt];
		pt.y += baseWidth;
		[path addLineToPoint:pt];
		pt.y -= (baseWidth / 2.0);
		pt.x += height;
		[path addLineToPoint:pt];
		[path closePath];
		[path fill];
		
		// Right.
		path = [UIBezierPath bezierPath];
		pt = CGPointMake(rect.origin.x + rect.size.height + (10 + (height / 2.0)),
						 rect.origin.y + ((rect.size.height / 2.0) - (baseWidth / 2.0)));
		[path moveToPoint:pt];
		pt.y += baseWidth;
		[path addLineToPoint:pt];
		pt.y -= (baseWidth / 2.0);
		pt.x -= height;
		[path addLineToPoint:pt];
		[path closePath];
		[path fill];
	}
}


#pragma mark Accessors and properties


- (void)setColor:(UIColor *)newColor
{
	if (newColor && newColor != color) {
		color = newColor;
 	
		[self setNeedsDisplay];
	}
}


- (void)setShowArrows:(BOOL)flag
{
	if (flag != showArrows) {
		showArrows = flag;
		[self setNeedsDisplay];
	}
}


@synthesize color;
@synthesize showArrows;


@end
