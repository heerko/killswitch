//
//  PrefWindowController.m
//  KillSwitch
//
//  Created by hrk on 11-12-13.
//  Copyright (c) 2013 hrk. All rights reserved.
//

#import "PrefWindowController.h"
#import "HRKAppDelegate.h"

@implementation PrefWindowController

@synthesize serialDeviceNames;
@synthesize theWindow;
@synthesize networkDeviceName;

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
		NSLog(@"Window opened");
		theWindow = window;
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(windowDidBecomeKey:) name:NSWindowDidBecomeKeyNotification object:window];
	}
    return self;
}

-(void) windowDidBecomeKey:(id)sender{
	NSLog(@"key");
	NSApplication *myApp = [NSApplication sharedApplication];
	[myApp activateIgnoringOtherApps:YES];
	[self.window orderFrontRegardless];
	[self populateDeviceMenu];
}

-(void)populateDeviceMenu{
	devices = [(HRKAppDelegate *)[[NSApplication sharedApplication]delegate] getSerialDevices];
	NSLog(@"%@", devices);
	for (id device in devices) {
		[serialDeviceNames addItemWithTitle:device];
	}
	[serialDeviceNames calcSize];
}

- (BOOL)windowShouldClose:(id)sender{
	NSLog(@"%@ closed", sender);
	return YES;
}

- (IBAction)changeArduinoDeviceName:(id)sender {
	NSString *deviceName = [sender title];
	NSLog(@"%@", deviceName);
}

- (IBAction)changeNetworkDeviceName:(id)sender {
	NSLog(@"%@", [sender stringValue]);
}


- (void)windowDidLoad
{
    [super windowDidLoad];
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

- (void)close{
	NSLog(@"Closed prefwindow");
}
@end
