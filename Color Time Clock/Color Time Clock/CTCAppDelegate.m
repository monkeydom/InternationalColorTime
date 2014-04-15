//
//  CTCAppDelegate.m
//  Color Time Clock
//
//  Created by Dominik Wagner on 13.04.14.
//  Copyright (c) 2014 TheCodingMonkeys. All rights reserved.
//

#import "CTCAppDelegate.h"
#import "CTCUpdateHelper.h"
@import Quartz;
#import "CTCReference.h"

@interface CTCAppDelegate ()
@property (strong) IBOutlet NSTextField *menuExtraTextField;
@property (strong) IBOutlet NSTextField *menuExtraLeftTextField;
@property (nonatomic, strong) NSStatusItem *statusItem;
@property (strong) IBOutlet NSView *menuExtraView;
@property (strong) IBOutlet NSImageView *menuExtraImageView;
@property (strong) IBOutlet NSMenuItem *topStatusItemMenuItem;
@property (strong) IBOutlet NSMenu *statusItemMenu;
@end

@implementation CTCAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {

	
	[CTCUpdateHelper executeBlock:^{
		//		NSLog(@"%s min %0.6f",__FUNCTION__,[NSDate timeIntervalSinceReferenceDate]);
		[self updateDisplayForDate:[NSDate date]];
	} andScheduleWithGranulatrity:kCTCUpdateGranularityMinutes];

	
	NSStatusBar *bar = [NSStatusBar systemStatusBar];
	self.statusItem = ({
		NSStatusItem *item = [bar statusItemWithLength:NSVariableStatusItemLength];
		item.view = self.menuExtraView;
		//item.title = @"blahblah";
		item.menu = self.statusItemMenu;
		[item setTarget:self];
		[item setAction:@selector(menuItemAction:)];
		[item setHighlightMode:YES];
		item;
	});

	/*
	__block NSTimeInterval now = [NSDate timeIntervalSinceReferenceDate];
	[CTCUpdateHelper executeBlock:^{
		now += 60.0;
		NSLog(@"%s min %0.6f",__FUNCTION__,[NSDate timeIntervalSinceReferenceDate]);
		[self updateDisplayForDate:[NSDate dateWithTimeIntervalSinceReferenceDate:now]];
	} andScheduleWithGranulatrity:kCTCUpdateGranularityTenth];
	/**/
}

- (BOOL)applicationOpenUntitledFile:(NSApplication *)sender {
	[self.window makeKeyAndOrderFront:self];
	return YES;
}

- (IBAction)menuItemAction:(id)aSender {
	//	NSLog(@"%s %@",__FUNCTION__,aSender);
	[self.window makeKeyAndOrderFront:self];
}

- (void)updateDisplayForDate:(NSDate *)aDate {
	
	NSImage *result = [NSImage imageWithSize:NSMakeSize(1024, 1024) flipped:YES drawingHandler:^BOOL(NSRect dstRect) {
		CGContextRef context = [[NSGraphicsContext currentContext] graphicsPort];
		CGContextClearRect(context, dstRect);
		CGFloat outside = 220.;
		[CTCReference drawHourRingInRect:dstRect width:outside context:context date:aDate];
		[CTCReference drawClockInRect:NSRectToCGRect(NSInsetRect(dstRect,outside,outside))
							  context:context
								 date:aDate];
		return YES;
	}];
	[[NSApplication sharedApplication] setApplicationIconImage:result];
	self.clockImageView.image = result;
	//	self.statusItem.image = result;

	NSImage *statusResult = [NSImage imageWithSize:NSMakeSize(16, 16) flipped:YES drawingHandler:^BOOL(NSRect dstRect) {
		CGContextRef context = [[NSGraphicsContext currentContext] graphicsPort];
		CGContextClearRect(context, dstRect);
		[CTCReference drawClockInRect:NSRectToCGRect(NSInsetRect(dstRect,1,1))
							  context:context
								 date:aDate];
		return YES;
	}];

	
	self.menuExtraImageView.image = statusResult;
	NSDateComponents *components = [CTCReference UTCDateComponentsForDate:aDate];
	self.menuExtraLeftTextField.stringValue = [CTCReference nameForHour:components.hour];
	self.menuExtraTextField.stringValue = [CTCReference nameForHour:(components.hour + 1) % 24];
	NSString *timeString = [CTCReference timeStringForDate:aDate];
	self.topStatusItemMenuItem.title = timeString;
	self.leftLabel.stringValue = timeString;
	self.rightLabel.objectValue = aDate;
	
}
@end
