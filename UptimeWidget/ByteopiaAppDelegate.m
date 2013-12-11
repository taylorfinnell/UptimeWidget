//
//  ByteopiaAppDelegate.m
//  UptimeWidget
//
//  Created by Taylor Finnell on 12/11/13.
//  Copyright (c) 2013 Byteopia. All rights reserved.
//

#import "ByteopiaAppDelegate.h"
#include <sys/types.h>
#include <sys/sysctl.h>

@implementation ByteopiaAppDelegate

- (IBAction)quitAction:(id)sender; {
	[NSApp terminate:sender];
}

- (IBAction)testAction:(id)sender; {
	[_window makeKeyAndOrderFront:self];
    [NSApp activateIgnoringOtherApps:YES];
}

- (void)updateStatus {
    int mib[2];
    size_t size;
    struct timeval  boottime;
    
    mib[0] = CTL_KERN;
    mib[1] = KERN_BOOTTIME;
    size = sizeof(boottime);
    if (sysctl(mib, 2, &boottime, &size, NULL, 0) != -1)
    {
        NSDate* bootDate = [NSDate dateWithTimeIntervalSince1970:
                            boottime.tv_sec + boottime.tv_usec / 1.e6];
        
        NSDate *now = [[NSDate alloc] init];
        
        NSTimeInterval diff = [now timeIntervalSinceDate:bootDate];
        
        double days = floor(diff / 86400);
        diff -= (days * 86400);
        double hours = floor(diff / 3600);
        diff -= (hours * 3600);
        double minutes = floor(diff / 60);
        diff -= (minutes * 60);
       
        NSString* title = @"";
        if(days != 0){
            title = [NSString stringWithFormat:@"%id %im", (int)days, (int)hours];
        }else {
            title = [NSString stringWithFormat:@"%ih %im", (int)hours, (int)minutes];
        }
        
        [trayItem setTitle:(title)];
    }
}

- (void)timerTick:(id)timer {
    [self updateStatus];
}

- (void)applicationDidFinishLaunching:(NSNotification *)y; {
	NSZone *zone = [NSMenu menuZone];
	NSMenu *menu = [[NSMenu allocWithZone:zone] init];
	NSMenuItem *item;
    
	item = [menu addItemWithTitle:@"Quit" action:@selector(quitAction:) keyEquivalent:@""];
	[item setTarget:self];
    
	trayItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSSquareStatusItemLength];
	[trayItem setMenu:menu];
	[trayItem setHighlightMode:YES];
	[trayItem setTitle:@"HH:MM"];
    
    NSDictionary *attributes = @{
                                 NSFontAttributeName: [NSFont fontWithName:@"Arial" size:8.0],
                                 NSForegroundColorAttributeName: [NSColor blackColor]
                                 };
    
    NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:[trayItem title] attributes:attributes];
    [trayItem setAttributedTitle:attributedTitle];
    [trayItem setLength:(70.0f)];
    
    [NSTimer scheduledTimerWithTimeInterval:60.0 target:self selector:@selector(timerTick:) userInfo:nil repeats:YES];
    
    [self updateStatus];
    
    [_window orderOut:self];
}

@end