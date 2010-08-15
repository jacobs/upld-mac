//
//  UPLD_MacAppDelegate.m
//  UPLD Mac
//
//  Created by Austin Gatchell on 8/13/10.
//  Copyright 2010 Austin Gatchell. All rights reserved.
//

#import "UPLD_MacAppDelegate.h"

@implementation UPLD_MacAppDelegate

@synthesize statusItem, statusItemView, statusItemMenu, preferencesWindow,
textPasteWindow, textPasteView, textPasteLabel;

- (id)init {

    if (self = [super init]) {

        [NSData_Base64 initialize];
        NSDictionary *defaults = [NSDictionary dictionaryWithObjectsAndKeys:
                                  @"http://upld.in/", @"serverDomain",
                                  @"", @"username", @"", @"password",
                                  [NSNumber numberWithBool:NO], @"checkUpdates",
                                  [NSNumber numberWithBool:NO], @"startOnLogin",
                                  [NSNumber numberWithBool:NO], @"autoScreen",
                                  nil];
        [[NSUserDefaultsController sharedUserDefaultsController]
         setInitialValues:defaults];

        successSound = [NSSound soundNamed:@"Pop"];
        failureSound = [NSSound soundNamed:@"Basso"];
    }

    return self;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {

    // Create and set up the status item
    float width = 30;
    float height = [[NSStatusBar systemStatusBar] thickness];
    NSRect viewFrame = NSMakeRect(0, 0, width, height);
    statusItemView = [[[StatusItemView alloc] initWithFrame:viewFrame
                                                 controller:self] autorelease];
    statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:width];
    [statusItem setView:statusItemView];
    statusItemMenuDelegate = [[[StatusItemMenuDelegate alloc] init]
                              autorelease];
    [statusItemMenuDelegate setController:self];
    [statusItemMenu setDelegate:statusItemMenuDelegate];

    if ([[[[NSUserDefaultsController sharedUserDefaultsController] values]
    valueForKey:@"username"] compare:@"" options:NSCaseInsensitiveSearch] ==
    NSOrderedSame ||
    [[[[NSUserDefaultsController sharedUserDefaultsController] values]
    valueForKey:@"password"] compare:@"" options:NSCaseInsensitiveSearch] ==
    NSOrderedSame) {
        [self showPreferences:self];
    } else {
        [NSApp hide:self];
    }
}

- (void)awakeFromNib {

    [textPasteWindow setContentBorderThickness:35 forEdge:NSMinYEdge];
    [textPasteView setTextContainerInset:NSMakeSize(4, 8)];
}

#pragma mark -
#pragma mark Interface Builder actions

- (IBAction)showAboutPanel:(id)sender {

    [NSApp activateIgnoringOtherApps:YES];
    [NSApp orderFrontStandardAboutPanel:self];
}

- (IBAction)showPreferences:(id)sender {
    
    [NSApp activateIgnoringOtherApps:YES];
    [preferencesWindow center];
    [preferencesWindow makeKeyAndOrderFront:self];
}

- (IBAction)showTextPaste:(id)sender {

    [NSApp activateIgnoringOtherApps:YES];
    [textPasteWindow center];
    [textPasteWindow makeKeyAndOrderFront:self];
}

- (IBAction)pasteTextAction:(id)sender {

    if ([[textPasteView string] length] > 0) {
        [self pasteText:[textPasteView string]];
    }
}


#pragma mark -
#pragma mark UPLD methods

