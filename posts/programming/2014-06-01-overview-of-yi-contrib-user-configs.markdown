---
author: richardgoulter
comments: true
date: 2014-06-01 11:59:08+00:00
layout: post
slug: overview-of-yi-contrib-user-configs
title: Overview of Yi Contrib User Configs
wordpress_id: 240
tags: editors, yi, haskell
---

The Yi editor repository on GitHub has a yi-contrib folder with some sample configurations of Yi, which contains about a dozen Haskell files which are hopefully useful to new Yi users.

See [https://github.com/yi-editor/yi/tree/master/yi-contrib/src/Yi](https://github.com/yi-editor/yi/tree/master/yi-contrib/src/Yi)

**[FuzzyOpen.hs
](https://github.com/yi-editor/yi/blob/master/yi-contrib/src/Yi/FuzzyOpen.hs)**"aims to provide (the essential subset of) the same functionality that vim plugins ctrlp and command-t provide."
It's written as a module, so that configurations can import the module and add the functionality with a statement like:


(ctrlCh 'p' ?>>! fuzzyOpen)


**[Template.hs](https://github.com/yi-editor/yi/blob/master/yi-contrib/src/Yi/Templates.hs)
**isn't as "well commented" as FuzzyOpen, but seems to be a module for ... inserting templates.
(It looks like the templates are embedded in the Haskell code).

[**Style/Misc.hs**](https://github.com/yi-editor/yi/blob/master/yi-contrib/src/Yi/Style/Misc.hs)
contains some code which is a module for two custom colour schemes. (Related, [Yi/Style/Library.hs of the main codebase](https://github.com/yi-editor/yi/blob/master/yi/src/library/Yi/Style/Library.hs) has two color schemes, default and darkBlueTheme).

**Config/Users
**The configs below appear to all be written as Haskell modules.
My understanding is this allows them to be used from yi-contrib package from Haddock, but a yi.hs config file adapted from these would look largely the same.

[Amy.hs](https://github.com/yi-editor/yi/blob/master/yi-contrib/src/Yi/Config/Users/Amy.hs)
shows a module using the CUA keymap, which adds a keymap with a "helloworld" which inserts the text "helloworld". (The same "helloworld" as from what shows up in a Google search for ["Yi tutorial"](http://www.nobugs.org/developer/yi/example-helloworld.html), from nobugs.org).

[Anders.hs](https://github.com/yi-editor/yi/blob/master/yi-contrib/src/Yi/Config/Users/Anders.hs)
prefers the Emacs keymap; the config adds an "increase indent" functionality, as well as some Haskell mode hooks are added to Precise Haskell mode.

[Cmcq.hs](https://github.com/yi-editor/yi/blob/master/yi-contrib/src/Yi/Config/Users/Cmcq.hs)
which configures: "If Yi is called with parameter "--type", it will insert 500 characters and exit. With "--open", it will open a buffer, type, and kill the buffer, 50 times. Pango and Vty frontends are supported."

[Corey.hs](https://github.com/yi-editor/yi/blob/master/yi-contrib/src/Yi/Config/Users/Corey.hs)
a typical yi.hs "that uses the Vim keymap with these additions:
- Always uses the VTY UI by default.
- The color style is darkBlueTheme
- The insert mode of the Vim keymap has been extended with a few additions I find useful."

[Ertai.hs](https://github.com/yi-editor/yi/blob/master/yi-contrib/src/Yi/Config/Users/Ertai.hs)
I have no idea what this does; I don't know what to highlight. Some things about mode tables and hooks, Greek letters / symbol insertion.. deleting soft-tab spaces as if they were hard-tabs..

[Gwern.hs](https://github.com/yi-editor/yi/blob/master/yi-contrib/src/Yi/Config/Users/Gwern.hs)
adds a "go to line" to the Emacs keymap, and has a "best Haskell mode" (which is what the others call haskellModeHooks).
A relatively short config.

[JP.hs](https://github.com/yi-editor/yi/blob/master/yi-contrib/src/Yi/Config/Users/JP.hs)
has a bunch of good things. More than Ertai.hs.

[Jeff.hs](https://github.com/yi-editor/yi/blob/master/yi-contrib/src/Yi/Config/Users/Jeff.hs)
fine tunes the Vim keymap and Vim (Haskell) snippets.

[Michal.hs](https://github.com/yi-editor/yi/blob/master/yi-contrib/src/Yi/Config/Users/Michal.hs)
heavily configures things, with a custom colour theme, and a "Diary mode".

[Reiner.hs](https://github.com/yi-editor/yi/blob/master/yi-contrib/src/Yi/Config/Users/Reiner.hs)
has some cool custom functionality like compileLatex, global keybindings, and a function to insert fancy section comments.



(There's also [JP's Experimental keymap](https://github.com/yi-editor/yi/blob/master/yi-contrib/src/Yi/Config/Users/JP/Experimental.hs)).
