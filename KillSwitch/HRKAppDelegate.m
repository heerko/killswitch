//
//  HRKAppDelegate.m
//  KillSwitch
//
//  Created by hrk on 11-12-13.
//  Copyright (c) 2013 hrk. All rights reserved.
//

#import "HRKAppDelegate.h"
#import "Matatino/AMSerialPort.h"
#import "PrefWindowController.h"

@implementation HRKAppDelegate {
}

@synthesize internetConnected;
@synthesize arduino;
@synthesize window;

/** Application callbacks **/
-(void) applicationDidFinishLaunching:(NSNotification *)notification{
	arduino = [[Matatino alloc] initWithDelegate:self];
	internetConnected = YES; // assume we're connected
	NSLog(@"get defaults");
	[[self prefVC] getDefaults];
}

- (void)applicationWillFinishLaunching:(NSNotification *)aNotification{
	self.prefVC = [[PrefWindowController alloc] initWithWindowNibName:@"PrefWindowController"];
}

- (void) awakeFromNib{
	[self initMenuIcon];
}

- (NSApplicationTerminateReply) applicationShouldTerminate:(NSApplication *)sender {
	// Safely disconnect
	[self disconnectArduino];
	return NSTerminateNow;
}

- (void) dealloc{
	[self disconnectArduino];
}

- (void) applicationWillTerminate:(NSNotification *)notification{
	[self disconnectArduino];
}

/** IB actions **/

- (IBAction)updateArduinoStatus:(id)sender{
	if( [arduino isConnected] ){
		[self disconnectArduino];
	} else {
		[self connectArduino];
	}
	[self updateMenuIcon];
}

-(void)prefsLoaded:(NSString *)serialDevice network:(NSString*)networkDevice{
	NSString *oldDeviceName = deviceName;
	deviceName = serialDevice;
	networkName = networkDevice;
	if( ![deviceName isEqualToString:oldDeviceName] ){
		if( [arduino isConnected] ){
			[self disconnectArduino];
		}
		[self connectArduino];
	}
}

-(IBAction)openPrefWindow:(id)sender{
	[[self prefVC] showWindow:nil];
}

/** Arduino / Matatino stuff **/

- (NSArray*)getSerialDevices{
	return [arduino deviceNames];
}

- (void) receivedString:(NSString *)rx {
	if([rx isEqualToString:@"c"]){
		// arduino sends a 'c' on startup. We wait for this
		// as confirmation.
		arduinoConnected = YES;
		[self updateMenuIcon];
		[nTimer invalidate];
	} else {
		[self setNetworkStatus:rx];
	}
}

- (void) portAdded:(NSArray *)ports {
}

- (void) portRemoved:(NSArray *)ports {
	for (id port in ports) {
		// do something with object
		if ( [port isEqualToString: deviceName] ){
			NSLog( @"%@ / %@", ports, deviceName);
			[[arduino port] free];
			//arduino = [[Matatino alloc] initWithDelegate:self];
			[self updateMenuIcon];
			arduinoConnected = NO;
			//arduino = [[Matatino alloc] initWithDelegate:self];
		}
	}
}

- (void) portClosed {
	arduinoConnected = NO;
	[self updateMenuIcon];
}

- (void) disconnectArduino{
	if( [arduino isConnected] ){
		NSLog(@"Disconnecting...");
		[arduino disconnect];
		arduinoConnected = NO;
	}
	[self updateMenuIcon];
}

- (void) connectArduino{
	if( ! [arduino isConnected] ){
		NSLog(@"Attempting to connect to %@", deviceName);
		// Connect to your device with 9600 baud
        if([arduino connect:deviceName withBaud:B9600]) {
            NSLog(@"Connection success!");
			
			// if we don't get a 'c' over serial within 4s assume we didn't connect to an arduino.
			nTimer = [NSTimer scheduledTimerWithTimeInterval:4.0f target:self selector:@selector(didTimeout) userInfo:nil repeats:NO];
		} else {
            NSLog(@"Connection fail");
			[self openPrefWindow:nil];
        }
	} else {
		NSLog(@"Arduino is already connected");
	}
	[self updateMenuIcon];
}

- (void)didTimeout{
	arduinoConnected = NO;
	[self updateMenuIcon];
	NSAlert *alert = [[NSAlert alloc] init];
	[alert addButtonWithTitle:@"OK"];
	[alert setMessageText:@"Please select a Kill Switch Device"];
	[alert setInformativeText:@"The name usually starts with /dev/tty.usbmodem*** or similar."];
	[alert setAlertStyle:NSWarningAlertStyle];
	if ([alert runModal] == NSAlertFirstButtonReturn) {
		[self openPrefWindow:nil];
	}

}

/** Set the networkstatus based on string **/
 - (void) setNetworkStatus:( NSString * )state {
	 NSTask *task;
	 task = [[NSTask alloc] init];
	 [task setLaunchPath: @"/usr/sbin/networksetup"];
	 
	 NSMutableArray *arguments;
	 arguments = [NSMutableArray arrayWithObjects: @"-setairportpower", networkName, nil];
	 [task setArguments: arguments];
	 
	 if( [state isEqual: @"l"] ){
		 [arguments addObject: @"off"];
		 internetConnected = NO;
	 } else {
		 [arguments addObject: @"on"];
		 internetConnected = YES;
	 }
	 [task setArguments: arguments];
	 [task launch];
	 
	 [self updateMenuIcon];
 }


/** Initialize the menu bar icon **/
- (void) initMenuIcon{
	statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength] ;
	NSBundle *bundle = [NSBundle mainBundle];
	statusImage_disabled = [[NSImage alloc] initWithContentsOfFile:[bundle pathForResource:@"switch_disabled" ofType:@"png"]];
	statusImage_on = [[NSImage alloc] initWithContentsOfFile:[bundle pathForResource:@"switch_on" ofType:@"png"]];
	statusImage_off = [[NSImage alloc] initWithContentsOfFile:[bundle pathForResource:@"switch_off" ofType:@"png"]];
	[statusItem setImage:statusImage_disabled];
	[statusItem setMenu:statusMenu];
	[statusItem setToolTip:@"KillSwitch yo internetz!"];
	[statusItem setHighlightMode:YES];
}

/** Update the menu bar icon after a status change **/
- (void) updateMenuIcon{
	if( arduinoConnected ){
		[[statusMenu itemAtIndex:0] setTitle: @"Disconnect from Switch"];
		if ( internetConnected ){
			[statusItem setImage:statusImage_off];
		} else {
			[statusItem setImage:statusImage_on];
		}
	} else {
		[statusItem setImage:statusImage_disabled];
		[[statusMenu itemAtIndex:0] setTitle: @"Connect to Switch"];
	}
}

@end