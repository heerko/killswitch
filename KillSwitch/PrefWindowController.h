//
//  PrefWindowController.h
//  KillSwitch
//
//  Created by hrk on 11-12-13.
//  Copyright (c) 2013 hrk. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface PrefWindowController : NSWindowController{
	NSArray *devices;
}
@property (weak) IBOutlet NSPopUpButton *serialDeviceNames;
@property (weak) IBOutlet NSTextField *networkDeviceName;
@property (unsafe_unretained) IBOutlet NSWindow *closePrefWindow;
@property NSWindow *theWindow;

@end
