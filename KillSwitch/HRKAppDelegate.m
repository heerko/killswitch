//
//  HRKAppDelegate.m
//  KillSwitch
//
//  Created by hrk on 11-12-13.
//  Copyright (c) 2013 hrk. All rights reserved.
//

#import "HRKAppDelegate.h"
#import "Matatino/AMSerialPort.h"

@implementation HRKAppDelegate

@synthesize internetConnected;
@synthesize arduino;

-(void) applicationDidFinishLaunching:(NSNotification *)notification{
	arduino = [[Matatino alloc] initWithDelegate:self];
	NSLog(@"%@", [arduino deviceNames]);
	deviceName = @"/dev/cu.usbserial-A9007TWl";
	[self connectArduino];
}

- (void) awakeFromNib{
	statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength] ;
	NSBundle *bundle = [NSBundle mainBundle];
	statusImage = [[NSImage alloc] initWithContentsOfFile:[bundle pathForResource:@"switchdisabled" ofType:@"png"]];
	statusHighlightImage = [[NSImage alloc] initWithContentsOfFile:[bundle pathForResource:@"switchhighlight" ofType:@"png"]];
	[statusItem setImage:statusImage];
	[statusItem setAlternateImage:statusHighlightImage];
	[statusItem setMenu:statusMenu];
	[statusItem setToolTip:@"KillSwitch yo internetz!"];
	[statusItem setHighlightMode:YES];
}


- (NSArray*)getSerialDevices{
	return [arduino deviceNames];
}

- (IBAction)updateArduinoStatus:(id)sender{
	if( [arduino isConnected] ){
		[self disconnectArduino];
	} else {
		[self connectArduino];
	}
	[self updateMenuIcon];
}


- (void) receivedString:(NSString *)rx {
	NSLog(@"Received string! %@", rx);
	
	NSTask *task;
	task = [[NSTask alloc] init];
	[task setLaunchPath: @"/usr/sbin/networksetup"];
	
	NSMutableArray *arguments;
	arguments = [NSMutableArray arrayWithObjects: @"-setairportpower", @"en1", nil];
	[task setArguments: arguments];
		
	if( [rx isEqual: @"l"] ){
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

- (void) portAdded:(NSArray *)ports {
}

- (void) portRemoved:(NSArray *)ports {
	NSLog(@"%@", ports);
	for (id port in ports) {
		// do something with object
		if ( [port isEqualToString: deviceName] ){
			[[arduino port] free];
			[self updateMenuIcon];
			//arduino = [[Matatino alloc] initWithDelegate:self];
		}
	}
}

- (void) portClosed {
	[self updateMenuIcon];
}

- (void) dealloc{
	[self disconnectArduino];
}

- (void) applicationWillTerminate:(NSNotification *)notification{
	[self disconnectArduino];
}

- (NSApplicationTerminateReply) applicationShouldTerminate:(NSApplication *)sender {
	// Safely disconnect
	[self disconnectArduino];
	return NSTerminateNow;
}

- (void) disconnectArduino{
	if( [arduino isConnected] ){
		NSLog(@"Disconnecting...");
		[arduino disconnect];
	}
	[self updateMenuIcon];
}

- (void) connectArduino{
	if( ![arduino isConnected]){
		// Connect to your device with 9600 baud
        if([arduino connect:deviceName withBaud:B9600]) {
            NSLog(@"Connection success!");
        } else {
            NSLog(@"Connection fail");
        }
	} else {
		NSLog(@"Arduino is already connected");
	}
	[self updateMenuIcon];
}

- (void) updateMenuIcon{
//	statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength] ;
	NSBundle *bundle = [NSBundle mainBundle];
	
	if( [arduino isConnected] ){
		[[statusMenu itemAtIndex:0] setTitle: @"Disconnect from Switch"];
		if ( internetConnected ){
			statusImage = [[NSImage alloc] initWithContentsOfFile:[bundle pathForResource:@"switch" ofType:@"png"]];
		} else {
			statusImage = [[NSImage alloc] initWithContentsOfFile:[bundle pathForResource:@"switchon" ofType:@"png"]];
		}
	} else {
		statusImage = [[NSImage alloc] initWithContentsOfFile:[bundle pathForResource:@"switchdisabled" ofType:@"png"]];
		[[statusMenu itemAtIndex:0] setTitle: @"Connect to Switch"];
	}
	[statusItem setImage:statusImage];
}

@end