# learning-haskell
Learning Haskell

# Help/API/cmd tools

- https://www.haskell.org/hoogle/
- https://wiki.haskell.org/Hoogle#GHCi_Integration
- http://hackage.haskell.org/packages/
 - http://hackage.haskell.org/package/base-4.8.1.0/docs/Prelude.html - docs for Standard types, classes and related functions
 - http://hackage.haskell.org/package/base-4.8.1.0/docs/Data-List.html


## The Haskell Cabal and Hoodle

Cabal - Common Architecture for Building Applications and Libraries. Cabal is a system for building and packaging Haskell libraries and programs.

Hoogle is a Haskell API search engine

### Install Haskell

From here: https://www.haskell.org/platform/

After installation check this local doc: file:///Library/Haskell/doc/start.html

And set PATH if binaries were not symlinked into /usr/bin:

```
HASKELL_PATH="${HOME}/Library/Haskell/bin:/Library/Haskell/bin:/Library/Frameworks/GHC.framework/Versions/7.10.2-x86_64/usr/bin"
PATH = "$PATH:HASKELL_PATH"
```

### Integrate Hoodle into GHCi

First, install Hoogle:

```
$ cabal --help
Command line interface to the Haskell Cabal infrastructure.

$ cabal install hoogle
... takes a while...
Installed hoogle-4.2.42
Updating documentation index
/Users/ilya/Library/Haskell/share/doc/x86_64-osx-ghc-7.10.2/index.html
```

