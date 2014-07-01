---
title: Yi in a Cabal Sandbox on OSX
author: Richard Goulter
tags: yi, haskell, osx
---

For the most part there are instructions for this on
[the GitHub repo for Yi](https://github.com/yi-editor/yi#installing-inside-a-cabal-sandbox).

Despite that, I ran into a difficulty or two when I tried this.  
[Like these errors](https://gist.github.com/rgoulter/8fde851e20fc913d1ed8)
One error which complained was trying to use `aeson-0.7.0.3`.
Installing a newer version of `aeson` into the sandbox resolved this. (For some reason,
changing the `yi.cabal` so that it had version 4.2 of the `lens` library
[which requires `aeson >= 0.7.0.5`] didn't resolve this. I don't suppose I
understand how Cabal works).

Having forgotten [how to install gtk2hs on OSX](http://www.haskell.org/haskellwiki/Gtk2Hs/Mac),
naturally I ran into difficulties with `cabal install -fpango`. (For some reason,
I had issues with GTK; `gtk-demo` failed to load. 
[Similar to this](http://stackoverflow.com/questions/22631026/dyld-library-not-loaded-usr-local-lib-libpng16-16-dylib-with-anything-php-rel)).
Word to the wise,

```
cabal install --with-gcc=gcc-4.8 -fvty -fpango
```

would be how to install it. (Alas, I'm
[plagued by errors](https://gist.github.com/rgoulter/d1e94a05dd93abaa078d)
when I try to install the Pango frontend. I was able to install it earlier..).
