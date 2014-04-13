//
//  CTCUpdateHelper.h
//  Color Time Clock
//
//  Created by Dominik Wagner on 13.04.14.
//  Copyright (c) 2014 TheCodingMonkeys. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef double CTCUpdateHelperGranularity;
#define kCTCUpdateGranularityTenth       0.1
#define kCTCUpdateGranularityHundredth   0.01
#define kCTCUpdateGranularitySeconds     1.0
#define kCTCUpdateGranularityMinutes    60.0
#define kCTCUpdateGranularityHours     360.0
#define kCTCUpdateGranularityStop      DBL_MAX

@interface CTCUpdateHelper : NSObject

+ (dispatch_block_t)executeBlock:(dispatch_block_t)aBlock andScheduleWithGranulatrity:(CTCUpdateHelperGranularity)aGranularity;
+ (void)cancelRegularExecutionOfBlock:(dispatch_block_t)aBlock;

@end
