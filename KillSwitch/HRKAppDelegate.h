//
//  HRKAppDelegate.h
//  KillSwitch
//
//  Created by hrk on 11-12-13.
//  Copyright (c) 2013 hrk. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Matatino/Matatino.h>
#import "PrefWindowController.h"

@interface HRKAppDelegate : NSObject <NSApplicationDelegate, MatatinoDelegate>{
	IBOutlet NSMenu *statusMenu;
	NSStatusItem *statusItem;
	NSImage *statusImage_on;
	NSImage *statusImage_off;
	NSImage *statusImage_disabled;
	NSString *deviceName;
	NSString *networkName;
	Matatino *arduino;
	BOOL arduinoConnected;
	BOOL internetConnected;
	NSTimer *nTimer;
}

@property (nonatomic, retain) IBOutlet PrefWindowController *prefVC;

- (IBAction)updateArduinoStatus:(id)sender;
- (NSArray*)getSerialDevices;
- (void)prefsLoaded:(NSString *)serialDevice network:(NSString*)networkDevice;

@property (assign) IBOutlet NSWindow *window;
@property BOOL internetConnected;
@property Matatino* arduino;

@end
