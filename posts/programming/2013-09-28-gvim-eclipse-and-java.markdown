---
author: richardgoulter
comments: true
date: 2013-09-28 14:51:51+00:00
layout: post
slug: gvim-eclipse-and-java
title: GVim, Eclipse and Java
wordpress_id: 126
tags: eclipse, java, programming, vim
---

If you're going to be programming in Java, you're probably going to need some kind of autocomplete.

Eclipse IDE, we pretty much all should know, comes with that advantage.
So, while Notepad++ is great, you'd certainly much rather use Eclipse for such a thing.

But in the same way that Eclipse is better at this than Notepad++,
Vim is better than Eclipse for this.

A properly configured Vim has _awesome_ autocompletion capabilites.

As a brief aside, some things need to be clarified:
Eclipse is an IDE, and Vim is a text editor. When I say Eclipse is better for writing Java than Notepad++, I mean that Eclipse's _editor_ is better at writing Java than Notepad++. Of course, Eclipse comes with a suite of other features which probably make it more useful for other development tasks. e.g. I'm not yet aware of a debugger which rival's Eclipse's debugging.

But also, I'm not talking about how fundamental, pure Vim is better than Eclipse for Java.
An unconfigured Vim is damn-near unusable in this day and age..

Vim's autocompletion can be damn-amazing when Vim is configured with the plugin [YouCompleteMe](http://val.markovic.io/blog/youcompleteme-a-fast-as-you-type-fuzzy-search-code-completion-engine-for-vim), combined with integration with Eclipse via [eclim](http://eclim.org/).
(In a sense you're still using Eclipse with this).

What makes this setup better than Eclipse's editor is how fast and automatic the autocomplete popups show; as well as using subsequence matching (rather than substring), and the use of Tab to scroll through options (rather than using the arrow keys).

And if you're not one to want to Alt-Tab your way between Vim and Eclipse, eclim allows you to just use GVim as your code editor within Eclipse. (I've not tried out how this integrates with Eclipse in general, though).
