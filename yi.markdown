---
title: Yi
---

I thought it might make sense to have a page where I can dump all my Yi
related findings, rather than making tidbit posts about Yi.  
See [posts tagged 'Yi'](/tags/programming.yi.html).  
(NOTE: 22/09/14: I haven't taken the time to really look into Yi as intensely
 as I have been earlier. Some of the info below may be out of date. Feel free
 to email me, richard.goulter@gmail.com).

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
The vim wiki
[has some examples](http://vim.wikia.com/wiki/Inserting_text_in_multiple_lines).  
Yi now does this better than Vim (as far as I can tell); where Vim only has
this multi-line insert for block mode, Yi supports the feature for linewise
visual mode as well. And, Yi's multi-cursor insert writes things "live",
whereas Vim's is delayed.
[Brag](https://github.com/yi-editor/yi/commit/caa06cadbdbd140dc837e042c89a972323386671).
(The caveat is that Yi's block mode is slightly different. In theory it ought
to work for standard visual mode, I suppose; examine the diff of that commit to
see how, but like, visual mode seems to be for other things).

That Yi's Vim keymap supports multiple cursors like this implies a multiple
cursors feature are supported out-of-the-box (which doesn't appear to be the
case with a grok at the source), or that it should be reasonably
straightforward to add a plugin like
[terryma/vim-multiple-cursors](https://github.com/terryma/vim-multiple-cursors)
(in the style of Sublime Text).

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

![](http://i.imgur.com/QE5fNXu.png)

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

    UPDATE: (22/09/14): I recently got an email from a Siddhanathan Shanmugam
    who suggsted to me that dependencies could be put into `~/.config/yi/lib`
    folder. This works very well. e.g. if we adapt the HelloWorld example
    above, we can put `HelloWorld.hs` in `~/.config/yi/lib/` and can import it
    from `yi.hs`.
    [(Gist)](https://gist.github.com/rgoulter/5b291e7d00945661aa71/d1a503b756a2abb7a1835c310f58f98863b4fd94).  
    I guess that's a
    [Dyre thing](https://github.com/willdonnelly/dyre/blob/9d4ab20cdfea10735b7cc47e917214b60d0ee87c/Config/Dyre/Paths.hs).
    Cool.

    Before learning that, the workaround was to try and cabalize some portion
    of the config, and add treat that like some other dependency..

    I was able to get my `yi.hs` to depend on a cabal project by doing:

    ```
        ~/github/yi/yi$ cabal sandbox add-source /path/to/dependency
        ~/github/yi/yi$ cabal install dependency-name
    ```

    where `~/github/yi/yi` is the location of my Yi sandbox. (Well, I've opted
    to use a Cabal sandbox for my Yi to avoid Cabal Hell).  
    When the dependency is updated, to register this with Yi I'd need to

    ```
        ~/github/yi/yi$ cabal build
        ~/github/yi/yi$ touch ~/.config/yi.hs
    ```

    i.e. get Cabal to rebuild its dependencies, and then 'modify'
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
    need to constantly `cabal build` as it updates, in contrast
    to just having Yi recompile a modified `yi.hs`.

    I still need to investigate some more about development in such a
    dependency, especially with (say) a shared Cabal Sandbox.

*   *How to show a list of keybindings, or something else which can show me what Yi can do?*

    Haven't figured that out yet. (as of 2014-07-02).  
    [yi-editor/yi#504](https://github.com/yi-editor/yi/issues/504) touches upon
    this issue, with the suggestion of documenting the keybindings (since these
    don't change at a pace as to make this too awful).  
    Those with the programming bug, though, would rather have this done
    'automatically'.


# Troubles with Yi

*   <s>For some reason, with
    [this config](https://github.com/rgoulter/dotfiles/blob/28b9712fc66c84121eed82113ab61c66b7d699f3/yi.hs),
    when I tried playing around with Vim macros, it didn't go well.  
    e.g. if I tried recording a macro by `qt^x$xq`, then print out this register
    `t`, what I get is `t^xx$xx`. (i.e. the keys appear to have been pressed twice).
    Something to look into.</s>
    [Not any more!](https://github.com/yi-editor/yi/issues/566).  
    (By "look into", I clearly meant, "try tests and report as a bug"..).

*   Not particularly a bug, but: since Yi is Emacs-like, `<Esc>` is treated as
    the Meta key, and when (using a Vim keymap) in Insert mode, one presses
    Escape quickly followed by another letter (e.g. Escape, then j), it
    gets handled as `<M-j>` rather than `<Esc>j`.  
    I imagine some people might take advantage of this to allow for different
    insert-mode inputs. (Probably using `<Alt>` as meta).  
    I also imagine it's possible to configure this behaviour in a `yi.hs`.

* * * 

<a rel="license" href="http://creativecommons.org/licenses/by/4.0/">
<img alt="Creative Commons License" style="border-width:0"
     src="https://i.creativecommons.org/l/by/4.0/88x31.png" />
</a><br />
This work is licensed under a
<a rel="license" href="http://creativecommons.org/licenses/by/4.0/">
Creative Commons Attribution 4.0 International License
</a>.  

* * *

<!-- disqus comment section -->
<div id="disqus_thread"></div>
<script type="text/javascript">
    /* * * CONFIGURATION VARIABLES: EDIT BEFORE PASTING INTO YOUR WEBPAGE * * */
    var disqus_shortname = 'richardgoultersblog'; // required: replace example with your forum shortname
    var disqus_identifier = 'yi.html';
    var disqus_url = 'http://www.rgoulter.com/blog/yi.html';
    var disqus_title = 'Yi - RGoulters Notes';

    /* * * DON'T EDIT BELOW THIS LINE * * */
    (function() {
        var dsq = document.createElement('script'); dsq.type = 'text/javascript'; dsq.async = true;
        dsq.src = '//' + disqus_shortname + '.disqus.com/embed.js';
        (document.getElementsByTagName('head')[0] || document.getElementsByTagName('body')[0]).appendChild(dsq);
    })();
</script>
<noscript>Please enable JavaScript to view the <a href="http://disqus.com/?ref_noscript">comments powered by Disqus.</a></noscript>
<a href="http://disqus.com" class="dsq-brlink">comments powered by <span class="logo-disqus">Disqus</span></a>

