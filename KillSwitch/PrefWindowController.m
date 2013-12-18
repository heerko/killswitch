//
//  PrefWindowController.m
//  KillSwitch
//
//  Created by hrk on 17-12-13.
//  Copyright (c) 2013 hrk. All rights reserved.
//

#import "PrefWindowController.h"
#import "HRKAppDelegate.h"



@interface PrefWindowController ()

@end

@implementation PrefWindowController

@synthesize serialDeviceNames;
@synthesize networkDeviceName;
@synthesize serialDevice;
@synthesize networkDevice;


- (id)initWithWindow:(NSWindow *)window
{
	NSLog(@"init %@", window );
    self = [super initWithWindow:window];
    if (self) {
		defaults = [NSUserDefaults standardUserDefaults];
		[self showWindow:nil];
		[self getDefaults];
    }
    return self;
}

- (void) awakeFromNib{
	NSLog( @"awake" );
}

- (void)windowDidLoad {
	NSLog(@"window did load.");
//	[self getDefaults];
    [super windowDidLoad];
	[self.window makeKeyAndOrderFront:self];
}

-(void)showWindow:(id)sender{
	NSLog( @"show %@", self.window);
	[super showWindow:sender];
	[self.window makeKeyAndOrderFront:nil];
	[NSApp activateIgnoringOtherApps:YES];
}

-(void) windowDidBecomeKey:(id)sender{
	[self populateDeviceMenu];
}

- (BOOL)windowShouldClose:(id)sender{
	[self changeArduinoDeviceName:serialDeviceNames];
	[self changeNetworkDeviceName:networkDeviceName];
	return YES;
}

-(void)populateDeviceMenu{
	devices = [(HRKAppDelegate *)[[NSApplication sharedApplication]delegate] getSerialDevices];

	for (id device in devices) {
		[serialDeviceNames addItemWithTitle:device];
	}
	if( ! [devices containsObject:serialDevice] ){
		NSLog(@"current device not found");
		networkDevice = NULL;
		[self showWindow:self];
	} else {
		[serialDeviceNames selectItemWithTitle:serialDevice];
	}
	[serialDeviceNames calcSize];
}

- (IBAction)changeArduinoDeviceName:(id)sender {
	serialDevice = [sender title];
	[defaults setObject:serialDevice forKey:@"KillSwitchDeviceName"];
	[defaults synchronize];
}

- (IBAction)changeNetworkDeviceName:(id)sender {
	networkDevice = [sender stringValue];
	[defaults setObject:networkDevice forKey:@"NetworkDeviceName"];
	[defaults synchronize];
}

- (void) getDefaults{
	serialDevice = [defaults stringForKey:@"KillSwitchDeviceName"];
	networkDevice = [defaults stringForKey:@"NetworkDeviceName"];
	NSLog( @"%@ / %@", serialDevice, networkDevice);
	
	if ( serialDevice == NULL || networkDevice == NULL ){
		NSLog(@"Show pref window %@", self.window);
		// TODO: this doesn't work somehow.
		[self showWindow:nil];
	}
	[(HRKAppDelegate *)[[NSApplication sharedApplication]delegate] prefsLoaded:serialDevice network:networkDevice];
}

@end
