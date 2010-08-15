//
//  StatusItemView.m
//  UPLD Mac
//
//  Created by Austin Gatchell on 8/13/10.
//  Copyright 2010 Austin Gatchell. All rights reserved.
//

#import "StatusItemView.h"

@implementation StatusItemView

@synthesize clicked, statusOverlayView;

- (id)initWithFrame:(NSRect)frame controller:(id)theController {

    if (self = [super initWithFrame:frame]) {

        controller = theController;
        clicked = NO;

        statusImage = [[[NSImage alloc] initWithContentsOfFile:[[NSBundle
            mainBundle] pathForResource:@"status" ofType:@"png"]] autorelease];
        statusImageAlt = [[[NSImage alloc] initWithContentsOfFile:[[NSBundle
            mainBundle] pathForResource:@"status-alt" ofType:@"png"]]
                          autorelease];

        dragTypes = [NSArray arrayWithObjects:NSFilenamesPboardType,
                     NSStringPboardType, nil];
        [self registerForDraggedTypes:dragTypes];

		statusOverlayView = [[StatusOverlayView alloc] initWithFrame:frame];
		[self addSubview:statusOverlayView];
    }

    return self;
}

- (void)drawRect:(NSRect)dirtyRect {

    NSPoint pt = NSMakePoint(7, 3);
    NSRect rect = NSMakeRect(0, 0, 16, 16);

    if (clicked) {
        [[controller statusItem] drawStatusBarBackgroundInRect:[[controller
                                    statusItemView] frame] withHighlight:YES];
        [statusImageAlt drawAtPoint:pt fromRect:rect
                          operation:NSCompositeSourceOver fraction:1.0];
    } else {
        [statusImage drawAtPoint:pt fromRect:rect
                       operation:NSCompositeSourceOver fraction:1.0];
    }

	if ([statusOverlayView active] == YES) {
        
		if ([[statusOverlayView animator] alphaValue] <= 0) {
			[NSAnimationContext beginGrouping];
			[[NSAnimationContext currentContext] setDuration:0.8f];
            
			[[statusOverlayView animator] setAlphaValue:1.0];
            
			[NSAnimationContext endGrouping];
		} else if ([[statusOverlayView animator] alphaValue] >= 1.0) {
			[NSAnimationContext beginGrouping];
			[[NSAnimationContext currentContext] setDuration:0.8f];
            
			[[statusOverlayView animator] setAlphaValue:0];
            
			[NSAnimationContext endGrouping];
		}
	}
}

- (void)mouseDown:(NSEvent *)theEvent {

    clicked = YES;
    [self setNeedsDisplay:YES];
    [[controller statusItem] popUpStatusItemMenu:[controller statusItemMenu]];
}

- (NSDragOperation)draggingEntered:(id <NSDraggingInfo>)sender {

	if ([statusOverlayView active] == NO) {

		if ((NSDragOperationCopy & [sender draggingSourceOperationMask]) ==
        NSDragOperationCopy) {
			return NSDragOperationCopy;
		} else {
			return NSDragOperationNone;
		}
	}

	return NSDragOperationNone;
}

- (NSDragOperation)draggingUpdated:(id <NSDraggingInfo>)sender {

	if ([statusOverlayView active] == NO) {

		if ((NSDragOperationCopy & [sender draggingSourceOperationMask]) ==
        NSDragOperationCopy) {
			return NSDragOperationCopy;
		} else {
			return NSDragOperationNone;
		}
	}

	return NSDragOperationNone;
}

- (BOOL)prepareForDragOperation:(id <NSDraggingInfo>)sender {

	if ([statusOverlayView active] == NO) {
		return YES;
    }
	else {
		return NO;
    }
}

- (BOOL)performDragOperation:(id <NSDraggingInfo>)sender {

	if ([statusOverlayView active] == NO) {

		NSPasteboard *paste = [sender draggingPasteboard];
		NSString *desiredType = [paste availableTypeFromArray:dragTypes];

        if ([[[[NSUserDefaultsController sharedUserDefaultsController] values]
        valueForKey:@"username"] compare:@"" options:NSCaseInsensitiveSearch] !=
        NSOrderedSame &&
        [[[[NSUserDefaultsController sharedUserDefaultsController] values]
        valueForKey:@"password"] compare:@"" options:NSCaseInsensitiveSearch] !=
        NSOrderedSame) {
            if (desiredType == NSStringPboardType) {

                [statusOverlayView setActive:YES];
                [statusOverlayView setNeedsDisplay:YES];
                NSURL *url = [NSURL URLWithString:[paste
                                            stringForType:NSStringPboardType]];
                if ([url host]) {
                    [controller shortenURL:url];
                    NSLog(@"URL: %@", [url path]);
                    return YES;
                }
                [controller pasteText:[paste stringForType:NSStringPboardType]];
                NSLog(@"Text: %@", [paste stringForType:NSStringPboardType]);
                return YES;
            } else if (desiredType == NSFilenamesPboardType) {

                [statusOverlayView setActive:YES];
                [statusOverlayView setNeedsDisplay:YES];
                [controller uploadFile:[[paste
                            propertyListForType:NSFilenamesPboardType]
                            objectAtIndex:0]];
                NSLog(@"File: %@", [[paste
                                     propertyListForType:NSFilenamesPboardType]
                                    objectAtIndex:0]);
                return YES;
            }
        } else {
            return NO;
        }
	}

	return NO;
}

@end
