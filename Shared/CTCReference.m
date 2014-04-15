//
//  CTCReference.m
//  Color Time Clock
//
//  Created by Dominik Wagner on 13.04.14.
//  Copyright (c) 2014 TheCodingMonkeys. All rights reserved.
//

#import "CTCReference.h"
@import Quartz;

static NSArray *S_colorsArray = nil;
static NSArray *S_colorNameArray = nil;

@implementation CTCReference

// http://www.phrenopolis.com/colorclock/

+ (void)initialize {
	if ([self isEqual:[CTCReference class]]) {
		CGColorSpaceRef colorSpace = CGColorSpaceCreateWithName(kCGColorSpaceGenericRGB);
		
		S_colorsArray = @[
						  (__bridge id)CGColorCreate(colorSpace, (CGFloat[4]){0xff / 255., 0x00/255.0, 0x00/255.0, 1.0}), // red
						  (__bridge id)CGColorCreate(colorSpace, (CGFloat[4]){0xbd / 255., 0x1f/255.0, 0x1f/255.0, 1.0}), // brick
						  (__bridge id)CGColorCreate(colorSpace, (CGFloat[4]){0xef / 255., 0x65/255.0, 0x00/255.0, 1.0}), // orange
						  (__bridge id)CGColorCreate(colorSpace, (CGFloat[4]){0xff / 255., 0x8b/255.0, 0x00/255.0, 1.0}), // tangerine
						  (__bridge id)CGColorCreate(colorSpace, (CGFloat[4]){0xff / 255., 0xc5/255.0, 0x00/255.0, 1.0}), // mustard
						  (__bridge id)CGColorCreate(colorSpace, (CGFloat[4]){0xff / 255., 0xff/255.0, 0x00/255.0, 1.0}), // yellow
						  (__bridge id)CGColorCreate(colorSpace, (CGFloat[4]){0xd0 / 255., 0xd8/255.0, 0x1e/255.0, 1.0}), // pear
						  (__bridge id)CGColorCreate(colorSpace, (CGFloat[4]){0xa2 / 255., 0xb1/255.0, 0x3d/255.0, 1.0}), // sage
						  (__bridge id)CGColorCreate(colorSpace, (CGFloat[4]){0x40 / 255., 0xef/255.0, 0x8a/255.0, 1.0}), // mint
						  (__bridge id)CGColorCreate(colorSpace, (CGFloat[4]){0x00 / 255., 0xff/255.0, 0x00/255.0, 1.0}), // lime
						  (__bridge id)CGColorCreate(colorSpace, (CGFloat[4]){0x02 / 255., 0xc0/255.0, 0x00/255.0, 1.0}), // green
						  (__bridge id)CGColorCreate(colorSpace, (CGFloat[4]){0x00 / 255., 0x72/255.0, 0x0e/255.0, 1.0}), // pine
						  (__bridge id)CGColorCreate(colorSpace, (CGFloat[4]){0x88 / 255., 0x88/255.0, 0x88/255.0, 1.0}), // grey
						  (__bridge id)CGColorCreate(colorSpace, (CGFloat[4]){0x00 / 255., 0xff/255.0, 0xff/255.0, 1.0}), // aqua
						  (__bridge id)CGColorCreate(colorSpace, (CGFloat[4]){0x00 / 255., 0x80/255.0, 0x80/255.0, 1.0}), // teal
						  (__bridge id)CGColorCreate(colorSpace, (CGFloat[4]){0x00 / 255., 0x66/255.0, 0xbb/255.0, 1.0}), // denim
						  (__bridge id)CGColorCreate(colorSpace, (CGFloat[4]){0x00 / 255., 0x00/255.0, 0xD0/255.0, 1.0}), // blue
						  (__bridge id)CGColorCreate(colorSpace, (CGFloat[4]){0x00 / 255., 0x00/255.0, 0x80/255.0, 1.0}), // navy
						  (__bridge id)CGColorCreate(colorSpace, (CGFloat[4]){0x38 / 255., 0x23/255.0, 0xd2/255.0, 1.0}), // indigo
						  (__bridge id)CGColorCreate(colorSpace, (CGFloat[4]){0x70 / 255., 0x07/255.0, 0xa6/255.0, 1.0}), // purple
						  (__bridge id)CGColorCreate(colorSpace, (CGFloat[4]){0xac / 255., 0x6f/255.0, 0xd5/255.0, 1.0}), // lavender
						  (__bridge id)CGColorCreate(colorSpace, (CGFloat[4]){0xa8 / 255., 0x03/255.0, 0x58/255.0, 1.0}), // maroon
						  (__bridge id)CGColorCreate(colorSpace, (CGFloat[4]){0xff / 255., 0x00/255.0, 0xff/255.0, 1.0}), // pink
						  (__bridge id)CGColorCreate(colorSpace, (CGFloat[4]){0xdf / 255., 0x16/255.0, 0x6f/255.0, 1.0}), // rose
						  ];
		CFRelease(colorSpace);
		
		S_colorNameArray =
		@[
		@"red",
		@"brick",
		@"orange",
		@"tangerine",
		@"mustard",
		@"yellow",
		@"pear",
		@"sage",
		@"mint",
		@"lime",
		@"green",
		@"pine",
		@"grey",
		@"aqua",
		@"teal",
		@"denim",
		@"blue",
		@"navy",
		@"indigo",
		@"purple",
		@"lavender",
		@"maroon",
		@"pink",
		@"rose",
		];
		
	}
}

