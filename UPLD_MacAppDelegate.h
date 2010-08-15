//
//  UPLD_MacAppDelegate.h
//  UPLD Mac
//
//  Created by Austin Gatchell on 8/13/10.
//  Copyright 2010 Austin Gatchell. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ASIFormDataRequest.h"
#import "JSON.h"
#import "NSData+Base64.h"
#import "StatusItemView.h"
#import "StatusItemMenuDelegate.h"

@class StatusItemView, StatusItemMenuDelegate;

@interface UPLD_MacAppDelegate : NSObject {
	NSStatusItem *statusItem;
	StatusItemView *statusItemView;
    NSMenu *statusItemMenu;
    StatusItemMenuDelegate *statusItemMenuDelegate;
    NSWindow *preferencesWindow;
    NSWindow *textPasteWindow;
    NSTextView *textPasteView;
    NSTextField *textPasteLabel;

	NSURLConnection *connection;
	NSMutableData *responseData;
	NSHTTPURLResponse *httpResponse;

    NSSound *successSound;
    NSSound *failureSound;
}

@property (assign) NSStatusItem *statusItem;
@property (assign) StatusItemView *statusItemView;
@property (assign) IBOutlet NSMenu *statusItemMenu;
@property (assign) IBOutlet NSWindow *preferencesWindow;
@property (assign) IBOutlet NSWindow *textPasteWindow;
@property (assign) IBOutlet NSTextView *textPasteView;
@property (assign) IBOutlet NSTextField *textPasteLabel;

// Interface Builder actions
- (IBAction)showAboutPanel:(id)sender;
- (IBAction)showPreferences:(id)sender;
- (IBAction)showTextPaste:(id)sender;
- (IBAction)pasteTextAction:(id)sender;

// UPLD methods
- (void)shortenURL:(NSURL *)theURL;
- (void)pasteText:(NSString *)theText;
- (void)uploadFile:(NSString *)thePath;

@end
