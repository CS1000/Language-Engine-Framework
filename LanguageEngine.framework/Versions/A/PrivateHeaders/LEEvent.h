//
//  LEEvent.h
//  LanguageEngine
//
//  Created by Darryl McAdams on 9/3/14.
//
//

#import <Foundation/Foundation.h>

@class LEProcessor;

@interface LEEvent : NSObject {
  NSString* pluginName;
  NSString* predicate;
  NSString* event;
  BOOL foreground;
  BOOL exists;
  NSDictionary* arguments;
  LEProcessor* processor;
}

+ (id)withString:(NSString*)ev processor:(LEProcessor*)proc;
- (id)initWithString:(NSString*)ev processor:(LEProcessor*)proc;

- (NSString*)pluginName;
- (NSString*)predicate;
- (NSString*)event;
- (BOOL)foreground;
- (BOOL)exists;
- (NSArray*)keywords;
- (NSArray*)arguments;
- (NSArray*)argumentsForKeyword:(NSString*)keyword;

- (BOOL)matchPredicate:(NSString*)pred arguments:(NSDictionary*)args;

@end
