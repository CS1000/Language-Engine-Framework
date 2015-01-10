//
//  FSPlugin.h
//  LEDemoProject-CLI
//
//  Created by Darryl McAdams on 10/14/14.
//  Copyright (c) 2014 Language Engine. All rights reserved.
//

#import <LanguageEngine/LanguageEngine.h>
#import "AppDelegate.h"

@interface FSPlugin : LEPlugin {
  LEEntity* upDir;
  LEEntity* backDir;
  NSString* currentDirectory;
  NSString* previousDirectory;
  
  NSFileManager* fileManager;
  AppDelegate* appDelegate;
}

- (void)setAppDelegate:(AppDelegate*)ad;

- (BOOL)showSubj:(NSArray*)subj
             obj:(NSArray*)shown
        eventSet:(LEEventSet*)evs;

- (BOOL)moveSubj:(NSArray*)subj
             obj:(NSArray*)moved
            dest:(NSArray*)dest
        eventSet:(LEEventSet*)evs;

- (BOOL)makeSubj:(NSArray*)subj
             obj:(NSArray*)made
        eventSet:(LEEventSet*)evs;

- (BOOL)copyCopier:(NSArray*)copier
          original:(NSArray*)orig
            result:(NSArray*)res
          eventSet:(LEEventSet*)evs;

- (BOOL)goSubj:(NSArray*)subj
          dest:(NSArray*)dest
      eventSet:(LEEventSet*)evs;

- (void)ensureExists:(NSString*)dirName;

@end