After this there are local docs available [file:///Users/ilya/Library/Haskell/share/doc/x86_64-osx-ghc-7.10.2/index.html](file:///Users/ilya/Library/Haskell/share/doc/x86_64-osx-ghc-7.10.2/index.html)

Then, define new commands for ghci:
```
$ echo >> ~/.ghci ':def hoogle \x -> return $ ":!hoogle \"" ++ x ++ "\""'
$ echo >> ~/.ghci ':def doc \x -> return $ ":!hoogle --info \"" ++ x ++ "\""'
$ echo >> ~/.ghci ':set prompt "ghci> "'

Download and build Hoogle databases:
$ hoogle data
```

*Try :doc and :hoogle*
```
ghci> :doc nub
Data.List nub :: Eq a => [a] -> [a]

O(n^2). The nub function removes duplicate elements from a list. In particular, it 
keeps only the first occurrence of each element. (The name nub means `essence'.) It 
is a special case of nubBy, which allows the programmer to supply their own equality test. 

From package base
nub :: Eq a => [a] -> [a]

```

# Notes on the book Learn You a Haskell for Great Good

## Chapter 2. Believe the Type

### Type Classes 101

A _type class_ is an interface that defines some behaviour.
If a type is an _instance_ of a type class, then it supports and implements the behaviour the type class describes.

## Chapter 6. Modules

### Import

To import a module:
```haskell
import Data.List
```

To import only _nub_ and _sort_ from _Data.List_ module:
```haskell
import Data.List (nub, sort)
```

To import all except for _nub_ (may be you have your own one):
```haskell
import Data.List hiding (nub)
```

We can also do *qualified imports* to keep current scope clean, and add alias:

```haskell
import qualified Data.Map as M

M.filter []
```

Check implementation of a function: goto http://hackage.haskell.org/package/base-4.8.1.0/docs/src/Data.OldList.html#isInfixOf


## Chapter 7. Making Our Own Types and Type Classes

### Defining a New Data Type

Here is how we make our own type:

```haskell
data Bool = False | True
```

```
data <type> = <value constructor> | <value constructor> | ...
```

Lets create a Shape class:

```haskell
data Shape = Circle Float Float Float | Rectangle Float Float Float Float
```

_Circle_ is a value constructor which has three fields, which take floats.

_Value constructors_ are actually functions that ultimately return a value of a data type:

```
ghci> :t Circle
Circle :: Float -> Float -> Float -> Shape
```

### Type Parameters

_Value constructors_ can take parameters and produce a new value.
_Type constructors_ can take types as parameters to produce new types.

```haskell
data Maybe a = Nothing | Just a
```

where _Maybe_ is a type constructor, and _a_ is a type parameter.

A real type would be _Maybe Int_ or _Maybe String_.

### Type Synonyms

The [Char] and String types are equivalent and interchangeable. That's implemented with _type synonyms_.

```haskell
type String = [Char]

type PhoneBook = [(String,String)]

type Name = String

-- Parameterised type synonyms:
type AssocList k v = [(k, v)]
```

### The Functor Type Class

Functor is a type whose value can be mapped over.

```haskell
class Functor f where
    fmap :: (a -> b) -> f a -> f b
```
where _f_ is a type constructor.

List type is an instance of the Functor type class:
```haskell
instance Functor [] where
    fmap = map
```

#### Maybe As a Functor

Types that can act like a box can be functors. Here is how Maybe is a functor:
```haskell
instance Functor Maybe where
    fmap f (Just x) = Just (f x)
    fmap f Nothing = Nothing
```

Here is how we can map over maybe:
```
ghci> fmap (+4) (Just 5)
Just 9
```

IO is an instance of Functor:
```haskell
instance Functor IO where
    fmap f action = do
        result <- action
        return (f result)
```

Lets use it:
```cmd
ghci> fmap (++"!") getLine
hello
hello!
```

## Chapter 8. Input and Output

```cmd
$ ghc --make reverse.hs
$ ./reverse
it was all a dream
ti saw lla a maerd
```

## Chapter 11. Applicative Functors

### Functions as Functors

fmap over functions is function composition.

```
  a -> b
is the same as:
  (->) a b
```

```haskell
instance Functor ((->) r) where
    fmap f g = (\x -> f (g x))
```

But _f (g x)_ is the same as _(f . g) x_. So:
```haskell
instance Functor ((->) r) where
    fmap = (.)
```

Examples:
```cmd
ghci> (+3) `fmap` (*10) $ 5
53
ghci> (+3) . (*10) $ 5
53
```

**Lifting a function**

If we apply fmap to a function (a -> b) we will get:
```cmd
ghci> :t fmap (*3)
fmap (*3) :: (Functor f, Num b) => f b -> f b
```

In other words (a -> b) is transformed into (f a -> f b). This is called _lifting a function_.
So, fmap takes a function and lifts it so it operates on functor values.


### Functor Laws

1. fmap id = id
2. fmap (f . g)  = fmap f . fmap g


### Applicative Functors

What if we lift a function that has two arguments?

```cmd
ghci>:t fmap (+) (Just 5)
fmap (+) (Just 5) :: Num a => Maybe (a -> a)
```

Our _Just 5_ is now _Just (+5)_. What can we do with it?
```cmd
ghci> let a = fmap (+) (Just 5)
ghci> fmap ($ 2) a
Just 7
```

Can we do anything with _Just (+5)_ and _Just 8_?

So, we have a function in a box and a value in a box. We can use applicative to get a new box with
our boxed function applied to our boxed value!

```haskell
class (Functor f) => Applicative f where
    pure :: a -> f a
    (<*>) :: f (a -> b) -> f a -> f b
```

Example:
```cmd
ghci> Just (+3) <*> (Just 5)
Just 8

ghci> [(+3)] <*> [5]
[8]

ghci> pure (++"!") <*> getLine
hello
"hello!"
```

### Maybe as Applicative:
```haskell
instance Applicative Maybe where
    pure = Just
    Nothing <*> _ = Nothing
    (Just f) <*> something = fmap f something
```

### List as Applicative:
<!-- ```haskell
instance Applicative List where
    pure x = [x]
    _ <*> [] = []
    [] <*> x = []
    [f:fs] <*> x = [f] <*> x : fs <*> x
    [f] <*> [x:xs] = f x : [f] <*> xs
```
or -->
```haskell
instance Applicative List where
    pure x = [x]
    fs <*> xs = [ f x | f <- fs, x <- xs]
```

Example:
```cmd
ghci> [(+3), (*3), (^2)] <*> [1,2,3]
[4,5,6,3,6,9,1,4,9]

ghci> (++) <$> ["hm", "ha"] <*> ["?", "!"]
["hm?","hm!","ha?","ha!"]
```

where _f <$>_ is the same as _pure f <*>_.

### IO as Applicative
```haskell
instance Applicative IO where
    pure = return
    fIO <*> xIO = do
        f <- fIO
        x <- xIO
        return (f x)
```

Example:
```haskel
ghci> return (++"!") <*> getLine
hello
"hello!"
```

The following implementations do same thing:
```haskell
myAction :: IO String
myAction = do
    a <- getLine
    b <- getLine
    return $ a ++ b

myAction = (++) <$> getLine <*> getLine

main = do
    a <- (++) <$> getLine <*> getLine
    putStrLn $ "The two concatenated lines turn out to be: " ++ a
```

### Functions as Applicatives
```haskell
instance Applicative ((->) r) where
    pure x = (\_ -> x)
    f <*> g = (\x -> f x (g x))
```

Examples:
```cmd
ghci> (+3) <$> (*5) $ 2
13

ghci> (+) <$> (+3) <*> (*5) $ 2
15

ghci> (\x y z -> [x,y,z]) <$> (+3) <*> (*2) <*> (*3) $ 5
[8,10,15]
```