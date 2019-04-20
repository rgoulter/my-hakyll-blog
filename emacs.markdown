# Emacs

`[Updated 2018-11]`

I've been using Emacs recently, primarily for its org-mode feature.

Before using emacs, I had spent some time using vim (and vim-bindings
in other editing environments).

## Emacs and Vim, Broadly, Are Very Similar

Emacs and vim are mostly driven using the keyboard.  
The big benefit of being keyboard driven is not having to move
your hand to move the mouse.  
The downside to this there's a steeper learning curve to learning the
key bindings in either editor.

Emacs and vim take different approaches to keyboard input:

vim is a modal editor. It behaves differently than "normal" text editors.  
With normal text editors, pressing keys types the letters into the text area.  
With vim, pressing keys will do different things depending on which "mode" vim
is in.  
When vim is in "insert" mode, it behaves the same as a regular text editor: pressing keys types the letters.  
The difference from "normal" text editors is other modes. e.g. "normal" mode binds the
keys to different actions and movements. (e.g. the "d" key is a "delete" action,
and the "$" key moves to the end of the line. So, pushing "d$" deletes the rest of the line).

Vim's approach to "driven by the keyboard" is to use different modes.

Emacs' approach to "driven by the keyboard" is to use modifier keys like "Ctrl" and "Alt".  
Emacs' editing environment is much closer to a normal text editor.  
The use of modifier keys is sane enough that macOS input adopts many of the
Emacs-style bindings. (e.g. "command-a" will move to the beginning of the line,
"command-e" moves to the end).

This is worth mentioning because "emacs vs vim" is a classic flamewar
between programmers. I haven't lurked in places where these disagreements happen
in a while. Using either is fine. But it's interesting to see the approaches
these editors are taking.

## Great Things About Emacs (Hard to Find Elsewhere)

#### Org Mode

- Not without its limitations and downsides. But.
  org mode deserves its reputation as an excellent
  tool for organising things in plain text.
- What I love about org-mode:
  - An org mode file is a bunch of headings and sub-headings.
    The headings can be collapsed/expanded (like code-folding in other editors).
  - The headings can have meta-data like key-value properties, tags,
    a "TODO" state, etc..
  - All of which is nice for writing notes in org-mode.  
    But a great aspect of this is org-mode's "agenda" feature.
    Org agenda provides ways to search through and display
    org headings. (It's an "agenda" because dates can be attached
    to headings, so this can serve as an "agenda").
    - This might sound underwhelming,
      but it allows you to structure your tasks and notes in org
      documents in a way which suits you, and to be able to quickly
      find what you need to see.
    - I've heard WorkFlowy is an example of software which
      aims for this expressiveness, with the trade-off of being
      simpler to use than org-mode.  
      But as far as I can tell, the default go-to note taking,
      task management and calendar tools people use aren't
      as flexible.
- For what it's worth, Org mode has various other features I haven't
  made use of. e.g. it has support for exporting org files into
  other formats, it has great table editing features, it can be used
  to track time (by clocking in and out of headlines).

#### Magit

- You can find GUIs for git embedded in environments like
  vim, Visual Studio Code or any IDE.  
  But, Magit is an excellent package. It's good enough to be
  worth using emacs for, even if you don't use any other part of it.
- To be fair, git is still a tough beast to use.
- Magit seems to be a "best of both worlds" situation:  
  Power users are at there best when they can stick to their
  keyboard to get the job done.  
  New users need the discoverability that comes along with something
  like a GUI or dropdown menu.  
  AFAICT, Magit's excellent Developer Experience (DX) caters
  to both of these.

#### Extensibility

- I know that most programs have plugins/extensions.
  But it seems that the approach Emacs takes (with a heavy
  emphasis on "commands") allows for extending the program
  that's hard to find elsewhere.
- "Everything is a command", seems like
  a huge win in the interactions with the editors
  it allows.  
  Especially since with the commands in Elisp, you can:
  - look at the source code
  - find the documentation documentation
  - run by typing out the command name
  - bind to keybindings

#### Discoverability

- which-key is fantastic, especially in tandem with Emacs
  style of executing commands via key sequences.
