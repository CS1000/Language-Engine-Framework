//
//  FSPlugin.m
//  LEDemoProject-CLI
//
//  Created by Darryl McAdams on 10/14/14.
//  Copyright (c) 2014 Language Engine. All rights reserved.
//

#import "FSPlugin.h"
#import <LanguageEngine/LanguageEngine.h>

@implementation FSPlugin

- (id)init {
  
  self = [super init];
  
  if (self) {
    currentDirectory = [@"~/LEDemoProject-CLI-Temp" stringByExpandingTildeInPath];
    fileManager = [NSFileManager defaultManager];
  }
  
  return self;
  
}

- (void)setAppDelegate:(AppDelegate*)ad {
  appDelegate = ad;
}




/*
 *  The setup method will be called when the plugin is added to the processor.
 *  This method establishes the vocabulary that the plugin can handle, together
 *  with any necessary semantic predicates that the vocabular relies on.
 */
- (BOOL)setup {
  
  /*
   *  Simple Nouns
   *
   *  The method autoAddCountNoun: takes a singular noun form and attempts to
   *  automatically derive the plural form from it. It also automatically
   *  creates an appropriate predicate. For example, the noun "folder" will
   *  result in the creation of the predicate AutoEvent_Folder, which is a
   *  predicate of events (an event being an abstract thing experiences by
   *  entities like folders, i.e. something like "the state/event of being a
   *  folder"). These automatically generated predicates are always of the form
   *  AutoEvent_<capitalized_singular_form>, so for words like GIF which are
   *  capitalized already, the result is just AutoEvent_GIF.
   *
   *  Because the method generates a full semantic representation for a noun,
   *  which ought to be a predicate of entities, not events, we use the
   *  base plugin's Exp relation (for experiencer) to relate the event to the
   *  entity which experiences that event. So, for "folder", the semantics
   *  it gets assigned is the function
   *
   *    \(x : Entity) -> (e : Event) * FSPlugin.AutoEvent_Folder e * Exp e x
   *
   *  which has the type `Entity -> Prop`. You can see that the generated
   *  predicate is prefixed by this plugin's name, to avoid collisions between
   *  multiple plugins that might use the same predicate name. The relation Exp
   *  has no prefix because it belongs to the base plugin.
   */
  
  [self autoAddCountNoun:@"folder"];
  [self autoAddCountNoun:@"file"];
  [self autoAddCountNoun:@"JPEG"];
  [self autoAddCountNoun:@"GIF"];
  
  
  
  
  /*
   *  Simple Verbs
   *
   *  The methods autoAddTransitiveVerb: and autoAddIntransitiveVerb: are
   *  verb versions of the autoAddCountNoun: method, trying to derive the
   *  various verb forms automatically from a bare form (the form used with
   *  "to", as in "to show", sometimes called citation form). It doesn't
   *  use very smart techniques right now, so if you use an irregular verb,
   *  there's a good chance it won't produce the correct morphology, but for
   *  most regular verbs, it works correctly.
   *
   *  Like for nouns, it generates an event predicate automatically, such as
   *  AutoEvent_Show which corresponds to the verb "show". Because it's
   *  automatically generating a full semantic representation as well, it uses
   *  the Subj and Obj relations from the base plugin for the subject and
   *  object. The semantics generated for "show" is
   *
   *    \(x : Entity) -> \(y : Entity) -> \(e : Event) ->
   *       FSPlugin.AutoEvent_Show e * Obj e x * Subj e y
   *
   *  which has the type `Entity -> Entity -> Event -> Prop`.
   */
  
  [self autoAddTransitiveVerb:@"show"];
  
  /*
   *  When a command like "show the file" needs to be handled, we'd like to
   *  have the plugin's showSubj:obj: method be called, with the subject
   *  argument bound to the entity representing the computer, and the object
   *  bound to the entity representing the item to show in the app window.
   *  We can do this using the setDispatchPredicate:keywords:method: method.
   *  The predicate argument obviously corresponds to the predicate being
   *  handled, while the keywords list is the names of the relations that
   *  pick out the arguments, in the order that they should be given to the
   *  method to call, namely showSubj:obj:, which will be implemented later.
   */
  
  [self setDispatchPredicate:@"AutoEvent_Show"
                    keywords:@[@"Subj",@"Obj"]
                      method:@selector(showSubj:obj:eventSet:)];
  
  
  
  
  /*
   *  Verbs with Custom Semantics
   *
   *  Sometimes its useful to automatically derive morphology but to specify the
   *  meaning of a verb by hand. For instance, the word "list" should be used
   *  synonymously with "show", at least in this app, so we'd like both words
   *  to mean the same thing. So we can use this method to specify the meaning
   *  of the verb to be the same as the automatically derived semantics for
   *  the verb "show". Be careful with spaces, tho, when breaking meanings
   *  across multiple lines!
   */
  
  [self autoAddTransitiveVerb:@"list"
                    semantics:@"\\(x : Entity) -> \\(y : Entity) -> \\(e : Event) ->"
                                @" FSPlugin.AutoEvent_Show e * Obj e x * Subj e y"];
  
  
  
  
  [self autoAddTransitiveVerb:@"make"];
  
  [self setDispatchPredicate:@"AutoEvent_Make"
                    keywords:@[@"Subj",@"Obj"]
                      method:@selector(makeSubj:obj:eventSet:)];
  
  /*
   *  Nouns with Custom Semantics
   *  
   *  As with verbs, sometimes its useful to specify the meaning by hand. Here,
   *  we'll create synonyms of "JPEG" and "GIF" that handle alternate spellings.
   */
  
  [self addCountNounSg:@"JPG" pl:@"JPGs"
             semantics:@"\\(x : Entity) -> (s : Event) * FSPlugin.AutoEvent_JPEG s * Exp s x"];
  [self addCountNounSg:@"jpeg" pl:@"jpegs"
             semantics:@"\\(x : Entity) -> (s : Event) * FSPlugin.AutoEvent_JPEG s * Exp s x"];
  [self addCountNounSg:@"jpg" pl:@"jpgs"
             semantics:@"\\(x : Entity) -> (s : Event) * FSPlugin.AutoEvent_JPEG s * Exp s x"];
  [self addCountNounSg:@"gif" pl:@"gifs"
             semantics:@"\\(x : Entity) -> (s : Event) * FSPlugin.AutoEvent_GIF s * Exp s x"];
  
  
  
  /*
   *  Custom Predicates, Coomplex Verbs, Related Nouns
   *
   *  We can also define predicates and relations by hand. Event predicates
   *  classify events, while relations pick out arguments according to their
   *  role. Subj and Obj are ok defaults, but sometimes it's nice to have more
   *  conceptual argument names. For the verb "copy", we want three kinds of
   *  arguments: the person doing the copying, the original item being copied,
   *  and the copy that gets produced as a result. We can use the provided
   *  methods to create these methods.
   */
  
  [self addPredicate:@"Copy"];
  [self addRelation:@"Copy_Copier"];
  [self addRelation:@"Copy_Original"];
  [self addRelation:@"Copy_Result"];
  
  /*
   *  We'll then automatically derive the morphology, but specify the meaning
   *  by hand. Now, since "copy" is a verb of implicit creation -- that is,
   *  the verb's meaning involves creating something (the result of the copying),
   *  but this thing isn't represented in the spoken syntax, just the meaning --
   *  we'll need to only have two arguments, for the copier and the original,
   *  while the result is existentially closed. We still need it there, tho,
   *  otherwise the meaning would be wrong!
   *
   *  Of course we'll also have the synonym "duplicate".
   */
  
  [self autoAddTransitiveVerb:@"copy"
                    semantics:@"\\(x : Entity) -> \\(y : Entity) -> \\(e : Event) ->"
                                    @" FSPlugin.Copy e * FSPlugin.Copy_Copier e y * FSPlugin.Copy_Original e x *"
                                    @" (z : Entity) * FSPlugin.Copy_Result e z"];
  
  [self autoAddTransitiveVerb:@"duplicate"
                    semantics:@"\\(x : Entity) -> \\(y : Entity) -> \\(e : Event) ->"
                                    @" FSPlugin.Copy e * FSPlugin.Copy_Copier e y * FSPlugin.Copy_Original e x *"
                                    @" (z : Entity) * FSPlugin.Copy_Result e z"];
  
  [self setDispatchPredicate:@"Copy"
                    keywords:@[@"Copy_Copier",@"Copy_Original",@"Copy_Result"]
                      method:@selector(copyCopier:original:result:eventSet:)];
  
  /*
   *  We can also define the nominalization of "copy", this time without
   *  automatically deriving the morphology just as an example, by specifying
   *  the semantics. To be a copy, of course, means to be the result of an
   *  event of copying.
   */
  
  [self addCountNounSg:@"copy"
                    pl:@"copies"
             semantics:@"\\(x : Entity) -> (e : Event) * FSPlugin.Copy e * FSPlugin.Copy_Result e x"];
  
  
  
  
  
  
  /*
   *  Adverbial Arguments
   *
   *  Some verbs, like "move" or "go", really want more arguments that just
   *  a subject or object. In these cases, to really make sense of the words
   *  in the context of a file system, you want a destination as well. It's
   *  no good just saying "move the file" or "go" -- to where? We'll automatically
   *  derive the morphology and meaning for these, but then we'll dispatch on
   *  keywords with a Dest argument as well, which we'll provide adverbially.
   */
  
  [self autoAddTransitiveVerb:@"move"];
  
  [self setDispatchPredicate:@"AutoEvent_Move"
                    keywords:@[@"Subj",@"Obj",@"Dest"]
                      method:@selector(moveSubj:obj:dest:eventSet:)];
  
  
  [self autoAddIntransitiveVerb:@"go"];
  
  [self setDispatchPredicate:@"AutoEvent_Go"
                    keywords:@[@"Subj",@"Dest"]
                      method:@selector(goSubj:dest:eventSet:)];
  
  /*
   *  Now we can define the adverb that will supply the destination argument.
   *  We use the method addLexicalEntry:category:semantics: which is a more
   *  general way of adding words to the plugin that requires we also specify
   *  what syntactic category the word has. In this case, it's a preposition
   *  which produces a sentential adverbial.
   */
  
  [self addLexicalEntry:@"to"
               category:@"(S[_0]\\S[_0])/D[_,_,acc,_]"
              semantics:@"\\(x : Entity) -> \\(p : Event -> Prop) -> \\(e : Event) -> p e * Dest e x"];
  
  
  
  
  
  
  /*
   *  Presuppositions
   *
   *  When navigating, we sometimes want to simply say "go up" or "go back".
   *  To do this, we'll presuppose the existence of some entities that represent
   *  the abstract "up" and "back" directions, and specify those as the destination
   *  argument. We'll define appropriate event predicates to pick out those
   *  entities.
   */
  
  [self addPredicate:@"UpDirection"];
  [self addPredicate:@"BackDirection"];
  
  /*
   *  The adverbials are now very similar to the meaning for "to", except we're
   *  using `require` to ask the presupposition solver to find the appropriate
   *  entity for us. In the case of "up", for instance, we're asking the solver
   *  to find the unique entity which is the up direction. That entity is then
   *  used as the destination of the event.
   */
  
  [self addLexicalEntry:@"up"
               category:@"S[_0]\\S[_0]"
              semantics:@"\\(p : Event -> Prop) -> \\(e : Event) ->"
                            @"p e * (require x : Entity"
                                  @" in require _ : (s : Event) * FSPlugin.UpDirection s * Exp s x"
                                  @" in Dest e x)"];
  [self addLexicalEntry:@"back"
               category:@"S[_0]\\S[_0]"
              semantics:@"\\(p : Event -> Prop) -> \\(e : Event) ->"
                            @"p e * (require x : Entity"
                                  @" in require _ : (s : Event) * FSPlugin.BackDirection s * Exp s x"
                                  @" in Dest e x)"];
  
  
  return YES;
}




