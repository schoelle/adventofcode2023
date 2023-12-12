# Notes about using Pike

* The `Array.reduce` function is kind of odd, as it has a zero
  argument, but that is only used on an empty array. It should instead
  be the neutral element supplied to the combination function.
* Overwriting the %O representation of an object seems to require
  redefining _sprintf, which is quite a complex function. A
  `to_string` specially for this case would have been much more
  convenient.
* `lambda` expressions are quite heavy weight. Would be great if there
  would be a lighter way to express them.
* How can I pass a class method as a function where the target becomes
  the argument, other than explicit `lambda`?
* Is there an easy way to cast all elements of an array? Like
  `array(string)` to `array(int)` instead of having to pass `lambda`
  to `map`? What about the reverse?


