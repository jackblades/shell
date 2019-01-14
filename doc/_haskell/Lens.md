https://stackoverflow.com/questions/50915526/what-are-prisms
https://en.wikibooks.org/wiki/Haskell/Lenses_and_functional_references#Isos
John Wiegley: Putting Lenses to Work

Universal API for immutable data access and modification 

--
^           refers to a fold           
~           modification or setting
?           results optional
<           return the new value
<<          return the old value
%           use a given function
%%          use a given traversal
=           apply lens to MonadState
.           which side should have the lens

--

Existing ways of constructing and comsuming nested data structures suck. Lens can define sort of arbitrarily complex and compositional accessors and traversors.

	• Compose backwards (like OO accessors)
	• A Lens takes 4 parameters because it can change the types of the whole when you change the type of the part.
	• Often you won’t need this flexibility, a Simple Lens or Lens' takes 2 parameters, and can be used directly as a Lens
	• Lens s t a b ~= Lens s -> t, a -> b where s –> t is the transformation of the whole and a -> b is the transformation of the part
	• Lens' a b    ~= Lens a -> b

biplate is a traversal that can walk over arbitrary structures and identify things of a specific type.

Let x = (("foo", "bar"), "!", 2 :: Int, ())
(x ^.. biplate :: [Int])      	==> [2]
(x ^.. biplate :: [String]) 	==> ["foo","bar","!"]

> stack install lens
> import Control.Lens

Tuples	_1, _2, …, both	
Map	m ^. at "hello"	Get key "hello" from m. Guessing same for set.
	m & at "hello" ?~ "world"	Insert "hello" -> "world" in m
	m & at "hello" .~ Nothing	Delete hello from m
State	fresh :: MonadState Int m => m Int
fresh = id <+= 1	
		
Get	^. / view	("hello","world") ^. _2
Set	.~ / set	set _2 42 ("hello","world")
Compose	("hello", ("world", 1)) ^. _2._1	Lens' s x . Lens' x a = Lens' s a
	
		
Getter	"hello" ^. to length	Gets length of "hello" = 5
Setter	mapped :: Functor f 	over mapped succ [1,2,3]
	    => Setter (f a) (f b) a b
C/C++ operators	(1,2) & both *~ 2	+= -> +~
		*= -> *~ and so on
		
Over	over mapped succ [1,2,3]	over is analogous to fmap, but parameterized on the Setter.
	[1,2,3] & mapped %~ succ
Fold	> allOf (folded.text) isLower        [ "hello"^.packed	> :m +Data.Char Data.Text.Lens
	    , "goodbye"^.packed ]	
Traversal	> mapMOf (traverse._2) (\xs -> 	> :m + Data.Data.Lens
	    length xs <$ putStrLn xs) 	
	    [(42,"hello"),(56,"world")]	ToListOf / ^.. $ traverse
	FirstOf, lastOf	firstOf = preview
		ToList is the default way to view
		Monoid is the default way to reduce
Isomorphism	"hello" ^. packed :: Text	an Iso is a forward mapping and a backward mapping such that the forward mapping inverts the backward mapping and the backward mapping inverts the forward mapping.
	hello ^. from packed . to length	fw . bw = id

	"foobar" ^. strict . from strict	bw . fw = id
	newtype Neither a b = Neither 	Automatically derives
	  { _nor :: Either a b } 	
	  deriving (Show)
	neither :: Iso (Neither a b) (Neither c d) (Either a b) (Either c d)

		
	makeIso ''Neither	nor :: Iso (Either a b) (Either c d) (Neither a b) (Neither c d)
		
		Such that
		from  neither = nor

		from      nor = neither 
		neither . nor = nor.neither = id
Prism	preview _Left (Left "hi")	Select a subbranch of a sum type
	review _Left "hi"	preview :: Prism' s a -> s -> Maybe a
	Left "hi" ^? _Left	review :: Prism' s a -> a -> s
	preview _Cons [1,2,3]	^? Is ^. for prisms
	preview _Nil []
		
Derive Lenses	{-# LANGUAGE TemplateHaskell #-}
	• Need the fields to start with _
		• Lenses created: bar, baz, quux
	data Foo a = Foo 	
	  { _bar :: Int	bar, baz :: Simple Lens (Foo a) Int
quux :: Lens (Foo a) (Foo b) a b
	  , _baz :: Int
	  , _quux :: a }

	
	makeLenses ''Foo
		





