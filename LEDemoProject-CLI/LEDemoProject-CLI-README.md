Overview
========

In this project, we're going to build a simple command line app that can
understand a handful of words. The main vocabulary we'll be interested in
consists of the nouns "folder", "file", "JPEG", "GIF", and "copy", and the
verbs "show", "list", "move", "make", "copy", "duplicate", and "go". We'll also define
some auxiliary vocabulary.

The built-in English vocabulary for this demo includes the words

    a/an, the[sg], the[pl], every, and, called, 
  
This is an intentionally small vocabulary, chosen to exemplify interesting
capacities of Language Engine without being overwhelmingly large. The
meanings are as follows:


    Word     Meaning
    -------  -------
    
    a/an     \(p : Entity -> Prop) -> \(q : Entity -> Prop) ->
                  (x : Entity) * p x * q x
    
    every    \(p : Entity -> Prop) -> \(q : Entity -> Prop) ->
                  (xp : (x : Entity) * p x) -> q (fst(xp))
    
    the[sg]  \(p : Entity -> Prop) -> \(q : Entity -> Prop) ->
                  require x : Entity in
                  require _ : p x in
                    q x
    
    the[pl]  \(p : Entity -> Prop) -> \(q : Entity -> Prop) ->
                  require xps : Max ((x : Entity) * p x) in
                  unwrapMax xp : (x : Entity) * p x = xps in
                    p (fst(xp))
    
    and      \(q : Prop) -> \(p : Prop) -> (pf : p) * q
    
    called   \(str : String) -> \(p : Entity -> Prop) -> \(x : Entity) ->
                  p x * (n : Entity) * stringVal(n ; str) *
                        (s : Event) * Named s * Exp s x * Name s n
    

By default, the app will start life in the directory ~/LEDemoProject-CLI-Temp,
so you should create this directory. It's also useful to populate it with some
random folders and files, so you can test the functionality of the app. You can use the directory and images provided with this demo project, simply move them to your home directory.

After reading the commented source files, or better yet, in parallel with
reading, you should try the following commands (substituting appropriate
names where necessary). The last command is especially good.

- show the folders
- list the files
- list the JPEGs
- go to Folder0
- move random.jpg to folder0
- copy the GIFs
- copy the MP3s and go back
- make a folder called "Subfolder"
- duplicate every JPEG and move the copies to a folder called "dupes"

As a little challenge, try to figure out how to make the following commands
work. Hint: it should be pretty easy given what's already provided.

- copy the MP3s to Folder0
- copy the MP3s to a folder called "mp3s"