/*
 *  Every plugin must specify how it analyzes the context it finds itself it.
 *  That is to say, it has to sort of look at the world and decide what it can
 *  see, etc.
 */
- (void)analyzeWorld {
  /*
   *  We'll say that we can see two entities, corresponding to the abstract
   *  directions up and back, and we'll also assert that those entites are
   *  indeed the up and back directions.
   */
  
  upDir = [self newEntity];
  backDir = [self newEntity];
  
  [self assertEventPredicate:@"UpDirection"
                   arguments:@{ @"Exp": @[upDir] }];
  
  [self assertEventPredicate:@"BackDirection"
                   arguments:@{ @"Exp": @[backDir] }];
  
  
  
  
  /*
   *  We'll also look at the contents of the current directory, and make
   *  entities corresponding to them. We'd better also classify them as
   *  to what they are, so that our nouns can get at them. For GIFs and JPEGs,
   *  we classify them as files as well. Also notice that everything has an
   *  associated entity representing it's name, who's string value is the name
   *  within the current directory.
   */
  
  NSError* err;
  NSArray* contents = [fileManager contentsOfDirectoryAtPath:currentDirectory error:&err];
  
  NSString* location;
  NSString* extension;
  LEEntity* item;
  LEEntity* itemName;
  
  for (int i = 0; i < [contents count]; i++) {
    location = [contents objectAtIndex:i];
    
    if ([[location substringToIndex:1] isEqualToString:@"."]) { continue; }
    
    extension = [location pathExtension];
    item = [self newEntity];
    itemName = [self newEntity];
    
    [itemName setStringValue: location];
    [self assertEventPredicate:@"Named"
                     arguments:@{ @"Exp": @[item], @"Name": @[itemName] }];
    
    if ([extension isEqualToString:@""]) {
      
      [self assertEventPredicate:@"AutoEvent_Folder"
                       arguments:@{ @"Exp": @[item] }];
      
    } else {
      
      [self assertEventPredicate:@"AutoEvent_File"
                       arguments:@{ @"Exp": @[item] }];
      
      if ([extension isEqualToString:@"JPEG"] ||
          [extension isEqualToString:@"jpeg"] ||
          [extension isEqualToString:@"JPG"]  ||
          [extension isEqualToString:@"jpg"]) {
        
        [self assertEventPredicate:@"AutoEvent_JPEG"
                         arguments:@{ @"Exp": @[item] }];
        
      } else if ([extension isEqualToString:@"gif"] ||
                 [extension isEqualToString:@"GIF"]) {
        
        [self assertEventPredicate:@"AutoEvent_GIF"
                         arguments:@{ @"Exp": @[item] }];
        
      }
      
    }
  }
  
}