- magit's user interface
  - magit itself is great; but imo vim's git plugin
    is pretty neat too.
- the `describe-*` help commands.
  - e.g. C-h w binds to "where-is", which lists keybindings to a command.
  - C-h c binds to describe-key-briefly, which shows the command
    for a key sequence
  - C-h k binds to describe-key, which opens the documentation
    for a command.
  - C-h b binds to describe-bindings, describe mode are also really good
    for listing the currently available bindings.
    - helm and ivy/counsel have `descbinds` makes this really convenient.

## "What I wish I'd known about Emacs, coming from vim"

- Plugins/Packages
  - Vim has some very nice plugins for downloading other plugins.
    (typically by cloning a git repository, and adding this to the runtime path).
    As far as I understand, https://www.vim.org/scripts/ was used as a way
    to distribute vim scripts for others to use.
  - Emacs has "Emacs Lisp Package Archive" (ELPA).

- Discoverability
  - as per the previous section.

## Useful Guides

#### Sacha Chua's Visual Guide

[http://sachachua.com/blog/series/a-visual-guide-to-emacs/](http://sachachua.com/blog/series/a-visual-guide-to-emacs/)  
This is very cute, utterly fantastic.  
She also links to some [Emacs Beginner
Resources](http://sachachua.com/blog/2014/04/emacs-beginner-resources/).

#### Mastering Emacs in One Year

Follow your friends on Twitter and you'll come across weird shit like this:
[reguardtoo's Mastering Emacs in One Year - Guide](https://github.com/redguardtoo/mastering-emacs-in-one-year-guide/blob/master/guide-en.org).

I'm not sure if it's just the phrasing/language, but not sure I can agree with
tthis guy vis-a-vis Starter-Kit discussion above:

> I learned the lesson the hard way. At the beginning, I regarded Emacs as a
> toy. I digged around the internet for cool code I can copy.
>
> That’s totally a waste of time if my goal is to become an Emacs master!
>
> I should have used Steve Purcell’s setup at the beginning!
>
> Please don’t repeat my mistake. Just follow Steven Purcell!
>
> Let me be blunt. You are a newbie, you’d better study top geek’s code. Don’t
> try to be “creative” at this stage. You won’t create anything when
> re-inventing the wheel.
>
> For example, some readers tell me that Emacs has too many hotkeys. They can’t
> memorize all of them. This is typical in newbies who assume that top geeks
> can remember more key bindings.
>
> Wrong!
>
> If you have studied any master’s setup, you will find that she uses Smex, as
> it is more efficient than pressing hotkeys.
>
> Since Steve Purcell loves new technologies and update his setup frequently,
> it may be a little harder to follow him for beginners.
>
> That’s actually great. I’m lucky to stick to his setup because pulling from
> his git branch gets me updated with the latest cool things in community.
>
> When I say “on the shoulders of giants”, I’m stressing that you need set your
> standard higher. I’m NOT saying the master’s setup is “newbie friendly”. If
> it happens to be “friendly”, it’s just the coincidence.
>
> This section is discussing the best way to be good, not the easiest way.
>
> There is a difference between best and easiest. For example, a setup using
> Vim key bindings is NOT easy but definitely best.

(This guide has > 1,000 stars on GitHub;
[purcell/emacs.d](https://github.com/purcell/emacs.d) which he links to has
~1,900 stars. Some seriously popular stuff -- though, honestly, I'd wonder how
much this is kids getting excited about starting Emacs and not following
through? __*cough*__. -- [I had some thoughts about superstar swkp/dotfiles,
also..](posts/programming/2015-01-20-analysis-of-swkpdotfiles-repo.html).).

## Tuhdo's Emacs Tutor

[tuhdo's emacs-tutor](http://tuhdo.github.io/emacs-tutor.html) comes with
large, pretty gifs of Emacs doing its thing.  
I kindof like that it shows off feature based stuff at the start.

Somewhat apprehensive at the thought of a community which needs
fancy-animated-gifs to get excited about anything, though: -- I'm not sure
about Emacs, but Vim at least has excellent help documentation.

## Recommended List of Plugins

[awesome-emacs](https://github.com/emacs-tw/awesome-emacs) is a pretty good
starting point.
