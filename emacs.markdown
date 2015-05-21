# Emacs

This is my page for Emacs stuff.
Because [Yi](yi.html) gets one.

## Motivation. (No, Emacs vs Vim Doesn't Matter).

I'm a Vim user. (I might make analogies to Vim / vim community throughout.
That's what I understand).
Obviously, what editor you use doesn't matter. But which editor is better to
use is a less stupid question. I'd rather use Notepad++ than Notepad. I'd
rather use Atom/SublimeText than Notepad++ for working on a project. --
**But**, discussing "which is the best" __is__ quite daft: it's better to
discuss what (set of) features or capabilities make for a better editing
experience.
Other issues which crop up:

* **Prestiege/Pretension**: Vim/Emacs have the reputation as being what the
  'smart dudes' use. So, somehow, anyone using Vim/Emacs must be smart, right?
  -- Despite this, it's easy to come across users of either who aren't all that
  great with the tools they're using. -- This probably shouldn't affect whether
  you think Vim or Emacs is better; but it's a cultural backdrop to the
  discussion.  
  (Vim/Emacs aren't the only tools to suffer fools, btw.).

* **Configuration vs Convention**: SublimeText is a good editor, and comes with
  many great features out-of-the-box (which Vim/Emacs would have to have
  installed as plugins). That's "convention". On the other extreme, Emacs can
  be customised to the extent that another Emacs user mightn't be able to
  pick-up-and-use-it if they came across it. -- This is more of a continuum
  than one-or-the-other; and also depends on whether you want to bother
  tinkering around or not.

* **Editor Culture**: Like. I'd say Vimmers ought to [work on
  improving](posts/programming/2014-04-26-tools.html). And the ["Emacs is
  Dead"](https://tkf.github.io/2013/06/04/Emacs-is-dead.html) essay's thesis is
  that "emacs culture largely involves making tools which everyone benefits
  from". Whether these ones are applicable or not, mutually exclusive or not,
  who knows. -- But you're more likely to find Vimmers who "don't know" VimL
  than Emacsers who don't know ELisp.

# Starter Kits

Vim has starter kits like SPF13, Janus, or Cream. ("Cream to make the coffee
tastier", or something).  
The point being, an unconfigured vim/emacs is essentially an unfriendly editor,
greatly enhanced with plugins/configuration.  
-- Or, in terms of "convention vs configuration": "why not both?".

Turns out this is what Spacemacs is: [reddit
thread](https://www.reddit.com/r/emacs/comments/333ywx/did_anyone_else_go_wow_after_trying_spacemacs/).
Highlights (from user instant_sunshine):

> The WHOLE point of Emacs is to hack your own personal editor together.
>
> Packages make this ludicrously easy.
>
> Despite the highly opinionated views of some, this is what Emacs has been
> about since day one.
>
> Spacemacs is the best starter kit so far. Also, fairly unsurprisingly it
> strongly targets Vim switchers.
> ....
> There is also extraordinary value in knowing what exactly is going on in your
> config, and being its author.

The following is a bit 'snobbish'; I'd phrase it instead "I'd hate to see
pretending to have skills they dont' have":

> Keeping people at a distance from their own config, and that is exactly what
> all starter kits do, is not such a wonderful thing.
>
> Sadly, Vim is highly prone to this sort of adoptive use, a package is
> installed and there is virtually no knowledge on how it's implemented.
> Vimmers are "generally" scared of VimScript/VimL.
>
> I personally don't want to see such users being the mainstream of Emacs
> users, I prefer to see Lisp hackers in this space, so we actually get better
> quality throughout.

# Sacha Chua's Visual Guide to Emacs

[http://sachachua.com/blog/series/a-visual-guide-to-emacs/](http://sachachua.com/blog/series/a-visual-guide-to-emacs/)  
This is very cute, utterly fantastic.  
She also links to some [Emacs Beginner
Resources](http://sachachua.com/blog/2014/04/emacs-beginner-resources/).

# Mastering Emacs in One Year

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

# EVIL Mode

-- Vim keybindings are clearly superior for navigating text (when using a
keyboard). And there's always the notion that 'vim' doesn't necessarily refer
to one particular program, so much as including 'vi-emulation' of the
keybindings. (e.g. like XVim for XCode).

I understand these days EVIL is the clear winner for Vim-emulation in Emacs.

## Mode??

What's a 'mode' in Emacs? Seems to me Major/Minor modes; where the 'Major' mode
is only-one-at-a-time, and 'Minor' modes contribute to the functionality. So,
Major modes would handle things like language-specific functionality.

* [Matt Brigg's blogpost about EVIL](http://mattbriggs.net/blog/2012/02/27/awesome-emacs-plugins-evil-mode/)  
  It explains some things for Vim users who want to try Emacs.

* [EmacsWiki EVIL page](http://www.emacswiki.org/emacs/Evil)

* [S/O post 'EVIL mode best practices'](http://stackoverflow.com/questions/8483182/evil-mode-best-practice)


# Packages

Vim has, like, Vundle (successor of Pathogen). And a bunch of newer things, I hear.  
What's the equivalent for Emacs? Or even equivalent of `~/.vimrc`, `~/.vim`?

EVIL mode wiki page above mentions various: MELPA, Marmelaide, QUELPA, el-get, etc.  
[ELPA wiki page is enlighening](http://www.emacswiki.org/emacs/ELPA). 'ELPA' is a 'Package Archive' from which you download plugins. 'QUELPA' is the build-it-from-source-on-your-machine alternative.  
And then issues regarding whether the repository is 'free' software or not, etc.

# Recommended List of Plugins

I've not searched too extensively for this. So.

But, naturally, since the trend at some point in the programming world was for
"awesome" lists, it's hardly surprising there's an
[awesome-emacs](https://github.com/emacs-tw/awesome-emacs).

# Emacs Tutor

[tuhdo's emacs-tutor](http://tuhdo.github.io/emacs-tutor.html) comes with
large, pretty gifs of Emacs doing its thing.  
I kindof like that it shows off feature based stuff at the start.

Somewhat apprehensive at the thought of a community which needs
fancy-animated-gifs to get excited about anything, though: -- I'm not sure
about Emacs, but Vim at least has excellent help documentation.

# Org Mode

One of those heard-this-about-emacs things.  
One-year-guide-to-Emacs recommends Org-mode as a gateway drug to Emacs.

So, here are a couple of links to Org mode tutorials:

* [http://orgmode.org/worg/org-tutorials/org4beginners.html](http://orgmode.org/worg/org-tutorials/org4beginners.html)

* [https://emacsclub.github.io/html/org_tutorial.html](https://emacsclub.github.io/html/org_tutorial.html)