/*
 *  To show some entities, we'll simply display the string values for their
 *  names. To get their names, we'll use the description of the world model.
 *  This lets us find events that have a given structure, which in this case is
 *  events with the predicate "Named" and with the "Exp" arg being precisely the
 *  entity we expect to have a name. We then simply ask these naming events what
 *  the name entity is, and take its string value. This pattern will be used
 *  repeatedly in this project.
 */
- (BOOL)showSubj:(NSArray*)shower
             obj:(NSArray*)shown
          eventSet:(LEEventSet*)evs {
  
  NSMutableArray* shownNames = [NSMutableArray new];
  
  for (LEEntity* ent in shown) {
    // let's just assume there will always be exactly one name.
    [shownNames
     addObject: [[[[[[self worldModelDescription]
                       findEventsPredicate: @"Named"
                       arguments: @{ @"Exp": @[ent] }]
                     objectAtIndex:0]
                    argumentsForKeyword: @"Name"]
                   objectAtIndex: 0]
                 stringValue]];
  }
  
  // Display the names of the items.
  
  for (NSString* shownName in shownNames) {
    [appDelegate displayString:shownName];
    [appDelegate displayString:@"\n"];
  }
  
  return YES;
}




/*
 *  To move something somewhere, we'll simply use NSFileManager, with the names,
 *  together with the current directory to specify the full paths. We'll also
 *  explicitly make sure that the destination exists before we move anything to
 *  it, that way we can implicitly create things by mentioning them with
 *  indefinite noun phrases.
 *
 *  Because moving things changes what the plugin can see, we ought to flag that
 *  we need to refresh the world model.
 */
