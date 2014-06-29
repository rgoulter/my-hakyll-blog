---
author: richardgoulter
comments: true
date: 2013-09-28 15:10:26+00:00
layout: post
slug: gvim-and-javascript-with-ternjs
title: GVim and JavaScript with TernJS
wordpress_id: 128
tags: javascript, linux, programming, vim
---

Ok. So after cross-posting the GVim and Java from my NUS blog..

[YouCompleteMe](https://github.com/Valloric/YouCompleteMe) not only provides awesome functionality with EClim or Jedi (for Java / Python respectively). Since it can get along with (as I understand things) Vim's OmniComplete, then YCM works with other intelligent completion things like TernJS.

[TernJS](http://ternjs.net/), made by the same guy who did CodeMirror, does some pretty fancy JavaScript jazz, so [your text editor](https://github.com/marijnh/tern_for_vim) can (try to) infer a variables type, .. and can provide intelligent autocomplete suggestions.

Married with YCM, the intelligence and fuzzy-completion makes for what must surely be the most powerful JavaScript editing today.
(Well, I dunno what the emacs or Sublime kiddies are up to; they might be pretty close too).



But. This was one time where being a total noob left things easier for Windows than for Linux.
See, oddly enough, I managed to get this working on Windows while it was still blowing up at me on Linux.
(Since I don't want to battle my OS, I go with Linux Mint 15. I'm pretty sure Linux Mint is what comes up if you Google-search "easiest Linux to use").

Turns out I had two problems:
First was that "node" didn't actually run NodeJS, since this was changed due to name conflicts. A quick symlink solves this issue..
Second was that, since I was too lazy to build NodeJS from source, the version in I was running from the package-repository was ancient. Ancient.

I've not tried to build much from source on Windows.
By a poor selective case, I understand that [trying to build Vim on Windows is a total pain](https://bitbucket.org/Haroogan/vim-for-windows/src) in the arse. [Building it on Linux is really really easy](https://github.com/Valloric/YouCompleteMe/wiki/Building-Vim-from-source), though.

But I was lazy. Turns out that [to build NodeJS from source](https://github.com/joyent/node), after [downloading the code](http://nodejs.org/), was the stock-and-standard:

$ ./configure
$ make
$ sudo checkinstall

Well.
I used "checkinstall" rather than "make install",
but that's all there was to it, anyway.

And with 'node' being called as expected, with an actual up-to-date version of Node, TernJS worked like it should! Fantastic.
