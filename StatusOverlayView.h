//
//  StatusOverlayView.h
//  UPLD Mac
//
//  Created by Austin Gatchell on 8/13/10.
//  Copyright 2010 Austin Gatchell. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "StatusItemView.h"

@interface StatusOverlayView : NSView {
    
	BOOL active;
    
	NSImage *statusImageActive;
}

@property (readwrite, assign) BOOL active;

- (id)initWithFrame:(NSRect)frame;

@end
