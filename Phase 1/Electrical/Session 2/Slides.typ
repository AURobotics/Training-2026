#import "/Theme/presentation.typ": *

#show: presentation-template.with()

#title-slide()

= This is a section

== This is a subsection (Also used as slide titles)

We can write something as expected.

#pause

and the `#pause()` function also works.

== Here is another slide

We can write some math:
$
  1 + 1 = pause 4
$
#meanwhile

and the `pause` function works inside!

#end-slide()