- (void)shortenURL:(NSURL *)theURL {

    NSURL *url = [NSURL URLWithString:[NSString
                stringWithFormat:@"%@api/shorten", [[[NSUserDefaultsController
        sharedUserDefaultsController] values] valueForKey:@"serverDomain"]]];
    NSString *username = [NSData_Base64 encode:[[NSString
                                    stringWithString:[[[NSUserDefaultsController
                sharedUserDefaultsController] values] valueForKey:@"username"]]
                                    dataUsingEncoding:NSUTF8StringEncoding]];
    NSString *password = [NSData_Base64 encode:[[NSString
                                    stringWithString:[[[NSUserDefaultsController
                sharedUserDefaultsController] values] valueForKey:@"password"]]
                                    dataUsingEncoding:NSUTF8StringEncoding]];

    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setUsername:username];
    [request setPassword:password];
    [request setPostValue:theURL forKey:@"url"];
    [request setDelegate:self];
    [request startAsynchronous];
}

- (void)pasteText:(NSString *)theText {

    NSURL *url = [NSURL URLWithString:[NSString
                stringWithFormat:@"%@api/paste", [[[NSUserDefaultsController
        sharedUserDefaultsController] values] valueForKey:@"serverDomain"]]];
    NSString *username = [NSData_Base64 encode:[[NSString
                                    stringWithString:[[[NSUserDefaultsController
                sharedUserDefaultsController] values] valueForKey:@"username"]]
                                    dataUsingEncoding:NSUTF8StringEncoding]];
    NSString *password = [NSData_Base64 encode:[[NSString
                                    stringWithString:[[[NSUserDefaultsController
                sharedUserDefaultsController] values] valueForKey:@"password"]]
                                    dataUsingEncoding:NSUTF8StringEncoding]];

    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setUsername:username];
    [request setPassword:password];
    [request setPostValue:theText forKey:@"text"];
    [request setDelegate:self];
    [request startAsynchronous];
}

- (void)uploadFile:(NSString *)thePath {

    NSURL *url = [NSURL URLWithString:[NSString
                stringWithFormat:@"%@api/upload", [[[NSUserDefaultsController
        sharedUserDefaultsController] values] valueForKey:@"serverDomain"]]];
    NSString *username = [NSData_Base64 encode:[[NSString
                                    stringWithString:[[[NSUserDefaultsController
                sharedUserDefaultsController] values] valueForKey:@"username"]]
                                    dataUsingEncoding:NSUTF8StringEncoding]];
    NSString *password = [NSData_Base64 encode:[[NSString
                                    stringWithString:[[[NSUserDefaultsController
                sharedUserDefaultsController] values] valueForKey:@"password"]]
                                    dataUsingEncoding:NSUTF8StringEncoding]];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setUsername:username];
    [request setPassword:password];
    [request setFile:thePath forKey:@"file"];
    [request setDelegate:self];
    [request startAsynchronous];
}


#pragma mark -
#pragma mark ASIHTTPRequest delegate methods

- (void)requestFinished:(ASIFormDataRequest *)request
{
    NSString *responseString = [request responseString];
    NSDictionary *jsonResponse = [NSDictionary
                        dictionaryWithDictionary:[responseString JSONValue]];
    NSInteger status = [request responseStatusCode];

    if (status >= 200 && status < 300) {
        NSPasteboard *pb = [NSPasteboard generalPasteboard];
        NSArray *types = [NSArray arrayWithObjects:NSStringPboardType, nil];
        [pb declareTypes:types owner:self];
        NSString *permalink = [NSString stringWithFormat:@"%@%@",
            [[[NSUserDefaultsController sharedUserDefaultsController] values]
                                valueForKey:@"serverDomain"],
                        [jsonResponse objectForKey:@"permalink"]];
        [pb setString:permalink forType:NSStringPboardType];
        if ([[jsonResponse objectForKey:@"type"] compare:@"text"
        options:NSLiteralSearch] == NSOrderedSame)
            [textPasteView setString:@""];
        [successSound play];
    } else {
        [failureSound play];
    }

    [[statusItemView statusOverlayView] setActive:NO];
}

- (void)requestFailed:(ASIFormDataRequest *)request
{
    NSError *error = [request error];
    NSLog(@"%@", error);
    [[statusItemView statusOverlayView] setActive:NO];
    [failureSound play];
}

@end
