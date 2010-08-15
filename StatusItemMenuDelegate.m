//
//  StatusItemMenuDelegate.m
//  UPLD Mac
//
//  Created by Austin Gatchell on 8/13/10.
//  Copyright 2010 Austin Gatchell. All rights reserved.
//

#import "StatusItemMenuDelegate.h"

@implementation StatusItemMenuDelegate

@synthesize controller;

- (void)menuDidClose:(NSMenu *)menu {
    
    [[controller statusItemView] setClicked:NO];
    [[controller statusItemView] setNeedsDisplay:YES];
}

@end
