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
@end
