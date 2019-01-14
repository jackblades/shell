https://haskelliseasy.readthedocs.io/en/latest/
https://gist.github.com/gelisam/667c980a605e77d61d19709650ea5634
http://dev.stephendiehl.com/hask/

# Tooling
> cd /path/to/project
> stack install intero 
> stack exec -- '/Applications/Visual Studio Code.app//Contents/Resources/app/bin/code'  > vscode

- vscode +haskero
- intero
- stack
- ghci
- ghc -fno-code  # only typecheck, no code
- dash + dash-haskell (https://github.com/jfeltz/dash-haskell)

- foldl
- RIO prelude + conduit for a base lib or liblawless / foundation?
- lens-prelude?
- magicbane fits well for web stuff
- resourcet / io-regions?
- streamly / stm ?

- hasql / beam ? https://www.reddit.com/r/haskell/comments/7tx0o4/haskell_3_sql/
- project-m36 / HRR ?

# Use ghci
> stack ghci --with-ghc intero
-- customization
> :set prompt "\ESC[1;34m%s\n\ESC[0;34mλ> \ESC[m"
-- functionality
> :set -fobject-code  -- used to fix mem leaks in ghci
> :set -XTypeApplications
> :t sequenceA
sequenceA :: (Applicative f, Traversable t) => t (f a) -> f (t a)
> :t sequenceA @[]
sequenceA @[] :: Applicative f => [f a] -> f [a]

Possibly ghci tools using turtle for faster / cli search + doc

# Typed Holes
- Usable even in error scenarios
- f x = _  -- fast iteration
- Usable even in types!
    - (MonadReader e m, m ~ _, e ~ _) => <//>  -- get the specialization used!

# Main
:main arg1 arg2 ...  -- in ghci

# Records
- All records fields should start with _ and derive lenses
- Data declarations with records and sums create partial functions, so don't do it
    - Use lenses instead
    - see https://github.com/ekmett/lens/wiki/Operators
- write a `foldData con1 con2 ... ` for each record based datatype
    - prevents constructions like `Leaf _ _ _ _ -> ...` in match cases
    - NOTE: Leaf{} -> ... instead of the underscores


# Errors and exceptions
- only interactive code should use `error`
- pure code should _NEVER_ throw exceptions
    - since they can only be caught in IO 
        - because it allows `throw 1 + throw 2` to be different base on evaluation order
        - because `catch` can branch on the basis of which exception was thrown
        - because it violates ref. trsansparency
    - _DETERMINISTIC_ exceptions are ok to be caught in pure code (that is, it's thrown based on a argument)
    - Non deterministic ones like OOM or SIGINT etc should not be caught (maybe at all)

# Template Haskell / Macros
- use embedFile from Data.EmbedFile (TH), kind of like #include

# DSUM?



# haddocks (haddocset nix + zeal / dash?)
stack install hoogle
stack haddock          # > ~/.stack/snapshots/x86_64-osx/lts-11.5/8.2.2/doc/index.html
stack exec -- hoogle generate --local --database=.stack-work/hoogle
stack exec -- hoogle server --local --database=.stack-work/hoogle

- see https://github.com/alexwl/haskell-code-explorer

# vscode: 
- setup hoogle
In (User preferences > hoogle)
    - turn off "include default packages" 
    - enable "watch .cabal fil"
    - set max results to 100
    - set server url to "localhost:8080"

- setup Terminal
In (Open Keyboard shortcuts > keybindings.json)
    [{
        "key": "ctrl+z",
        "command": "workbench.action.terminal.toggleTerminal"
    },
    {
        "key": "ctrl+`",
        "command": "-workbench.action.terminal.toggleTerminal"
    }]


# main
main = Config.argmain appMain where
    appMain :: 

# Application Design
- `RIO env a`
    - Essentially equivalent to `ReaderT env IO a`
    - To get state, use an IORef (or whatever) in the env
    - Capabilities/Effects are defined as typeclasses on the environment
    - `HasLog env, HasState env => RIO env a`

- MTL Style
    - `MonadState s m, MonadException x m => m a`
    - Each function _only_ specifies it's _own_ constraints
    - When a concrete monad is substituted at the use site, the capability is checked
    - This means a tree like aggregation up the call chain is _NOT_ required.

- Lens support
*For constraints on the env in `RIO env a`* 
    - makeClassy ''<RecordType>
        - This gives `HasRecordType e` constraints
        - generates the lenses to retrieve the fields

    - makeClassyPrisms ''<SumType>
        - This gives `AsAsynException e` constraints ()
        - generates the prisms to get the cases

    - makeWrapped ''<NewType>
        - This gives 

# Debugging
- https://wiki.haskell.org/Debugging
- https://simonmar.github.io/posts/2016-02-12-Stack-traces-in-GHCi.html
    - ghci -j8 +RTS -A128m  # parallel compilation, bigger heap
    - ghci -fexternal-interpreter -prof  # stactrace by default
    - Don’t forget to use `-prof`, and add `-fprof-auto-calls` to get stack-trace annotations for the code you compile. 
    - You can `:set -fobject-code -fprof-auto-calls` inside GHCi itself to use compiled code by default.
- https://github.com/JohnReedLOL/HaskellPrintDebugger

- Always build with `--profile`?
    - library-profiling: True

# exception handling
- see `safe-exceptions` or `unliftIO` as already present in `RIO`
    - `RIO` already uses the `unliftIO` one
    - https://www.fpcomplete.com/blog/2017/07/announcing-new-unliftio-library for rationale

# stacktraces
- If you compiled your code with -g, and GHC has libdw support for backtraces, you can send a SIGUSR2 signal to your application at runtime to have it dump a trace on stderr.

# perf stuff
- from Texmo
    Your understanding is correct. More generally, GHC has a harder time optimizing recursive data types and recursive functions. The rule of thumb is that each iteration of a recursive function takes 10s of nanoseconds minimum. To break the 10ns barrier you need to start using rewrite rules and shortcut fusion or non-recursive representations.
-
    Or, very crudely put, applicatives are for the actions of circuits, arrows are for the structures of circuits, and monads are for general-purpose computational effects.

# GHC gc
- https://stackoverflow.com/questions/36772017/reducing-garbage-collection-pause-time-in-a-haskell-program?noredirect=1#comment61127896_36772017
- https://github.com/ezyang/compact
- https://tech.freckle.com/2018/03/06/compact-regions-success-failure-questions/
- https://www.youtube.com/watch?v=LJC_2agoLuE&t=27s

Garbage collection pauses are linear in the size of the retained set. (And the total GC time, meaning sum of all pauses, is inversely proportional to the amount of free memory.)

- Profiling the benchmark suite showed enormous allocation and %GC time numbers.
- Using the -A RTS option to increase the allocation area size made a dramatic improvement on run time and %GC time. I tried a few sizes and settled on -A256m (the default is 512KB).

- The profiling in #1 attributed more than 95% of all the allocation to a handful of "inner loop" functions in the program, which were doing a lot of random access into unboxed Vectors, but with generic Vector class operations. Inspecting the Core revealed that the vectors were being accessed with heap-allocated Int indexes. Using INLINABLE pragmas and more aggressive optimization made all those heap-allocated Ints go away, which produced an even more dramatic improvement in run time, and eliminated the need.

- Non moving collector
    - +RTS -G<N> -xn  -- <N> = #generations

# Idle state GC
- My process seems to be consuming a bunch of CPU even though it is idle, why is that?
    Run your application with `+RTS -I0` (which can be done via compile time options in your .cabal). This disables idle-time garbage collection which is almost always the cause of CPU usage while idle in `acid-state` based apps.

## Strict pragma
- http://blog.johantibell.com/2015/11/the-design-of-strict-haskell-pragma.html
- The new Strict pragma, together with a previous change I made to unpacking, lets us write the code we want to write because
    - the Strict pragma lets us leave out the bangs but still get strict fields [2] and
    - default unpacking of small fields (see -funbox-small-strict-fields) gets us the unpacking without the pragmas.
- https://github.com/meiersi/HaskellerZ/blob/master/meetups/20150531-ZuriHac2015_Johan_Tibell-Performance/slides.md

# Enum
data MyEnum = A | B | C deriving(Eq, Show, Enum)

main = do
    print $ [A ..]                 -- prints "[A,B,C]"
    print $ map fromEnum [A ..]    -- prints "[0,1,2]"


- `keiretsu` for dev flow orchaestration
http://hackage.haskell.org/package/hint
https://github.com/phadej/idioms-plugins
https://github.com/kowainik/smuggler
https://github.com/mstksg/auto
https://hackage.haskell.org/package/inspection-testing-0.1#readme
https://ghc.haskell.org/trac/ghc/wiki/Plugins/TypeChecker/RowTypes/Coxswain
https://www.reddit.com/r/haskell/comments/ujdet/introducing_the_hermit_equational_reasoning/
https://hackage.haskell.org/package/require
https://hackage.haskell.org/package/serv
https://github.com/mstksg/auto/blob/master/README.md
https://hackage.haskell.org/package/exists
https://hackage.haskell.org/package/shapely-data
https://hackage.haskell.org/package/debug-pp
https://hackage.haskell.org/package/ixdopp
http://hackage.haskell.org/package/graphmod

http://hackage.haskell.org/package/lambdabot-haskell-plugins
https://groups.google.com/forum/#!topic/fa.haskell/crXl7KQAaSo      -- polarity evaluation
https://hackage.haskell.org/package/mstate

# Disruptor
- https://github.com/kim/data-ringbuffer
- https://github.com/Tener/disruptor-hs
    Preliminary results are interesting. The fastest queue as of now is located in Test.ManyQueue module (see here: https://github.com/Tener/disruptor-hs/blob/master/Test/ManyQueue.hs). In 1P1C test it achieves up to 40M msg/sec, in 2P2C it goes up to 100-120M msg/sec. Disruptor achieves 50M-130M msg/sec, depending on the mode it operates at. (All tests done on Linux raptor 3.1.0-4-ARCH #1 SMP PREEMPT Mon Nov 7 22:47:18 CET 2011 x86_64 Intel(R) Core(TM) i7 CPU 870 @ 2.93GHz GenuineIntel GNU/Linux)

# RTS
- http://www.scs.stanford.edu/16wi-cs240h/slides/rts-lecture-annot.pdf