//
//  AppDelegate.h
//  LEDemoProject-CLI
//
//  Created by Darryl McAdams on 10/14/14.
//  Copyright (c) 2014 Language Engine. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <LanguageEngine/LanguageEngine.h>

@interface AppDelegate : NSObject <NSApplicationDelegate> {
  IBOutlet NSTextView* output;
  IBOutlet NSTextField* input;
  LEProcessor* processor;
  LEPlugin* plugin;
}

@property (assign) IBOutlet NSWindow *window;

- (void)handleInput:(id)sender;
- (void)displayString:(NSString*)str;

@end
