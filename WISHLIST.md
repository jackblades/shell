
# macros
- 

# modules, interfaces, typeclasses
- modules are first class
    - can be instantiated multiple times
- interfaces? (possibly represent an existential type)
- classes are in global scope (as are all instances)
    - unique for one class

# Effects

```haskell
f :: a -> Effect  <env|exn|coroutine> a
  :: a -> EffectT <env|exn|coroutine> Identity a
-- or just use RIO style
```

- IO [MonadIO] / RIO
- ST / MT
- STM / Async
- [S|A]Exception / Coroutine / Streaming
- ResourceT

## Better syntax for State / ST, exceptions, coroutines and resourcet
- x := new :: STRef
- throw e, catch e, finally e
- yield x
- TODO resourceT

# Indexed / Graded Monads
- Similar to Idris ST
    - doorProtocol :: Resources () () a
        - start with no resources, end with no resources
    - doorProtocol = do
        door <- newDoor :: Resources () (door : Door Closed) ()
        openDoor door :: Resources (door : Door Closed) (door : Door Open) ()
        closeDoor door :: Resources (door : Door Open) (door : Door Closed) ()
        -- won't typecheck without this step in all brances of execution
        destroyDoor :: Resources (door : Door _) () ()
        pure a

# Dependent sums
- dependent-sum: DSum

# structural types
- literal records are closed; record matching is open
- literal sums    are open  ; case   matching is closed
[new]type Structural = { 
    a :: A, 
    b :: { c :: C, d :: D },
    e :: :cons1 F 
         | :cons2 { g :: G } 
         | s  -- other cases
         ,
    | r  -- other fields 
}
-- autogenerate the lenses
- x :: Structural
- x ^. a :: A
- x ^. b . c :: C
- x ^? e . cons1 :: Maybe F
- x ^? e . cons1 . g :: Maybe G


# data - codata
- data
    - `data List a = [] | a : [a]`
    - strict everywhere [ finite ]
    - recurse / consume incrementally
- codata
    - `codata Stream a = a :| (Stream a)`
    - lazy in the spine (at `Stream a`) [ possibly inifinite ]
    - corecurse / generate productively


---------
# Symbol, Nat
- :sym
    - fast and cheap compile time identifiers
- type level nats, sets, maps, etc



















