//
//  CTCAppDelegate.m
//  Color Time Clock
//
//  Created by Dominik Wagner on 13.04.14.
//  Copyright (c) 2014 TheCodingMonkeys. All rights reserved.
//

#import "CTCAppDelegate.h"
#import "CTCUpdateHelper.h"

@implementation CTCAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	// Insert code here to initialize your application
	
	dispatch_block_t tenthBlock = [CTCUpdateHelper executeBlock:^{
		NSLog(@"%s tenth %0.6f",__FUNCTION__,[NSDate timeIntervalSinceReferenceDate]);
	} andScheduleWithGranulatrity:kCTCUpdateGranularityTenth];
	
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		[CTCUpdateHelper cancelRegularExecutionOfBlock:tenthBlock];
	});
	
	[CTCUpdateHelper executeBlock:^{
		NSLog(@"%s sec %0.6f",__FUNCTION__,[NSDate timeIntervalSinceReferenceDate]);
	} andScheduleWithGranulatrity:kCTCUpdateGranularitySeconds];
	[CTCUpdateHelper executeBlock:^{
		NSLog(@"%s min %0.6f",__FUNCTION__,[NSDate timeIntervalSinceReferenceDate]);
	} andScheduleWithGranulatrity:kCTCUpdateGranularityMinutes];
	[CTCUpdateHelper executeBlock:^{
		NSLog(@"%s hour %0.6f",__FUNCTION__,[NSDate timeIntervalSinceReferenceDate]);
	} andScheduleWithGranulatrity:kCTCUpdateGranularityHours];
	//	[self updateTimeImagesAccordingToNow];
}

- (void)updateTimeImagesAndScheduleNext {
/*
    NSDate *nowDate;
    
    SEL callMe = @selector(updateTimeImagesAndScheduleNext);
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:callMe object:nil];
	
    if (isDebugMode) {
        nowDate = [NSDate dateWithTimeIntervalSinceReferenceDate:debugTimeInterval];
        debugTimeInterval = debugTimeInterval + 60;
    } else {
        nowDate = [NSDate date];
    }
    
    //update icon
    [(NSImageView *)tile.contentView setImage: [BCMUtil BCMAppIconForDate:nowDate]];
    [tile display];
	
    //next update
    NSTimeInterval intervalToNextMinute = [nowDate timeIntervalSinceReferenceDate];
	
    if (isDebugMode) {
        intervalToNextMinute = 5. - (((int)intervalToNextMinute) % 5);
    } else {
        intervalToNextMinute = 60. - (((int)intervalToNextMinute) % 60);
    }
	
    [self performSelector:callMe withObject:nil afterDelay:intervalToNextMinute];
*/
}

@end
