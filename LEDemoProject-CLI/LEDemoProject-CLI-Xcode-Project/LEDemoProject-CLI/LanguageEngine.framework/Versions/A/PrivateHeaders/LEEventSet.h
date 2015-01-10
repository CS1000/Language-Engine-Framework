//
//  LEEventSet.h
//  LanguageEngine
//
//  Created by Darryl McAdams on 12/31/14.
//
//

#import "LanguageEngine/LEProcessor.h"

@interface LEEventSet : NSObject {
  NSArray* events;
}

+ (id)withString:(NSString*)evs processor:(LEProcessor*)proc;
- (id)initWithString:(NSString*)evs processor:(LEProcessor*)proc;

- (NSArray*)events;
- (NSArray*)findEventsPredicate:(NSString*)pred
                      arguments:(NSDictionary*)args;

@end
