---
title: Trying to Install Lime
author: Richard Goulter
tags: go, lime, editors
---

[Lime](https://github.com/limetext/lime) is in that category of obscure and in
development text editors. If the name isn't a hint, Lime is a clone of Sublime
Text, a popular cross-platform text editor which students will either pirate or
just use without registering. (Just like good ol' WinZip).  
(Well, I'm not sure if it's fair to call these editors "obscure". NeoVim,
LightTable, Atom have 6-8k stars. I *thought* ST2 was open source, but I
can't find a repo for it).

While a strong motivation for open-source-ness is "yay free stuff",
there's an interesting comment in the README:

> I love the Sublime Text editor. I have created several plugins to make it
> even better. One thing that scares me though is that it is not open sourced
> and the pace of nightly releases have recently been anything but nightly,
> even now that version 3 is out in Beta.
>
> There was a period of about 6 months after the Sublime Text 2 "stable"
> version was released where pretty much nothing at all was communicated to the
> users about what to expect in the future, nor was there much support offered
> in the forums. People including myself were wondering if the product was dead
> and I personally wondered what would happen to all the bugs, crashes and
> annoyances that still existed in ST2. This lack of communication is a
> dealbreaker to me and I decided that I will not spend any more money on that
> product because of it.

It seems Lime has a 'backend' written in Go, with the possibility of writing
a frontend in whichever language. (This architecture sounds like what NeoVim
is aiming for).

Anyway. I wanted to try and Install it.  
I'm not a Go user.  
I have run into several difficulties trying to install this on OSX.

After [installing dependencies](https://github.com/limetext/lime/wiki/Building),
and then more/less following the "Quickstart"
[here](https://github.com/limetext/lime/wiki/Ubuntu-13.10-(and-probably-others)-quickstart).

On OSX, trying a Go installation with `brew install go` isn't even capable of
running `go run hello.go` as per
[install instructions here](http://golang.org/doc/install)
(if hello.go uses package `fmt`, then it won't be able to find that).  
(Of course, but not apparent to a non-Go user, don't even try `go get`
whatever without having set `GOROOT`, `GOPATH`).

Installing using a `.pkg` from [here](http://golang.org/dl/), I then get errors
as per:

    $ go get github.com/limetext/lime/frontend/termbox
    # github.com/limetext/gopy/lib
    panic: runtime error: invalid memory address or nil pointer dereference
    [signal 0xb code=0x1 addr=0x0 pc=0x15672]
     
    goroutine 16 [running]:
    runtime.panic(0x1dae60, 0x31b9e4)
        /usr/local/go/src/pkg/runtime/panic.c:279 +0xf5
    main.(*typeConv).Type(0x2087f71e0, 0x220838dce0, 0x2086c2ab0, 0x3f43c, 0x26d420)
        /usr/local/go/src/cmd/cgo/gcc.go:1288 +0x1632
    main.(*typeConv).Struct(0x2087f71e0, 0x2087ab8c0, 0x3f43c, 0x6, 0x0, 0x0, 0x0)
        /usr/local/go/src/cmd/cgo/gcc.go:1551 +0x70b
    main.(*typeConv).Type(0x2087f71e0, 0x220838dd18, 0x2087ab8c0, 0x3f43c, 0x2087a0101)
        /usr/local/go/src/cmd/cgo/gcc.go:1234 +0x3038
    main.(*typeConv).Type(0x2087f71e0, 0x220838dca8, 0x2086c2990, 0x3f43c, 0x0)
        /usr/local/go/src/cmd/cgo/gcc.go:1189 +0x3dd6
    main.(*typeConv).Struct(0x2087f71e0, 0x2087ab6e0, 0x3f43c, 0x6, 0x0, 0x0, 0x8)
        /usr/local/go/src/cmd/cgo/gcc.go:1551 +0x70b
    main.(*typeConv).Type(0x2087f71e0, 0x220838dd18, 0x2087ab6e0, 0x3f43c, 0x2085ed2c0)
        /usr/local/go/src/cmd/cgo/gcc.go:1234 +0x3038
    main.(*typeConv).Type(0x2087f71e0, 0x220838dce0, 0x2086c2690, 0x3f43c, 0x26d420)
        /usr/local/go/src/cmd/cgo/gcc.go:1269 +0x1301
    main.(*typeConv).Struct(0x2087f71e0, 0x2087ab5c0, 0x3f43c, 0x6, 0x0, 0x0, 0x0)
        /usr/local/go/src/cmd/cgo/gcc.go:1551 +0x70b
    main.(*typeConv).Type(0x2087f71e0, 0x220838dd18, 0x2087ab5c0, 0x3f43c, 0x2085368c0)
        /usr/local/go/src/cmd/cgo/gcc.go:1234 +0x3038
    main.(*typeConv).Type(0x2087f71e0, 0x220838dce0, 0x2086c25d0, 0x3f43c, 0x26d420)
        /usr/local/go/src/cmd/cgo/gcc.go:1269 +0x1301
    main.(*typeConv).Struct(0x2087f71e0, 0x2087ab500, 0x3f43c, 0x6, 0x0, 0x0, 0x0)
        /usr/local/go/src/cmd/cgo/gcc.go:1551 +0x70b
    main.(*typeConv).Type(0x2087f71e0, 0x220838dd18, 0x2087ab500, 0x3f43c, 0x2085366c0)
        /usr/local/go/src/cmd/cgo/gcc.go:1234 +0x3038
    main.(*typeConv).Type(0x2087f71e0, 0x220838dce0, 0x2086c2510, 0x3f43c, 0x1)
        /usr/local/go/src/cmd/cgo/gcc.go:1269 +0x1301
    main.(*Package).loadDWARF(0x20836ec30, 0x208677180, 0x208698e00, 0x1a, 0x20)
        /usr/local/go/src/cmd/cgo/gcc.go:541 +0xfb4
    main.(*Package).Translate(0x20836ec30, 0x208677180)
        /usr/local/go/src/cmd/cgo/gcc.go:182 +0x150
    main.main()
        /usr/local/go/src/cmd/cgo/main.go:259 +0xef1
     
    goroutine 19 [finalizer wait]:
    runtime.park(0x4fed0, 0x31feb8, 0x31f269)
        /usr/local/go/src/pkg/runtime/proc.c:1369 +0x89
    runtime.parkunlock(0x31feb8, 0x31f269)
        /usr/local/go/src/pkg/runtime/proc.c:1385 +0x3b
    runfinq()
        /usr/local/go/src/pkg/runtime/mgc0.c:2644 +0xcf
    runtime.goexit()
        /usr/local/go/src/pkg/runtime/proc.c:1445

Presumably this is because CGo wants
_GCC_, not just any C compiler like Clang.  
(I've also run into GCC vs Clang with Haskell. GHC has a patch..).

Trying out `go env` lists where it chooses that, so setting `CC` to `gcc-4.8`
and `CXX` to `g++-4.8`, I  then get errors as per:

    $ go get github.com/limetext/lime/frontend/termbox
    # github.com/limetext/gopy/lib
    ../src/github.com/limetext/gopy/lib/bool.go:38: cannot use c(obj) (type *C.struct__object) as type *C.PyObject in argument to _Cfunc_boolCheck
    ../src/github.com/limetext/gopy/lib/code.go:32: cannot use ret (type *C.PyObject) as type *C.struct__object in argument to newCode
    ../src/github.com/limetext/gopy/lib/code.go:39: cannot use c(obj) (type *C.struct__object) as type *C.PyObject in argument to _Cfunc_codeCheck
    ../src/github.com/limetext/gopy/lib/code.go:44: cannot use pyCode (type *C.struct__object) as type *C.PyObject in argument to _Cfunc_PyEval_EvalCode
    ../src/github.com/limetext/gopy/lib/code.go:44: cannot use c(globals) (type *C.struct__object) as type *C.PyObject in argument to _Cfunc_PyEval_EvalCode
    ../src/github.com/limetext/gopy/lib/code.go:44: cannot use c(locals) (type *C.struct__object) as type *C.PyObject in argument to _Cfunc_PyEval_EvalCode
    ../src/github.com/limetext/gopy/lib/code.go:45: cannot use ret (type *C.PyObject) as type *C.struct__object in argument to obj2ObjErr

'tis rather frustrating, and I think I can declare Lime "Hard to Install"..  
(But also, I'm curious as to how to get around this, still. Maybe a more
recent Python 3.3 install.. Maybe a more recent GCC install..).