- (BOOL)moveSubj:(NSArray*)mover
             obj:(NSArray*)moved
            dest:(NSArray*)dest
        eventSet:(LEEventSet*)evs {
  
  if (1 != [dest count]) {
    // Cannot move items to 0 or multiple destinations. Display an error message.
    [appDelegate displayString: @"Cannot move items to 0 or multiple destinations."];
    return NO;
  }
  
  // again we'll assume things have only one name
  NSString* destName = [[[[[[self worldModelDescription]
                            findEventsPredicate: @"Named"
                            arguments: @{ @"Exp": @[[dest objectAtIndex: 0]] }]
                           objectAtIndex:0]
                          argumentsForKeyword: @"Name"]
                         objectAtIndex: 0]
                        stringValue];
  
   if (nil == destName) {
    // Cannot move items to a destination that has an unespecified location. Display an error message.
    [appDelegate displayString:@"Cannot move items to a destination that has an unespecified location."];
    return NO;
  }
  
  [self ensureExists:destName];
  
  NSMutableArray* movedNames = [NSMutableArray new];
  
  // and again one name
  for (LEEntity* ent in moved) {
    // let's just assume there will always be exactly one name
    [movedNames addObject: [[[[[[self worldModelDescription]
                                findEventsPredicate: @"Named"
                                arguments: @{ @"Exp": @[ent] }]
                               objectAtIndex:0]
                              argumentsForKeyword: @"Name"]
                             objectAtIndex: 0]
                            stringValue]];
  }
  
  // Move the specified items to the destination.
  
  for (NSString* movedName in movedNames) {
    [appDelegate displayString: [NSString
                                 stringWithFormat:@"moving %@ to %@\n", movedName, destName]];
    
    [fileManager moveItemAtPath:[currentDirectory stringByAppendingFormat: @"/%@", movedName]
                         toPath:[currentDirectory stringByAppendingFormat: @"/%@/%@", destName, movedName]
                          error:nil];
  }
  
  [self setShouldRefreshWorldModel];
  
  return YES;
}





