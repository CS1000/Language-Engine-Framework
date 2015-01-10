//
//  LEPlugin.h
//  LanguageEngine
//
//  Created by Darryl McAdams on 9/3/14.
//
//

#import <Foundation/Foundation.h>
#import "LanguageEngine/LEEvent.h"
#import "LanguageEngine/LEEntity.h"
#import "LanguageEngine/libLE.h"

@class LEProcessor;
@class LEEventSet;

@interface LEPlugin : NSObject {
  NSString* name;
  Plugin* plugin;
  LEProcessor* processor;
  NSMutableDictionary* dispatchTable;
}

// Internal methods; do not override

+ (id)basePlugin;
+ (id)englishPlugin;
- (id)initBasePlugin;
- (id)initEnglishPlugin;

- (NSString*)name;
- (Plugin*)plugin;

- (void)setProcessor:(LEProcessor*)proc;

- (LEEntity*)newEntity;
- (BOOL)assertEventPredicate:(NSString*)prd arguments:(NSDictionary*)args;
- (void)setShouldRefreshWorldModel;
- (LEEventSet*)worldModelDescription;

- (BOOL)addPredicate:(NSString*)prd;
- (BOOL)addRelation:(NSString*)rel;

- (BOOL)addLexicalEntry:(NSString*)frm category:(NSString*)cat semantics:(NSString*)sem;
- (BOOL)addCountNounSg:(NSString*)sgf pl:(NSString*)plf semantics:(NSString*)sem;
- (BOOL)autoAddCountNoun:(NSString*)sgf;
- (BOOL)addMassNoun:(NSString*)ms semantics:(NSString*)sem;
- (BOOL)autoAddMassNoun:(NSString*)msf;
- (BOOL)addIntransitiveVerbBare:(NSString*)baref perf:(NSString*)perff
                           prog:(NSString*)progf pass:(NSString*)passf ger:(NSString*)gerf
                      fstSgPres:(NSString*)fstSgPres sndSgPres:(NSString*)sndSgPres thdSgPres:(NSString*)thdSgPres
                        fstPlPres:(NSString*)fstPlPres sndPlPres:(NSString*)sndPlPres thdPlPres:(NSString*)thdPlPres
          fstSgPast:(NSString*)fstSgPast sndSgPast:(NSString*)sndSgPast thdSgPast:(NSString*)thdSgPast
                      fstPlPast:(NSString*)fstPlPast sndPlPast:(NSString*)sndPlPast thdPlPast:(NSString*)thdPlPast
                      semantics:(NSString*)sem;
- (BOOL)addTransitiveVerbBare:(NSString*)baref perf:(NSString*)perff
                         prog:(NSString*)progf pass:(NSString*)passf ger:(NSString*)gerf
                    fstSgPres:(NSString*)fstSgPres sndSgPres:(NSString*)sndSgPres thdSgPres:(NSString*)thdSgPres
                    fstPlPres:(NSString*)fstPlPres sndPlPres:(NSString*)sndPlPres thdPlPres:(NSString*)thdPlPres
                    fstSgPast:(NSString*)fstSgPast sndSgPast:(NSString*)sndSgPast thdSgPast:(NSString*)thdSgPast
                    fstPlPast:(NSString*)fstPlPast sndPlPast:(NSString*)sndPlPast thdPlPast:(NSString*)thdPlPast
                    semantics:(NSString*)sem;
- (BOOL)autoAddIntransitiveVerb:(NSString*)baref;
- (BOOL)autoAddIntransitiveVerb:(NSString*)baref semantics:(NSString*)sem;
- (BOOL)autoAddTransitiveVerb:(NSString*)baref;
- (BOOL)autoAddTransitiveVerb:(NSString*)baref semantics:(NSString*)sem;

- (BOOL)setDispatchPredicate:(NSString*)pred keywords:(NSArray*)keywords method:(SEL)sel;
- (BOOL)dispatchEvent:(LEEvent*)event eventSet:(LEEventSet*)evs;

// Overridable methods

- (BOOL)setup;
- (void)analyzeWorld;
- (BOOL)executeEvent:(LEEvent*)event eventSet:(LEEventSet*)evs;

@end
