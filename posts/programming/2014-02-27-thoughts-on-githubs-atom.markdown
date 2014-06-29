---
author: richardgoulter
comments: true
date: 2014-02-27 10:19:33+00:00
layout: post
slug: thoughts-on-githubs-atom
title: Thoughts on GitHub's Atom
wordpress_id: 200
tags: editors, atom
---

Programmers love to discuss and argue over irrelevant issues. One such issue is "which text editor to use".
Some folk side-step the issue with the pragmatic "use whatever works", but that misses out on the fun.

The current state of things is that for the hardcore, Vim and Emacs are the editors of choice. Sublime Text (ST) is also common for my classmates, who skip the 70 USD pricetag (either by piracy or by keeping-with the "please by this" shareware type dialogs).

Well. Can't help but agree with the idea that FOSS is a great way to get something without having to pay for it. (maximum reward, minimum effort). http://www.codinghorror.com/blog/2004/11/free-as-in-beer.html

In case you haven't met the discussion on editors before, Vim & Emacs, despite having (the reputation of) a tough learning curve to get into, have the reputation for being the best around at what they do.
The less-informed will often be bemused as to why people would "still" use editors which are 20 - 40 years old. What isn't immediately apparent is, say, the ethos among Vim users reduce time-wasting as much as possible. (Now that I think about it, VimGolf probably lampoons this idea. Huh).

As I understand things, though: Vim's customisability comes through VimL, and Emacs can be customised using (Emacs) Lisp. (One of Yegge's rants has discussion about ELisp. http://steve-yegge.blogspot.sg/2008/11/ejacs-javascript-interpreter-for-emacs.html -- That was in 2008, and Wikipedia tells me ELisp now has lexical scoping as of 2012).
I've no idea whether VimL is a bad language.
Regardless, my understanding is both programs suffer from not being multi-threaded. (A 5 second google search yields this about emacs http://www.emacswiki.org/emacs/NoThreading)

So. Even though Vim/Emacs folk can probably get pretty snobbish about what's best (and so unfriendly towards new entrants), I would believe that it'll be possible for an editor to come along and do the same-thing-but-better.
Perhaps something for which a modern language is to the editor as VimL is to Vim, ELisp is to Emacs.

- So it's exciting to see editors like this come along.
ST's extensibility is in Python. (But I hear it's not all that extensible. And surely something which costs 70 USD can't be all that hacker-friendly..).
One cool editor to come along recently was LightTable, also. (It's FOSS!). LightTable's aim, however, is about the programming environment more-than the text editor itself. (Apparently the smalltalk kids from 30 years ago all say "Yeah, I remember doing it this way back then).

Anyway.
GitHub's Atom recently released it's "open beta". My classmates are sharing beta keys with each other. (Note that with FOSS, you can just share the code instead).
There was some interesting reading to be had looking into this:

"I must be out of touch with modern development. I don't understand the thought process that leads people to be excited about a closed source, node.js text editor that reports your usage to Google."
from http://www.reddit.com/r/programming/comments/1z0ykn/atom_launched/
-- I like this comment.
NodeJS is unpopular for being JS.. but it also suffers single-threadedness in a way. (It "solves" this through asynchronous calls, as far as I know).
And the "reports your usage to Google" is more of a FUD remark, and somewhat baseless at that.

The closed-source "controversy" brings with it a link to this:
http://discuss.atom.io/t/why-is-atom-closed-source/82/7
Apparently, GitHub hope to keep the "core" closed-source and monetizable, but have the eco-system about it open-source.

Top-Comment on the pretentious Hacker News is that old joke:


From "The Zen of Programming":
------
Hearing a disturbance, the master programmer went into the novice's cubicle.
"Curse these personal computers!" cried the novice in anger, "To make them do anything I must use three or even four editing programs. Sometimes I get so confused that I erase entire files. This is truly intolerable!"
The master programmer stared at the novice. "And what would you do to remedy this state of affairs?" he asked.
The novice thought for a moment. "I will design a new editing program," he said, "a program that will replace all these others."
Suddenly the master struck the novice on the side of his head. It was not a heavy blow, but the novice was nonetheless surprised. "What did you do that for?" exclaimed the novice.
"I have no wish to learn another editing program," said the master.
And suddenly the novice was enlightened.


https://news.ycombinator.com/item?id=7308071


Anyway. Further down the page, we again see a comment like:
> A hackable text editor for the 21st century
I'll fix: A proprietary (unhackable) text editor that only runs on OS X.


Apparently the editor will be available on other OSs later. But again, the conflict between "hackable" and "proprietary".
The complaints about lack of FOSS aren't purely driven by the desire for free-as-in-beer, though:


I developed some packages for HomeSite in the 90s. When HomeSite was integrated into Dreamweaver and development ceased, I realized that I had wasted my time developing HomeSite packages and that I should never again devote my time to extending closed-source software. Emacs has served me well ever since.


Because the codebase for the "hackable" software was proprietary, effort to be a part of the eco-system is volatile.

Anyway.
HackerNews has another thread about its closed-sourced-ness:
https://news.ycombinator.com/item?id=7310017
The top comment here is quite good:


As far as I'm concerned GitHub is free to handle the licensing of their software however they like, but this opens up an interesting thought experiment:




We now have at least two companies making significant Chromium-based editors, one is Adobe and the other is GitHub.
One of them is developing the core of their editor technology using a fully open-source model (hosted on GitHub, naturally) under a well-understood and widely accepted license, the other isn't (or at least isn't currently planning to).




2 years ago, who among you would have guessed correctly that the one whose editor was open source would be Adobe's?


It was pointed out GH don't open-source everything. (They haven't open-sourced their desktop GH clients, for example). Further down the page, we find a good discussion point to this:


In an article aptly titled "Open source (almost) everything", GitHub co-founder and current president Tom Preston-Werner writes[0], "Don't open source anything that represents core business value."
He specifically mentions two examples of what not to open source:




Core GitHub Rails app (easier to sell when closed)
The Jobs Sinatra app (specially crafted integration with github.com)




Now, I'd find the argument really stretched thin if you were to tell me that a text editor is your core selling point. Where does a text editor fit into GitHub's overarching mission?




[0] http://tom.preston-werner.com/2011/11/22/open-source-everything.html


The attitude of entitlement is complained about just below that.
Expecting Open-Source certainly does seem entitled.
The above quote seems a good point. (Would GH really suffer financially if it open-sourced the whole editor?).
What's-more, I gotta agree with those that point out there are many other great free (as in beer and speech) editors out already.


Though I wouldn't worry much about Opensourcing, I might think twice to pay for a Text Editor - considering that there are really good free alternatives.


Quite cutely, the comment just below this points out how all the ST3 kids seem quite excited about jumping ship to Atom, but all the Emacs/Vim folk are quite happy with their FOSS editors.



What I gather from all this is that, while I can still hope for something new to come along, Atom just isn't going to be it. (And I should perhaps take a look at Brackets).