/*
 *  To make something, we need to know what sort of thing we're making. For
 *  simplicity, we'll only make folders.
 *
 *  We'll use the same ensureExists: method that we used in moveSubj:obj:dest:
 *  to handle the creation of the directory. No point in re-creating a directory
 *  if one already exists with the name in question!
 */
- (BOOL)makeSubj:(NSArray*)maker
             obj:(NSArray*)made
        eventSet:(LEEventSet*)evs {
  
  for (LEEntity* ent in made) {
    // Use the background events to create an item in the FS of the right sort.
    // Currently lets only make folders.
    
    BOOL isFolder = 0 != [[[self worldModelDescription]
                           findEventsPredicate:@"AutoEvent_Folder"
                                     arguments:@{ @"Exp": @[ent] }]
                          count];
  
    NSString* itemName = [[[[[[self worldModelDescription]
                              findEventsPredicate: @"Named"
                                        arguments: @{ @"Exp": @[ent] }]
                             objectAtIndex:0]
                            argumentsForKeyword: @"Name"]
                           objectAtIndex:0]
                          stringValue];
    
    if (isFolder && nil != itemName) {
      
      [self ensureExists:itemName];
      
    }
  }
  
  return YES;
}





/*
 *  Copying is relatively easy, like moving, except we also need to remember
 *  what the name on disk is of the copy that's produced.
 */
