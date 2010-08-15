//
//  StatusItemView.h
//  UPLD Mac
//
//  Created by Austin Gatchell on 8/13/10.
//  Copyright 2010 Austin Gatchell. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "UPLD_MacAppDelegate.h"
#import "StatusOverlayView.h"

@class UPLD_MacAppDelegate, StatusOverlayView;

@interface StatusItemView : NSView {

    id controller;
    BOOL clicked;

    StatusOverlayView *statusOverlayView;

    NSImage *statusImage;
    NSImage *statusImageAlt;

    NSArray *dragTypes;
}

@property (readwrite, assign) BOOL clicked;
@property (readonly, assign) StatusOverlayView *statusOverlayView;

- (id)initWithFrame:(NSRect)frame controller:(id)theController;

@end
