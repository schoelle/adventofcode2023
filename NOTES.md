# Notes about using Pike

* The `Array.reduce` function is kind of odd, as it has a zero
  argument, but that is only used on an empty array. It should instead
  be the neutral element supplied to the combination function.
* Overwriting the %O representation of an object seems to require
  redefining _sprintf, which is quite a complex function. A
  `to_string` specially for this case would have been much more
  convenient.