- (BOOL)copyCopier:(NSArray*)copier
          original:(NSArray*)orig
            result:(NSArray*)res
          eventSet:(LEEventSet*)evs {
  
  if (1 != [orig count] || 1 != [res count]) {
    // Can only copy a single item into a a single item. Display an error?
  }
  
  // just one name
  NSString* originalName = [[[[[[self worldModelDescription]
                                findEventsPredicate: @"Named"
                                arguments: @{ @"Exp": @[[orig objectAtIndex: 0]] }]
                               objectAtIndex:0]
                              argumentsForKeyword: @"Name"]
                             objectAtIndex:0]
                            stringValue];
  if (nil == originalName) {
    // Cannot copy an unspecified item. Display an error.
  }
  
  LEEntity* result = [res objectAtIndex: 0];
  NSString* extension = [originalName pathExtension];
  
  // Make a copy of the item, and set the copy's location to be the string value of result
  
  NSString* resultName = [NSString
                          stringWithFormat: @"%@-copy.%@",
                                           [originalName stringByDeletingPathExtension],
                                           extension];
  
  [fileManager copyItemAtPath:[currentDirectory stringByAppendingFormat: @"/%@", originalName]
                       toPath:[currentDirectory stringByAppendingFormat: @"/%@", resultName]
                        error:nil];
  
  LEEntity* resultNameEntity = [self newEntity];
  [resultNameEntity setStringValue: resultName];
  [self assertEventPredicate:@"Named"
                   arguments:@{ @"Exp": @[result], @"Name": @[resultNameEntity] }];
  
  if ([extension isEqualToString:@"JPEG"] ||
      [extension isEqualToString:@"jpeg"] ||
      [extension isEqualToString:@"JPG"]  ||
      [extension isEqualToString:@"jpg"]) {
    
    [self assertEventPredicate:@"AutoEvent_JPEG"
                     arguments:@{ @"Exp": @[result] }];
    [self assertEventPredicate:@"AutoEvent_File"
                     arguments:@{ @"Exp": @[result] }];
                                  
  } else if ([extension isEqualToString:@"GIF"] ||
             [extension isEqualToString:@"gif"]) {
    
    [self assertEventPredicate:@"AutoEvent_GIF"
                     arguments:@{ @"Exp": @[result] }];
    [self assertEventPredicate:@"AutoEvent_File"
                     arguments:@{ @"Exp": @[result] }];
                                  
  } else {
    
    [self assertEventPredicate:@"AutoEvent_Folder"
                     arguments:@{ @"Exp": @[result] }];
    
  }
  
  return YES;
}





/*
 *  Going places is also simple. Rather than using descriptions (which is possible),
 *  we stored the entities that represent the up and back directions, and can
 *  use equality tests to decide if the destination is in fact one of those
 *  directions. However, the description approach works just as well. Since we
 *  want "go back" to mean "go to the place I was before this", we need to
 *  store the previous location whenever we change directories.
 *
 *  Additionally, because changing directories changes what the plugin can see,
 *  we ought to flag that we need to refresh the world model, like with moving.
 */
- (BOOL)goSubj:(NSArray*)subj
          dest:(NSArray*)dest
      eventSet:(LEEventSet*)evs {
  
  if (1 != [dest count]) {
    // Can only go to one place at a time.
  }
  
  LEEntity* destination = [dest objectAtIndex:0];
  
  if ([destination isEqual: upDir]) {
    // go up
    
    if ([currentDirectory isEqualToString:@"/"]) {
      // cant go up
      [appDelegate displayString:@"There is no place to go up to.\n\n"];
      return NO;
    }
    
    previousDirectory = currentDirectory;
    currentDirectory = [currentDirectory stringByDeletingLastPathComponent];
    
    
  } else if ([destination isEqual: backDir]) {
    // go back
    
    if (nil == previousDirectory) {
      // no previous location
      [appDelegate displayString:@"There is no place to go back to.\n\n"];
      return NO;
    }
    
    NSString* nextDirectory = previousDirectory;
    previousDirectory = currentDirectory;
    currentDirectory = nextDirectory;
    
    
  } else {
    // go to a specified location
    
    NSString* destName = [[[[[[self worldModelDescription]
                              findEventsPredicate: @"Named"
                              arguments: @{ @"Exp": @[destination] }]
                             objectAtIndex:0]
                            argumentsForKeyword: @"Name"]
                           objectAtIndex:0]
                          stringValue];
    
    if (nil == destName) {
      // Cannot go to an unspecified location. Display an error.
      [appDelegate displayString:@"Cannot go to an unspecified location."];
      return NO;
    }
    
    if (![[destName pathExtension] isEqualToString:@""]) {
      // cannot go to a file
      [appDelegate displayString:@"Cannot go to a file."];
    }
    
    // Change the current directory then refresh the world model
    
    previousDirectory = currentDirectory;
    currentDirectory = [currentDirectory stringByAppendingFormat:@"/%@", destName];
  }
  
  [self setShouldRefreshWorldModel];
  
  return YES;
}




/*
 *  Lastly, this is the method that we use to ensure that a directory exists.
 */
- (void)ensureExists:(NSString*)dirName {
  [fileManager createDirectoryAtPath:[currentDirectory stringByAppendingFormat:@"/%@", dirName]
         withIntermediateDirectories:NO
                          attributes:nil
                               error:nil];
}

@end
