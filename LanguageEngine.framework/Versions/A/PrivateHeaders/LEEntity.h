//
//  LEEntity.h
//  LanguageEngine
//
//  Created by Darryl McAdams on 9/3/14.
//
//

#import <Foundation/Foundation.h>

@class LEProcessor;

@interface LEEntity : NSObject {
  NSString* entityName;
  LEProcessor* processor;
}

+ (id)withEntityName:(NSString*)ent processor:(LEProcessor*)proc;
- (id)initWithEntityName:(NSString*)ent processor:(LEProcessor*)proc;

- (NSString*)entityName;

- (NSString*)stringValue;
- (BOOL)setStringValue:(NSString*)str;

- (BOOL)isComputer;
- (BOOL)isUser;

+ (BOOL)sameEntities:(NSArray*)xs as:(NSArray*)ys;

@end
