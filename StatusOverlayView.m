//
//  StatusOverlayView.m
//  UPLD Mac
//
//  Created by Austin Gatchell on 8/13/10.
//  Copyright 2010 Austin Gatchell. All rights reserved.
//

#import "StatusOverlayView.h"

@implementation StatusOverlayView

@synthesize active;

- (id)initWithFrame:(NSRect)frame {

	if (self = [super initWithFrame:frame]) {

        statusImageActive = [[[NSImage alloc] initWithContentsOfFile:[[NSBundle
            mainBundle] pathForResource:@"status-active" ofType:@"png"]]
                             autorelease];

		[self setAlphaValue:0];
	}

	return self;
}

- (void)dealloc {

	[statusImageActive release];
	[super dealloc];
}

- (void)drawRect:(NSRect)dirtyRect {

	NSPoint pt = NSMakePoint(7, 3);
	NSRect rect = NSMakeRect(0, 0, 16, 16);

	[statusImageActive drawAtPoint:pt fromRect:rect
                         operation:NSCompositeSourceOver fraction:1.0];

	if (active == NO && [self alphaValue] >= 1.0) {

		[NSAnimationContext beginGrouping];
		[[NSAnimationContext currentContext] setDuration:0.8f];
        [[self animator] setAlphaValue:0];
        [NSAnimationContext endGrouping];
	}
}

@end
