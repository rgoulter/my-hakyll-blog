---
author: richardgoulter
comments: true
date: 2014-01-06 14:41:19+00:00
layout: post
slug: installing-haskell-platform-for-linux-mint-16
title: Installing Haskell Platform for Linux Mint 16
wordpress_id: 178
tags: haskell, linux
---

Computers are great when they work, frustrating when they don't. -- Probably a better indication of how "hard" something is to use isn't just how simple/complex it may be when all things go right, but what obstacles there are when things don't, and how easy it is to get around these.

Installing the Haskell Platform, oddly, was much easier on Windows than on Linux Mint. (Although apparently folk point out that Mint isn't really a developer OS. Whatever).

Linux Mint lacks a "haskell-platform" package, which means installing the haskell-platform is harder than I'm used to as a Linux user.

Google is my friend.
The following links were useful for me:
[http://askubuntu.com/questions/286764/how-to-install-haskell-platform-for-ubuntu-13-04](http://askubuntu.com/questions/286764/how-to-install-haskell-platform-for-ubuntu-13-04)
[http://stackoverflow.com/questions/13057254/how-to-fix-error-2-when-trying-to-make-haskell-platform](http://stackoverflow.com/questions/13057254/how-to-fix-error-2-when-trying-to-make-haskell-platform)

Things I'd note, from a fresh install of Linux Mint 16 (Petra):



	
  * To compile the haskell-platform from sources, (well, 2013.2.0.0), you need to have GHC 7.6.3.
Linux Mint has this already in its software repository. :-)
"sudo apt-get install ghc" should be enough, but check the version of course.

	
  * Even with the right GHC version, you need a bunch of other dependencies before you can do the "./configure" step to build the haskell-platform.
As the first link above mentions,`
sudo apt-get install libgl1-mesa-dev libglc-dev freeglut3-dev libedit-dev libglw1-mesa libglw1-mesa-dev`
Should be enough for the configure step. (You could otherwise try the "try configuire, install whatever's missing" thing, too).

	
  * Following the above, I then ran into Error 2 on the "make" step, exactly the same as the second link above.
The accepted answer is useless, since there is no "haskell-platform" package; but the second answer which suggested:
`sudo apt-get install ghc*-prof`
worked for me. :-)


Did kinda suck running into difficulties, but it wasn't too bad I suppose.
