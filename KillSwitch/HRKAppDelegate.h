//
//  HRKAppDelegate.h
//  KillSwitch
//
//  Created by hrk on 11-12-13.
//  Copyright (c) 2013 hrk. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Matatino/Matatino.h>

@interface HRKAppDelegate : NSObject <NSApplicationDelegate, MatatinoDelegate>{
	IBOutlet NSMenu *statusMenu;
	NSStatusItem *statusItem;
	NSImage *statusImage;
	NSImage *statusHighlightImage;
	NSString *deviceName;
	Matatino *arduino;
	BOOL internetConnected;
}

- (IBAction)updateArduinoStatus:(id)sender;
- (NSArray*)getSerialDevices;

@property (assign) IBOutlet NSWindow *window;
@property BOOL internetConnected;
@property Matatino* arduino;

@end
