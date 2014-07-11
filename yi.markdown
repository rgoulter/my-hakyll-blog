---
title: Yi
---

I thought it might make sense to have a page where I can dump all my Yi
related findings, rather than making tidbit posts about Yi.  
See [posts tagged 'Yi'](/tags/yi.html).

My impression of Yi [hasn't altered much](/posts/programming/2014-06-01-yi.html),
and I think maybe Yi isn't as Emacs as Emacs, or as Vim as Vim, and perhaps the code
is limited by that.

It also seems that to work on Yi, one would need to get familiar with its eDSL,
as well as having familiarity with the lens library.


# From a Vim Perspective

Using the name "Vim" can either refer to the Vim program itself, or maybe even
to the family of vim-emulators which try to emulate Vim behaviour.  
Often the latter are very second class.

Also inevitable is the vim emulators will miss out on some features of Vim.
Vim also has the quality of having many cool mechanics which many of its
users mightn't have heard about.

I suppose if Yi is easy enough to extend, these things shouldn't be hard to
include.  
Some things which are missing in Yi from Vim are posted in the Yi repo's
[issues](https://github.com/yi-editor/yi/search?q=vim&ref=cmdform&type=Issues),
although many of these may refer to the now removed Vim keymap, rather than
ethercrow/Dmitry Ivanov's Vim2 keymap.
[See here](https://github.com/yi-editor/yi/pull/554).



### Editing More Than One File
`:ls` will show a list of currently open buffers, and
`:buffer #` will go to that buffer number.

But there isn't a `:bnext`, `:bprev` which my muscle memory uses.  
(One could add this, right, but I wouldn't know how [See below], as of 2014-07-02).

I've not used
[arglist](http://vimdoc.sourceforge.net/htmldoc/editing.html#arglist) much,
but as a mutable subset of buffers list, I've heard it's an improvement over
aforementioned commands. (That, and some more).  
There's a [VimCast](http://vimcasts.org/episodes/meet-the-arglist/) on it.  
Not that I can complain (since I haven't used it in Vim),
but also not in the keymap.



### Line Numbers
By default Vim doesn't have line numbers on, and to get line numbers on Emacs
is kindof hackish, I hear.  
Maybe it's because of the Emacs crowd, but it's
not clear to me how to get line numbers on Yi. (as of 2014-07-02).

I haven't seen any screenshot of Yi with line numbers.


### Visual Mode
One of the cool things about Visual mode is the insertion/appending on multiple lines.  
See [the vim docs](http://vimdoc.sourceforge.net/htmldoc/visual.html#v_b_I).
The vim wiki [has some examples](http://vim.wikia.com/wiki/Inserting_text_in_multiple_lines).

I took a screenshot of Vim and of Yi for comparison about what their Visual
Lines modes look like:

**Vim**  
![](http://i.imgur.com/POtRl7m.png)

**Yi**  
![](http://i.imgur.com/0h2erqm.png)  
Using [this Yi.hs](https://github.com/rgoulter/dotfiles/blob/28b9712fc66c84121eed82113ab61c66b7d699f3/yi.hs)
with Vty frontend (terminal), in a terminal with Solarized colors theme.


### Command-line Window
This really shoots at "obscure Vim things", but I'm making a list of
differences I've noticed. This is the `q:`, `q/`, `q?` window which shows up.
[Vimdoc:cmdline-window](http://vimdoc.sourceforge.net/htmldoc/cmdline.html#cmdline-window).

(But I'm not sure how commonly this feature is used by Vim folk).


### Quickfix Window
Quickfix is not an obscure feature of Vim. (Though I don't use it as often as
I should). I'm not sure what Yi's support for Quickfix, or equivalent, is;
but I haven't looked. (as of 2014-07-02).
[Vimdoc:quickfix](http://vimdoc.sourceforge.net/htmldoc/quickfix.html).


### Tags
Yi appears to have some support for tags, which I need to look into.
(as of 2014-07-02).


## Searching
Yi does have Incremental Searching, and it does this the way Emacs does, which
is better than Vim.  
That is, while typing the search, all things which match are highlighted,
rather than just one entry.


## Jumplist
Yi does appear to have `C-I`, `C-O` for navigating between cursor jumps.  
The `:ju` Ex command to show the jumplist isn't there.  
The changelist (`g;`, `g,`) also doesn't appear to be implemented.
[Vimdoc:jump-motions](http://vimdoc.sourceforge.net/htmldoc/motion.html#jump-motions)

I've also seen `'.` used for "jump to last edit". Yi doesn't have this.  
[Vimdoc:'.](http://vimdoc.sourceforge.net/htmldoc/motion.html#\'.)


# Questions About Yi

*   *How to write in some extra function and bind it with a keymap?*

    The sample user configs have an example of this. e.g.
    [yi-contrib's Amy.hs](https://github.com/yi-editor/yi/blob/master/yi-contrib/src/Yi/Config/Users/Amy.hs),

    ```haskell
    myConfig = defaultCuaConfig {
        -- Keymap Configuration
        defaultKm = extendedCuaKeymapSet,
        ....
    }

    -- Add M-x (which is probably Alt-x on your system) to the default
    -- keyset, and have it launch our custom macro.
    extendedCuaKeymapSet = customizedCuaKeymapSet $
        choice [
            metaCh 'x' ?>>! helloWorld
        ]

    -- A custom macro
    helloWorld :: YiM ()
    helloWorld = withBuffer $ insertN "Hello, world!"
    ```

    Unfortunately, this is specifically for the CUA bindings. (Emacs, Vim don't
    get the equivalent of `customizedCuaKeymapSet`).  
    Fortunately, there are multiple ways to customize bindings for Vim. See
    [some notes](/posts/programming/2014-07-07-notes-from-some-examination-of-some-yi-configs.html)
    on this.

*   *How to add in some extra function and bind it to an Ex expression? (e.g. `:helloWorld`).*

    For this example, `:yi helloWorld` will execute `helloWorld :: YiM()`. See
    [Yi Ex command](https://github.com/yi-editor/yi/blob/master/yi/src/library/Yi/Keymap/Vim/Ex/Commands/Yi.hs).
    Well. This worked for me when using a Simple config, and when `publishAction`
    is used. (`publishAction "helloWorld" helloWorld` was enough).  
    For non-Simple configs, it's not clear how to 'publish' an Action, and trying
    the same doesn't work. What happens instead is Yi complains about
    `helloWorld` not being in scope.
    [Yi.Eval](https://github.com/yi-editor/yi/blob/master/yi/src/library/Yi/Eval.hs)
    mentions `$HOME/.config/yi/local/Env.hs`. Trying to put my
    `helloWorld` in here didn't work for me.

    It appears that this only works for functions of type `Yim()`, as opposed to
    `Int -> Yim()` or so. (Or, if possible, it's not as trivial as I'd hope).
    (as of 2014-07-08).

    If you really want to have an Ex command `:helloWorld`, then you need to
    implement an Ex command parser, and your code would look like:

    ```haskell
            defaultKM = mkKeymapSet $ defVimConfig `override` \ super self -> super
                { vimExCommandParsers = myExCmdParsers ++ vimExCommandParsers super }
    ```

    where `myExCmdParsers` is of type `[String -> Maybe ExCommand]`, something
    like `[helloWorldEC.parser, ...]`. While none of the samples have a custom
    Ex command,
    [here's](https://gist.github.com/rgoulter/5b291e7d00945661aa71/49bac9d873b885ee54ace67f99a99be53401f588)
    a simple Hello World example.

*   *How can I modularise code I write to customize Yi? e.g. like "source extra-stuff.vim"*

    The answer is _not_ to just put it in `~/.config/yi`, alongside `yi.hs`.
    Bummer. I asked about this on
    [the Google group](https://groups.google.com/forum/#!topic/yi-devel/hYvT2Sz4M3w).

    I was able to get my `yi.hs` to depend on a cabal project by doing:

    ```
        ~/github/yi/yi$ cabal sandbox add-source /path/to/dependency
        ~/github/yi/yi$ cabal install dependency-name
    ```

    where `~/github/yi/yi` is the location of my Yi sandbox. (Well, I've opted
    to use a Cabal sandbox for my Yi to avoid Cabal Hell).  
    When the dependency is updated, to register this with Yi I'd need to

    ```
        ~/github/yi/yi$ cabal install dependency-name and-things-which-depend-on-it
        ~/github/yi/yi$ touch ~/.config/yi.hs
    ```

    i.e. re-install the package to the cabal sandbox for yi, and then 'modify'
    the yi.hs file so that Yi will re-compile (and thus know about the updated
    dependency). "dependency" here, btw, could mean things like plugin, or
    aspects of a `yi.hs` which you'd rather have split up into different `.hs`
    files.

    If there are many such dependencies for your `yi.hs`, it may make sense
    to have a cabal package like `yi-config-rgoulter`; if this acts as the 
    'root' of your yi dependencies, then it means you'd only need to deal with
    installing this package. (Well, and adding the sources for the other
    dependencies, but a package typically updates more often than it's moved).

    At the extreme, you could have a one-liner `yi.hs` like:

    ```haskell
        import Yi.Config.Rgoulter
    ```

    because of how Haskell's packages work; the disadvantage of *that* is the
    need to constantly install `yi-config-rgoulter` as it updates, in contrast
    to just having Yi recompile a modified `yi.hs`.

*   *How to show a list of keybindings, or something else which can show me what Yi can do?*

    Haven't figured that out yet. (as of 2014-07-02).  
    [yi-editor/yi#504](https://github.com/yi-editor/yi/issues/504) touches upon
    this issue, with the suggestion of documenting the keybindings (since these
    don't change at a pace as to make this too awful).  
    Those with the programming bug, though, would rather have this done
    'automatically'.


# Troubles with Yi

*   For some reason, with
    [this config](https://github.com/rgoulter/dotfiles/blob/28b9712fc66c84121eed82113ab61c66b7d699f3/yi.hs),
    when I tried playing around with Vim macros, it didn't go well.  
    e.g. if I tried recording a macro by `qt^x$xq`, then print out this register
    `t`, what I get is `t^xx$xx`. (i.e. the keys appear to have been pressed twice).
    Something to look into. (This was with commit
    [e0e39f](https://github.com/yi-editor/yi/commit/e0e39fb0e305a370f301c1e12cb28b9c13340029),
    as of 2014-07-02).
