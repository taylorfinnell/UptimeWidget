//
//  ByteopiaAppDelegate.h
//  UptimeWidget
//
//  Created by Taylor Finnell on 12/11/13.
//  Copyright (c) 2013 Byteopia. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ByteopiaAppDelegate : NSObject <NSApplicationDelegate> {
	NSStatusItem *trayItem;
}

@property (assign) IBOutlet NSWindow *window;

@end
