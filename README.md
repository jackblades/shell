# shell
- basic shell capabilities from turtle in haskell for better composition of scripts and functions
- *must* interface with fish and abuse its shell features as much as possible
  - in particular completions can be used more aggressively
- other programs to use are fzf, sdiff, and that one horizontal menu


# typesystem
- x = { a = 32, b = "hello" }
- x.a = 32, x:rest 
- lenses
- functions should be isolated and the required structure constructible at call site
- generic sop type stuff but extensible on both sides
- 





# turtle
You can think of Shell as [] + IO + Managed. In fact, you can embed all three of them within a Shell:

  - select ::        [a] -> Shell a
  - liftIO ::      IO a  -> Shell a
  - using  :: Managed a  -> Shell a
  - Those three embeddings obey these laws:

    do { x <- select m; select (f x) } = select (do { x <- m; f x })
    do { x <- liftIO m; liftIO (f x) } = liftIO (do { x <- m; f x })
    do { x <- with   m; using  (f x) } = using  (do { x <- m; f x })

    select (return x) = return x
    liftIO (return x) = return x
    using  (return x) = return x

... and select obeys these additional laws:

  - select xs <|> select ys = select (xs <|> ys)
  - select empty = empty

You typically won't build Shells using the Shell constructor. Instead, use these functions to generate primitive Shells:

  - empty       , to create a Shell that outputs nothing
  - return      , to create a Shell that outputs a single value
  - select      , to range over a list of values within a Shell
  - liftIO      , to embed an IO action within a Shell
  - using       , to acquire a Managed resource within a Shell

Then use these classes to combine those primitive Shells into larger Shells:

- Alternative, to concatenate Shell outputs using (<|>)
- Monad, to build Shell comprehensions using do notation

If you still insist on building your own Shell from scratch, then the Shell you build must satisfy this law:

-- For every shell `s`:

  - _foldShell s (FoldShell step begin done) = do
  -     x' <- _foldShell s (FoldShell step begin return)
  -     done x'

... which is a fancy way of saying that your Shell must call 'begin' exactly once when it begins and call 'done' exactly once when it ends.





/unstable
    - files with each modified function
/stable
    - image
/














