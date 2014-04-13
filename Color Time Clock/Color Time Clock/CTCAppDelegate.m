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

@implementation CTCAppDelegate

+ (void)drawClockInRect:(CGRect)aRect context:(CGContextRef)aContext date:(NSDate *)aDate {
	// extract the necessary information
	static NSCalendar *calendar = nil;
	if (!calendar) {
		calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
		[calendar setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
		// UTC does not have daylight saving time, which is what we need here
	}
    NSDateComponents *utcComponents = [calendar components:(NSHourCalendarUnit| NSMinuteCalendarUnit) fromDate:aDate];
    
    NSInteger currentHour = [utcComponents hour];
    NSInteger nextHour = (currentHour + 1) % 24;

	CGFloat percentFill = [utcComponents minute] / 60.0;
	
	// draw
	CGColorRef firstColor = [CTCReference CGColorForHour:currentHour];
	CGColorRef secondColor = [CTCReference CGColorForHour:nextHour];
	
	CGContextSetFillColorWithColor(aContext, firstColor);
	CGContextFillEllipseInRect(aContext, aRect);

	CGPoint centerPoint = CGPointMake(CGRectGetMidX(aRect), CGRectGetMidY(aRect));
	CGFloat baseAngle = 270 * M_PI/180.0;
	CGContextSetFillColorWithColor(aContext, secondColor);
	CGContextBeginPath(aContext);
	CGContextMoveToPoint(aContext, centerPoint.x, centerPoint.y);
	//	CGContextAddLineToPoint(aContext, centerPoint.x, CGRectGetMinY(aRect));
	CGContextAddArc(aContext, centerPoint.x, centerPoint.y,
					ABS(CGRectGetMaxY(aRect)-centerPoint.y), baseAngle + M_PI / 180.0 * percentFill * 360.0, baseAngle, 1);
	CGContextAddLineToPoint(aContext, centerPoint.x, centerPoint.y);
	CGContextClosePath(aContext);
	CGContextFillPath(aContext);
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{

	[CTCUpdateHelper executeBlock:^{
		NSLog(@"%s min %0.6f",__FUNCTION__,[NSDate timeIntervalSinceReferenceDate]);
		[self updateDisplayForDate:[NSDate date]];
	} andScheduleWithGranulatrity:kCTCUpdateGranularityMinutes];

	
	/*
	__block NSTimeInterval now = [NSDate timeIntervalSinceReferenceDate];
	[CTCUpdateHelper executeBlock:^{
		now += 60.0;
		NSLog(@"%s min %0.6f",__FUNCTION__,[NSDate timeIntervalSinceReferenceDate]);
		[self updateDisplayForDate:[NSDate dateWithTimeIntervalSinceReferenceDate:now]];
	} andScheduleWithGranulatrity:kCTCUpdateGranularityTenth];
	/**/
}

- (void)updateDisplayForDate:(NSDate *)aDate {
	
	NSImage *result = [NSImage imageWithSize:NSMakeSize(1024, 1024) flipped:YES drawingHandler:^BOOL(NSRect dstRect) {
		[CTCAppDelegate drawClockInRect:NSRectToCGRect(dstRect)
								context:[[NSGraphicsContext currentContext] graphicsPort]
								   date:aDate];
		return YES;
	}];
	[[NSApplication sharedApplication] setApplicationIconImage:result];
	self.clockImageView.image = result;
	
	self.leftLabel.stringValue = [CTCReference timeStringForDate:aDate];
	self.rightLabel.objectValue = aDate;
	
}
@end
