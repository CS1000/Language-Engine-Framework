typedef enum { ProcessingError, ProcessingIndicative, ProcessingImperative, ProcessingInterrogative } ProcessingResult;

void haskell_init();
void haskell_exit();

typedef void Plugin;
typedef void PluginSystem;
typedef void Signature;
typedef void SignLexicon;
typedef void WorldModel;

ProcessingResult processInput(Signature* sig, SignLexicon* lx, WorldModel* wm, char* input,
                              WorldModel** wmOut, char** output, char** errOut);

Plugin* basePlugin();
Plugin* englishPlugin();                   

Plugin* emptyPlugin(char* name);
Plugin* addEventPredicate(char* prd, Plugin* plg);
Plugin* addEventRelation(char* rel, Plugin* plg);

Plugin* addLexicalEntry(char* frm, char* cat, char* sem, Plugin* plg);
Plugin* addCountNoun(char* sgf, char* plf, char* sem, Plugin* plg);
Plugin* autoAddCountNoun(char* sgf, Plugin* plg);
Plugin* addMassNoun(char* msf, char* sem, Plugin* plg);
Plugin* autoAddMassNoun(char* msf, Plugin* plg);
Plugin* addIntransitiveVerb(char* baref, char* perff, char* progf, char* passf, char* gerf,
                            char* fstSgPres, char* sndSgPres, char* thdSgPres,
                              char* fstPlPres, char* sndPlPres, char* thdPlPres,
                            char* fstSgPast, char* sndSgPast, char* thdSgPast,
                              char* fstPlPast, char* sndPlPast, char* thdPlPast,
                            char* sem, Plugin* plg);
Plugin* addTransitiveVerb(char* baref, char* perff, char* progf, char* passf, char* gerf,
                          char* fstSgPres, char* sndSgPres, char* thdSgPres,
                            char* fstPlPres, char* sndPlPres, char* thdPlPres,
                          char* fstSgPast, char* sndSgPast, char* thdSgPast,
                            char* fstPlPast, char* sndPlPast, char* thdPlPast,
                          char* sem, Plugin* plg);
Plugin* autoAddIntransitiveVerb(char* baref, Plugin* plg);
Plugin* autoAddIntransitiveVerbWithSemantics(char* baref, char* sem, Plugin* plg);
Plugin* autoAddTransitiveVerb(char* baref, Plugin* plg);
Plugin* autoAddTransitiveVerbWithSemantics(char* baref, char* sem, Plugin* plg);

PluginSystem* emptyPluginSystem();
PluginSystem* addPluginToSystem(Plugin* plg, PluginSystem* sys);
Signature* pluginSystemToSignature(PluginSystem* sys);

WorldModel* emptyWorldModel();
WorldModel* newEntity(WorldModel* wm, char** entOut);
char* entityStringValue(char* ent, WorldModel* wm);
WorldModel* assertStringValue(char* ent, char* str, WorldModel* wm);
WorldModel* assertEvent(char* assertion, WorldModel* wm, PluginSystem* sys);

char* describeWorldModel(WorldModel* wm);

SignLexicon* pluginSystemToLexicon(PluginSystem* sys);

char* debugShowLexicon(SignLexicon* lx);
char* debugShowSignature(Signature* sig);
char* debugShowWorldModel(WorldModel* wm);