//
//  CTCAppDelegate.h
//  Color Time Clock
//
//  Created by Dominik Wagner on 13.04.14.
//  Copyright (c) 2014 TheCodingMonkeys. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface CTCAppDelegate : NSObject <NSApplicationDelegate>
@property (nonatomic, strong) IBOutlet NSImageView *clockImageView;
@property (weak) IBOutlet NSTextField *leftLabel;
@property (weak) IBOutlet NSTextField *rightLabel;

@property (assign) IBOutlet NSWindow *window;

@end
