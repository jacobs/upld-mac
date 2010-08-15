//
//  StatusItemMenuDelegate.h
//  UPLD Mac
//
//  Created by Austin Gatchell on 8/13/10.
//  Copyright 2010 Austin Gatchell. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "UPLD_MacAppDelegate.h"

@class UPLD_MacAppDelegate;

@interface StatusItemMenuDelegate : NSObject {

    id controller;
}

@property (assign) id controller;

@end
