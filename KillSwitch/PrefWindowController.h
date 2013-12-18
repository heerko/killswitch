//
//  PrefWindowController.h
//  KillSwitch
//
//  Created by hrk on 17-12-13.
//  Copyright (c) 2013 hrk. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface PrefWindowController : NSWindowController{
	NSArray *devices;
//	NSString *currentArduinoDevice;
//	NSString *currentNetworkDevice;
	NSUserDefaults* defaults;
	
}
@property (weak) IBOutlet NSPopUpButton *serialDeviceNames;
@property (weak) IBOutlet NSTextField *networkDeviceName;
@property NSString *serialDevice;
@property NSString *networkDevice;

@end
