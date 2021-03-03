Very Serious Tooling
--------------------

```haskell
class Yolo f where
  yolo :: f a -> a
```

Get all the values you need, you only live once.

Inspired by Nick Partridge's [gist](https://gist.github.com/nkpart/8922083d3c18a8f777b8).


You're a very serious developer, and know how to thread together an application with a
monad stack for all your resource, error, and state handling, along with some good old
fashioned configuration injection.

Now you go to the REPL to play with some functions, but writing `runResourceT` and
`runReaderT` is just too hard. Wouldn't it be easier to just `yolo` the result?

Side effects and error handling be damned, this is what `acme-yolo` can offer.
