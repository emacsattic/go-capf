`go-capf.el`
============

This package provides a `completion-at-point` function to complete go
code using [gocode], offering context-base suggestions for functions,
variables and types without having to save the buffer.

While `go-capf` doesn't require anything to be installed besides
`gocode` as an external component (which can be installed with a simple
`go install ...`), a better looking completion front-end in Emacs, such
as [ivy] might be worth recommending.

How to use
----------

Using MELPA and `use-package`, a minimal but sufficient setup might look
something like this:

	(use-package go-capf
	  :after go-mode
	  :config
	  (add-hook 'go-mode-hook
				(lambda ()
				  (add-hook 'completion-at-point-functions #'go-capf
							nil t))))

This will let `completion-at-point` know that it should try `go-capf`
_first_ when looking for completions, in `go-mode` buffers.

Also make sure that `completion-at-point` or `complete-symbol` is
actually bound.

Example
-------

In vanilla Emacs:

![screenshot1]

With [ivy]:

![screenshot2]

Bugs
----

- After completing, no further text is added, although it might be
  useful to add `()` for functions or `{}` for structures.

Any further bugs or questions can be submitted to the [mailing list][]
(shared with other `*-capf` projects).

Copying
-------

`go-capf.el` is distributed under the [CC0 1.0 Universal (CC0 1.0)
Public Domain Dedication][cc0] license.

[gocode]: https://github.com/mdempsky/gocode
[ivy]: https://github.com/abo-abo/swiper#ivy
[screenshot1]: https://files.catbox.moe/jx8681.png
[screenshot2]: https://files.catbox.moe/jt2tdl.png
[mailing list]: https://lists.sr.ht/~zge/capf
[cc0]: https://creativecommons.org/publicdomain/zero/1.0/deed