+ (CGColorRef)CGColorForHour:(NSInteger)anHour NS_RETURNS_INNER_POINTER {
	return (__bridge CGColorRef)S_colorsArray[anHour % 24];
}

+ (NSString *)nameForHour:(NSInteger)anHour {
	return S_colorNameArray[anHour % 24];
}

+ (NSDateComponents *)UTCDateComponentsForDate:(NSDate *)aDate {
	static NSCalendar *calendar = nil;
	if (!calendar) {
		calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
		[calendar setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
		// UTC does not have daylight saving time, which is what we need here
	}
    NSDateComponents *utcComponents = [calendar components:(NSHourCalendarUnit| NSMinuteCalendarUnit) fromDate:aDate];
	return utcComponents;
}


+ (NSString *)hourNameForDate:(NSDate *)aDate {
	NSString *result = [self nameForHour:[self UTCDateComponentsForDate:aDate].hour];
	return result;
}

+ (NSString *)timeStringForDate:(NSDate *)aDate {
    NSDateComponents *components = [self UTCDateComponentsForDate:aDate];
	NSString *result = [NSString stringWithFormat:@"%@:%02ld:%@",[self nameForHour:components.hour],components.minute,[self nameForHour:(components.hour + 1) % 24 ]];
	return result;
}


+ (void)drawHourRingInRect:(CGRect)aRect width:(CGFloat)aWidth context:(CGContextRef)aContext date:(NSDate *)aDate {
	NSInteger midnight = [self UTCDateComponentsForDate:[NSDate dateWithNaturalLanguageString:@"midnight"]].hour;
	NSInteger thisHour = [self UTCDateComponentsForDate:aDate].hour;
	aWidth = aWidth / 3.0;
	CGFloat fullRadius = CGRectGetWidth(aRect) / 2.0;
	CGFloat outerRadius = fullRadius - aWidth/2.0;
	CGFloat innerRadius = outerRadius - aWidth;
	CGFloat baseAngle = 270 * M_PI/180.0;
	CGFloat pieceAngle = 360.0 / 12.0 * M_PI/180.0;
	CGPoint centerPoint = CGPointMake(CGRectGetMidX(aRect), CGRectGetMidY(aRect));
	for (NSInteger position=23; position >= 0; position--) {
		CGFloat lesserAngle = baseAngle + (position - 0.5 + 0.5) * pieceAngle;
		CGFloat biggerAngle = lesserAngle + pieceAngle;
		CGFloat radiusInset = position >= 12 ? aWidth : 0;
		
		NSInteger hour = (midnight + position) % 24;
		
		CGContextAddArc(aContext, centerPoint.x, centerPoint.y, outerRadius - radiusInset, lesserAngle, biggerAngle, 0);
		CGContextAddArc(aContext, centerPoint.x, centerPoint.y, innerRadius - radiusInset, biggerAngle, lesserAngle, 1);
		CGContextSetFillColorWithColor(aContext, [self CGColorForHour:hour]);
		CGContextSetStrokeColorWithColor(aContext, [self CGColorForHour:hour]);
		CGContextDrawPath(aContext, kCGPathFillStroke);
	}
	
	// draw this hour on top of everything
	
	CGFloat angleWidth = pieceAngle / 5.0;
	CGFloat lesserAngle = baseAngle + (((thisHour - midnight + 24) % 24) - 0.5 + 0.5) * pieceAngle;
	CGFloat percentOfHourThrough = [self UTCDateComponentsForDate:aDate].minute / 60.0;
	lesserAngle += percentOfHourThrough * pieceAngle;
	
	lesserAngle += (angleWidth / 2.0);
	CGFloat biggerAngle = lesserAngle - angleWidth;
	
	CGContextMoveToPoint(aContext, centerPoint.x, centerPoint.y);
	CGContextAddArc(aContext, centerPoint.x, centerPoint.y, fullRadius, lesserAngle, biggerAngle, 1);

	
	CGColorRef color1 = [self CGColorForHour:thisHour];
	CGColorRef color2 = [self CGColorForHour:(thisHour + 1) % 24];
	NSColor *blendedColor = [[NSColor colorWithCGColor:color1] blendedColorWithFraction:percentOfHourThrough ofColor:[NSColor colorWithCGColor:color2]];

	CGContextSetFillColorWithColor(aContext, blendedColor.CGColor);
	CGContextSetStrokeColorWithColor(aContext, blendedColor.CGColor);
	CGContextDrawPath(aContext, kCGPathFillStroke);
	
	
}

+ (void)drawClockInRect:(CGRect)aRect context:(CGContextRef)aContext date:(NSDate *)aDate {
	// extract the necessary information
    NSDateComponents *utcComponents = [self UTCDateComponentsForDate:aDate];
    
    NSInteger currentHour = [utcComponents hour];
    NSInteger nextHour = (currentHour + 1) % 24;
	
	CGFloat percentFill = [utcComponents minute] / 60.0;
	
	// draw
	CGColorRef firstColor = [CTCReference CGColorForHour:currentHour];
	CGColorRef secondColor = [CTCReference CGColorForHour:nextHour];
	CGPoint centerPoint = CGPointMake(CGRectGetMidX(aRect), CGRectGetMidY(aRect));
	CGFloat radius = floor(ABS(CGRectGetMaxY(aRect)-centerPoint.y) * 0.90);

	CGContextSetShadow(aContext, CGSizeMake(0.0, 0.0), (CGRectGetWidth(aRect) / 2.0 - radius) / 2.0);
	
	CGContextSetFillColorWithColor(aContext, firstColor);
	CGContextFillEllipseInRect(aContext, aRect);
	
	CGFloat baseAngle = 270 * M_PI/180.0;
	CGContextSetFillColorWithColor(aContext, secondColor);
	CGContextBeginPath(aContext);
	CGContextMoveToPoint(aContext, centerPoint.x, centerPoint.y);
	//	CGContextAddLineToPoint(aContext, centerPoint.x, CGRectGetMinY(aRect));

	CGContextAddArc(aContext, centerPoint.x, centerPoint.y,
					radius, baseAngle + M_PI / 180.0 * percentFill * 360.0, baseAngle, 1);
	CGContextAddLineToPoint(aContext, centerPoint.x, centerPoint.y);
	CGContextClosePath(aContext);
//	CGContextDrawPath(aContext, kCGPathFillStroke);
	if (NO) {
		CGPathRef path = CGContextCopyPath(aContext);
		CGContextSaveGState(aContext);
		CGContextSetStrokeColor(aContext, (CGFloat[4]){0.0,0.0,0.0,0.4});
		CGContextStrokePath(aContext);
		CGContextRestoreGState(aContext);
		
		CGContextAddPath(aContext, path);
		CFRelease(path);
	}
	
	CGContextSetFillColorWithColor(aContext, secondColor);
	CGContextFillPath(aContext);
}


@end
