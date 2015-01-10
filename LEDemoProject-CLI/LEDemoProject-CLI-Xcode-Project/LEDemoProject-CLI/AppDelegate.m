//
//  AppDelegate.m
//  LEDemoProject-CLI
//
//  Created by Darryl McAdams on 10/14/14.
//  Copyright (c) 2014 Language Engine. All rights reserved.
//

#import "AppDelegate.h"
#import "FSPlugin.h"

@implementation AppDelegate



/*
 *  We'll start Language Engine, and create an instance of the custom plugin
 *  class and the processor, using the base plugin and English plugin, to get
 *  some standard functionality for free. Semantics contributed by the base
 *  plugin have no plugin-name prefix, such as Subj and Obj (for subject and
 *  object, respectively).
 */
- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
  [input setTarget: self];
  [input setAction:@selector(handleInput:)];
  [input becomeFirstResponder];
  
  [LEProcessor startLanguageEngine];
  
  
  FSPlugin* fsPlugin = [FSPlugin new];
  [fsPlugin setAppDelegate: self];
  
  processor = [LEProcessor withPlugins:@[[LEPlugin basePlugin],
                                         [LEPlugin englishPlugin],
                                         fsPlugin]];
}

/*
 *  We'll also stop Language Engine when the app closes.
 */
- (void)applicationWillTerminate:(NSNotification *)aNotification {
  [LEProcessor stopLanguageEngine];
}



/*
 *  To handle input, we'll just feed the text from the NSTextField to the
 *  processor.
 */
- (void)handleInput:(id)sender {
  NSString* inputToProcess = [input stringValue];
  
  if (![inputToProcess isEqualToString:@""]) {
    
    [input setStringValue: @""];
    
    NSTextStorage* ts = [output textStorage];
    [ts appendAttributedString:[[NSAttributedString alloc]
                                initWithString:[NSString stringWithFormat:@"> %@\n",inputToProcess]]];
    
    LEProcessorCode res = [processor processInput:inputToProcess];
    
    if (LESuccess == res) {
      [ts appendAttributedString:[[NSAttributedString alloc]
                                  initWithString:@"Ok.\n"]];
    } else {
      [ts appendAttributedString:[[NSAttributedString alloc]
                                  initWithString:[NSString
                                                  stringWithFormat:@"Could not process input due to an error (code %u).\n\n",
                                                  res]]];
    }
    
    [output setNeedsDisplay:YES];
    
  }
}



- (void)displayString:(NSString*)str {
  NSTextStorage* ts = [output textStorage];
  [ts appendAttributedString:[[NSAttributedString alloc]
                              initWithString:str]];
  
  [output scrollToEndOfDocument:nil];
}

@end
