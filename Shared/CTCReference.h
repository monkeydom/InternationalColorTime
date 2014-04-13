//
//  CTCReference.h
//  Color Time Clock
//
//  Created by Dominik Wagner on 13.04.14.
//  Copyright (c) 2014 TheCodingMonkeys. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CTCReference : NSObject

+ (NSString *)timeStringForDate:(NSDate *)aDate;
+ (CGColorRef)CGColorForHour:(NSInteger)anHour;
+ (NSString *)nameForHour:(NSInteger)anHour;
+ (NSString *)hourNameForDate:(NSDate *)aDate;
+ (NSDateComponents *)UTCDateComponentsForDate:(NSDate *)aDate;
+ (void)drawClockInRect:(CGRect)aRect context:(CGContextRef)aContext date:(NSDate *)aDate;
+ (void)drawHourRingInRect:(CGRect)aRect width:(CGFloat)aWidth context:(CGContextRef)aContext date:(NSDate *)aDate;
@end
