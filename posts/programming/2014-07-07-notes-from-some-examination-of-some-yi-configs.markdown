---
title: Notes From Some Examination of Some Yi Configs
author: Richard Goulter
tags: haskell, yi
---

[Earlier](/posts/programming/2014-06-01-overview-of-yi-contrib-user-configs.html)
I'd posted very briefly about some User Yi Configs.

In particular I'm currently curious as to how to customise for, say, adding a
new ex command to Yi.

I noted that the Ex commands were listed in
[Yi.Keymap.Vim.Ex](https://github.com/yi-editor/yi/blob/master/yi/src/library/Yi/Keymap/Vim/Ex.hs).
(Note, there is some discordance between the version on GitHub now, and
Yi 0.8.1, as Vim2 has since replaced the older Vim keymappings). And somehow in
[Yi.Keymap.Vim](https://github.com/yi-editor/yi/blob/master/yi/src/library/Yi/Keymap/Vim.hs)
these ... are taken into the configuration. I'm not particularly sure how at
present.

Anyway, beyond this, I had another look at how custom actions had been
configured by some users.

### A Vim Keymap Configured with Customized Keymap
[Jeff's config](https://github.com/yi-editor/yi/blob/master/yi-contrib/src/Yi/Config/Users/Jeff.hs)
has these lines:

```haskell
    myConfig :: Config
    myConfig = defaultVimConfig
      { defaultKm = myVimKeymap
      , ...
      }

    myVimKeymap = mkKeymap $ defKeymap `override` \super self -> super
      { v_top_level = v_top_level super ||>
          (char ';' ?>>! resetRegexE)

      , v_ins_char  = (v_ins_char super ||> tabKeymap) <|>
          choice [ ctrlCh 's' ?>>! moveToNextBufferMark deleteSnippets
                 , meta (spec KLeft)  ?>>! prevWordB
                 , meta (spec KRight) ?>>! nextWordB
                 ]
      }
```

_Note:_

* `myVimKeymap` has type `KeymapSet`.  
* The `override` thing is due to Yi's
  `Data.Proto`, which isn't exposed in Hackage. (`KeymapSet` has record entries
  `topKeymap` and `insertKeymap`, so I'm not sure if `v_top_level` and
  `v_ins_char` is archaic).  
* `choice` is of type `MonadInteract m w e => [m a] -> m a`, as defined in
  `Yi.Interact`.  
* The operator `(||>)` is of type `MonadInteract f w e => f a -> f a -> f a` in
  `Yi.Interact`.  
* The operator `(?>>!)` is of type  
  `(MonadInteract m Action Event, YiAction a x, Show x) => Event -> a -> m ()`  
  in `Yi.Keymap.Keys`.  
* (And, if you're that novice at Haskell, `(<|>)` is to do with `Alternative`).

It seems Jeff has mapped `';'` to do something like `:noh` in Vim.
([`resetRegexE`](https://github.com/yi-editor/yi/blob/fea9dc8a9fc39ccb3bfa389c0e395383602710b6/yi/src/library/Yi/Search.hs#L82)
in `Yi.Search`.. hey, `Yi.Search` has documentation!).  
`tabKeymap` is a function Jeff defines in the config, which seems to be for
inserting snippets making use of `Yi.Snippets` and `Yi.Snippets.Haskell`.  
There also seems to be inputs for Insert mode, so that `Alt+Left`
(or `Alt+Right`) will move by words left/right.


### An Emacs Keymap with a Simple Config
[Reiner's config](https://github.com/yi-editor/yi/blob/master/yi-contrib/src/Yi/Config/Users/Reiner.hs)
takes a different approach (although is 'based' on the Emacs keymap):

```haskell
    main = configMain defaultEmacsConfig setup

    setup :: ConfigM ()
    setup = do
      setFrontendPreferences ["pango", "vte", "vty"]
      fontSize .= Just 9

      globalBindKeys globalBindings
      evaluator .= publishedActionsEvaluator
      publishAction "createDirectory" yiCreateDirectory

      addMode Haskell.fastMode
      modeBindKeys Haskell.fastMode (ctrlCh 'c' ?>> ctrlCh 's' ?>>! insertHaskSection)
```

_Note:_

* `configMain` has type `Config -> ConfigM () -> IO ()`, in `Yi.Config.Simple`
* `publishAction` has type `(YiAction a x, Show x) => String -> a -> ConfigM ()`
  in `Yi.Eval`.

I'm not sure what `"vte"` is; and am unsure about these `Mode`s.
The thing to note, though, is that this configuration as per `Yi.Config.Simple`
and its (ab)use of `do` notation makes for a configuration file which looks
much closer to a `.vimrc` or other whatever else.

`publishAction` looks like a way to add a custom Ex-like command, although in
this case the configuration is for Emacs not Vim. I suspect it will work, but
will need to try.  
(Not clear how the equivalent would be set with the non-`Simple` configs).


### A Vim Keymap with Overridden Bindings
[Michal's Config](https://github.com/yi-editor/yi/blob/master/yi-contrib/src/Yi/Config/Users/Michal.hs)
(which is somewhat documented) has the following code of interest:

```haskell
    myKeymapSet :: KeymapSet
    myKeymapSet = V2.mkKeymapSet $ V2.defVimConfig `override` \super this ->
        let eval = V2.pureEval this
        in super {
              -- Here we can add custom bindings.
              -- See Yi.Keymap.Vim.Common for datatypes and 
              -- Yi.Keymap.Vim.Utils for useful functions like mkStringBindingE

              -- In case of conflict, that is if there exist multiple bindings
              -- whose prereq function returns WholeMatch,
              -- the first such binding is used.
              -- So it's important to have custom bindings first.
              V2.vimBindings = myBindings eval ++ V2.vimBindings super
            }

    myBindings :: (String -> EditorM ()) -> [V2.VimBinding]
    myBindings eval =
        let nmap  x y = V2.mkStringBindingE V2.Normal V2.Drop (x, y, id)
            imap  x y = V2.VimBindingE (\evs state -> case V2.vsMode state of
                                        V2.Insert _ ->
                                            fmap (const (y >> return V2.Continue))
                                                 (evs `V2.matchesString` x)
                                        _ -> V2.NoMatch)
            nmap'  x y = V2.mkStringBindingY V2.Normal (x, y, id)
        in [
             -- Tab traversal
             nmap  "<C-h>" previousTabE
           , nmap  "<C-l>" nextTabE
           , nmap  "<C-l>" nextTabE

             -- Press space to clear incremental search highlight
           , nmap  " " (eval ":nohlsearch<CR>")
           , ...
           ]
```

All the `V2` is somewhat unnecessary.

* `pureEval` has type `VimConfig -> String -> EditorM ()`.
* `impureEval` has type `VimConfig -> String -> YiM ()`, but I'm not sure of
  the difference here.
* `myBindings` has type `(String -> EditorM ()) -> [VimBinding]`.

This binds keys to `eval` something. (In this case, space to call `:noh`).  
The way Michal modifies his `KeymapSet` is quite different from Jeff's.
