//
//  LEProcessor.h
//  LanguageEngine
//
//  Created by Darryl McAdams on 9/3/14.
//
//

#import <Foundation/Foundation.h>
#import "LanguageEngine/libLE.h"
#import "LanguageEngine/LEPlugin.h"
#import "LanguageEngine/LEEvent.h"
#import "LanguageEngine/LEEventSet.h"
#import "LanguageEngine/LEEntity.h"

typedef enum { LESuccess, LEErrorNoIndicatives, LEErrorNoImperatives, LEErrorNoInterrogatives,
               LEErrorCannotDispatch, LEErrorInvalidEvents, LEErrorInvalidInput } LEProcessorCode;

@interface LEProcessor : NSObject {
  PluginSystem* pluginSystem;
  Signature* signature;
  SignLexicon* lexicon;
  WorldModel* worldModel;
  LEEventSet* worldModelDescription;
  BOOL shouldRefreshWorldModel;
  
  NSMutableDictionary* plugins;
  BOOL acceptsIndicatives;
  BOOL acceptsImperatives;
  BOOL acceptsInterrogatives;
}

+ (void)startLanguageEngine;
+ (void)stopLanguageEngine;

+ (id)withPlugins:(NSArray*)plugins;

- (void)setAcceptsIndicatives:(BOOL)yn;
- (void)setAcceptsImperatives:(BOOL)yn;
- (void)setAcceptsInterrogatives:(BOOL)yn;

- (BOOL)addPlugin:(LEPlugin*)plugin;
- (void)refreshWorldModel;
- (void)setShouldRefreshWorldModel;
- (void)finishSetup;

- (NSString*)resultsForInput:(NSString*)input error:(NSString**)errOut;
- (LEProcessorCode)processInput:(NSString*)input;
- (LEProcessorCode)eventSetForInput:(NSString*)input output:(LEEventSet**)output;
- (BOOL)dispatchEvent:(LEEvent*)event eventSet:(LEEventSet*)evset;

- (NSString*)entityStringValue:(LEEntity*)ent;
- (LEEntity*)newEntity;
- (BOOL)assertEntity:(LEEntity*)ent stringValue:(NSString*)str;
- (BOOL)assertEventPredicate:(NSString*)prd arguments:(NSDictionary*)args sender:(LEPlugin*)plg;

- (LEEventSet*)worldModelDescription;

- (NSString*)signatureRepresentation;
- (NSString*)lexiconRepresentation;
- (NSString*)worldModelRepresentation;

@end
