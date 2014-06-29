---
author: richardgoulter
comments: true
date: 2014-04-26 16:09:11+00:00
layout: post
slug: vim-and-ios-programming
title: Vim and iOS Programming
wordpress_id: 224
tags: editors, vim, ios, linkdump
---

This last semester I've been having to do iOS programming.

I'm not an expert Vim user, but I use Vim enough such that, without being overzealous, I found I really missed the motion keys and other such things.

Others have gone before me on this topic. [Here](http://ap4y.github.io/2013/11/10/vim-for-ios-developers.html), [here](http://appventure.me/2013/01/29/use-vim-as-xcode-alternative-ios-mac-cocoa/), [here](http://blog.patspam.com/2014/vim-objc-code-completion); (and the *other* text editor has some stuff like [here](http://roupam.github.io/)).

Fortunately for at least that much, the [XVim plugin](https://github.com/JugglerShu/XVim) for XCode works reasonably well for emulating the core Vim features for manipulating text, while still allowing for XCode's other features like autocompletion and debugging.
(Every now and then these would slightly collide, but the convenience of motion commands outweighs the inconveniences you'll run into if not too careful. - The biggest problem I encountered was the conflict between XCode's parameter-filling in with like _<# int #>_ or so).

\- But, honestly, while Vim emulation is much more powerful than having to make the expense of using a mouse, what I really missed from Vim was fuzzy autocompletion (with [YouCompleteMe](https://github.com/Valloric/YouCompleteMe)).
"fuzzy autocompletion" is great. The "autocompletion" part I'm sure we all understand. XCode has that. It's a big advantage in using IDEs. The "fuzzy" bit may be less common; to the layman it you could describe it as "matching by taking some of the letters, in order". Well. It's a subsequence, anyway. So rather than matching **getL**ength as **getL**, you could match with **glth** (**g**et**L**eng**th**) instead.
Well. Just look at the gif on the link above. It's super-cool, by way of being super useful.
[EDIT: If I do want fuzzy autocomplete in XCode, this looks like a plugin/patch which can achieve that].

(To play devil's advocate; if you remember the name of the method, you should probably be able to type it out quicker than if you're using autocomplete; with autocomplete, it takes time to stop and look at a list of candidate options; then time to figure out whether it'd be quicker to type more letters to narrow down candidates, or scroll through the list to what you want).

When I say to my peers I want to use Vim, it's only half-right for them to point to Vim emulation.
More than the core Vim stuff, I want my Vim plugins; the Vim I've spent time configuring to be _my_ editor. (It's said of pens with nibs, that after enough use the nib has worn down to match your writing style, so in a way it's uniquely your pen and not anyone else's).

The biggest trouble right now for setting up Vim with XCode is the autocompletion.
Interface Development is not something Vim will easily be able to handle. In theory the hardcore could just edit the Storyboard xml raw, I suppose.
Debugging also deserves some consideration. (ap4y's writeup mentions this, in particular the vim-lldb plugin). But it's easier to just consider to do it in XCode. (or from the command-line's lldb using [ios-deploy](https://github.com/phonegap/ios-deploy), say).

Autocompletion. Vim's YCM can do autocompletion if given a compile_commands.json.
The easiest way to generate this file is using the oclint-xcodebuild tool. ([Here is a writeup](http://blog.patspam.com/2014/vim-objc-code-completion) with a detailed discussion on how to do this).

But, as ap4y discusses [here](https://github.com/Valloric/YouCompleteMe/issues/84#issuecomment-29862144), Vim's YCM at the moment isn't very good at Objective-C completion.
It seems to me the biggest thing YCM lacks is described by [YCM/Issue#234](https://github.com/Valloric/YouCompleteMe/issues/234), "better argument completion".
-- The user who reported that issue [forked YCM and has a branch](https://github.com/oblitum/YouCompleteMe/tree/clang_complete-params) wherein the hack a solution together to get "argument completion" for the Clang things. (C/C++/Objective-C/etc.). - I've not given it a good try, but this seems, at the moment, the best option for what I'm after here.

Aside from Vim's YCM, the best way to get autocompletion for Objective-C appears to be [the clang_complete plugin](https://github.com/Rip-Rip/clang_complete). I wasn't able to get this working as for how I was hoping for (pressing Ctrl-X Ctrl-O is too much for autocomplete!); but might also be worth a try.

In conclusion, I think until YCM's Objective-C improves then XCode + XVim seems the safest bet. It appears that with some difficulty it is possible to get Vim working with an XCode/iOS project.
