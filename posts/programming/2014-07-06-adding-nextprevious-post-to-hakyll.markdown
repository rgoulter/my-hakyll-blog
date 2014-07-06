---
title: Adding Next/Previous Post to Hakyll
author: Richard Goulter
tags: hakyll, haskell
---

So. The problem I was trying to solve in my last post was how to add next/prev
links to a blogpost.  
I've since figured out how to do that.
[See the commit](https://github.com/rgoulter/my-hakyll-blog/commit/a4dd0513553a77f3b819a392078e59f461d884f9).

My problem was, I had an `Item String`, and wanted to give a `Compiler String`
corresponding to the next (or previous.. let's ignore that for generality)
post's url.  
I ran into difficulty by taking a list of `Identifier`s, and getting a
list of `Compiler String`s. That is, I loaded all the posts, and mapped them
to their urls. (At which point I was stuck with `[Compiler String]`).  
What I figured out to do was instead take the list of `Identifier`s,
take the `Identifier` of the _next_ post, and map that `Identifier` to a url.
(Which is of type `Compiler String`).

If it's unclear to you, then what I mean is that the problem I was struggling
with was quite simple when done the right way; and I was thinking about it
in the wrong way.

When I struggled, I was wanting to get a `Compiler [String]` because I
figured I would be able to look up the url after some url. I thought there
would be some way to treat `Compiler [String]` more like `[String]`.  
Wrong idea, anyway.

Once you can go from `Item a` to `Compiler String`, then it's quite easy to
give this to a post.  
For those who hadn't tinkered around enough with Hakyll for this to be
so obvious, you give the
`Item a -> Compiler String` function to `field "nextUrl"`, and adding this to
the `Context a` given to the post.
