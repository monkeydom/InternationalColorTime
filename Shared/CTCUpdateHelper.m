//
//  CTCUpdateHelper.m
//  Color Time Clock
//
//  Created by Dominik Wagner on 13.04.14.
//  Copyright (c) 2014 TheCodingMonkeys. All rights reserved.
//

#import "CTCUpdateHelper.h"
#import <objc/objc-runtime.h>

static inline NSTimeInterval delayForNextEventForGranularity(CTCUpdateHelperGranularity aGranularity) {
	NSTimeInterval currentTimeInterval = [NSDate timeIntervalSinceReferenceDate];
	double factor = aGranularity;
	double roundedUpTimeInterval = ceil(currentTimeInterval / factor) * factor;
	NSTimeInterval delayInSeconds = roundedUpTimeInterval - currentTimeInterval;
	return delayInSeconds;
}

@implementation CTCUpdateHelper

+ (dispatch_block_t)executeBlock:(dispatch_block_t)aBlock andScheduleWithGranulatrity:(CTCUpdateHelperGranularity)aGranularity {
	dispatch_block_t result = [self markedBlock:aBlock withRepeatGranularity:aGranularity];
	[self performAndScheduleBlock:result];
	return result;
}


/*! checks the block if it has granularity then performs it if it has and reschedules it at the next stop at that granularity (e.g. every second, minute or hour) the constants (kCTCUpdateGranularitySeconds, etc.) refer to a factor on seconds - e.g. if you want a granularity of half a second you can specify 0.5 if you want */
+ (BOOL)performAndScheduleBlock:(dispatch_block_t)aBlock {
	CTCUpdateHelperGranularity granularity = [self performBlock:aBlock];
	if (granularity != kCTCUpdateGranularityStop) {

		// setup timer
		dispatch_queue_t mainQueue = dispatch_get_main_queue();
		// make it strict, so it isn't affected by app nap and as exact as possible
		dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, DISPATCH_TIMER_STRICT, mainQueue);
		dispatch_source_set_event_handler(timer, ^{
			if ([self performBlock:aBlock] == kCTCUpdateGranularityStop) {
				dispatch_source_cancel(timer);
			};
		});
		uint64_t interval = ceil(granularity * NSEC_PER_SEC);
		// make it use walltime to not drift around the actual walltime
		dispatch_time_t startTime = dispatch_walltime(NULL, (delayForNextEventForGranularity(granularity) * NSEC_PER_SEC));
		dispatch_source_set_timer(timer, startTime, interval, 0);
		dispatch_resume(timer);

		return YES;
	} else {
		return NO;
	}
}

+ (CTCUpdateHelperGranularity)performBlock:(dispatch_block_t)aBlock {
	CTCUpdateHelperGranularity granularity = [self granularityMarkOfBlock:aBlock];
	if (granularity != kCTCUpdateGranularityStop) {
		aBlock();
	}
	return granularity;
}

+ (void)cancelRegularExecutionOfBlock:(dispatch_block_t)aBlock {
	[self clearGranularityMarkOfBlock:aBlock];
}


#pragma mark - block marking

static const void *CTCUpdageGranularityAssocKey = &CTCUpdageGranularityAssocKey;

+ (dispatch_block_t)markedBlock:(dispatch_block_t)aBlock withRepeatGranularity:(CTCUpdateHelperGranularity)aGranularity {
	dispatch_block_t result = [aBlock copy];
	objc_setAssociatedObject(result, CTCUpdageGranularityAssocKey, @(aGranularity), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	return result;
}

+ (CTCUpdateHelperGranularity)granularityMarkOfBlock:(dispatch_block_t)aBlock {
	NSNumber *number = objc_getAssociatedObject(aBlock, CTCUpdageGranularityAssocKey);
	CTCUpdateHelperGranularity result = number ? number.doubleValue : kCTCUpdateGranularityStop;
	return result;
}

+ (void)clearGranularityMarkOfBlock:(dispatch_block_t)aBlock {
	objc_setAssociatedObject(aBlock, CTCUpdageGranularityAssocKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
