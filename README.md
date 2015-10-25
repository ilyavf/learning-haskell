# learning-haskell
Learning Haskell

# Help/API/cmd tools

- https://www.haskell.org/hoogle/
- https://wiki.haskell.org/Hoogle#GHCi_Integration
- http://hackage.haskell.org/packages/
 - http://hackage.haskell.org/package/base-4.8.1.0/docs/Prelude.html - docs for Standard types, classes and related functions
 - http://hackage.haskell.org/package/base-4.8.1.0/docs/Data-List.html

Local docs after installing 

## The Haskell Cabal and Hoodle

Common Architecture for Building Applications and Libraries

Cabal is a system for building and packaging Haskell libraries and programs.

Hoogle is a Haskell API search engine

Install hoogle:
```
$ cabal --help
Command line interface to the Haskell Cabal infrastructure.

$ cabal install hoogle
... takes a while...
Installed hoogle-4.2.42
Updating documentation index
/Users/ilya/Library/Haskell/share/doc/x86_64-osx-ghc-7.10.2/index.html
```

Local docs [file:///Users/ilya/Library/Haskell/share/doc/x86_64-osx-ghc-7.10.2/index.html] file:///Users/ilya/Library/Haskell/share/doc/x86_64-osx-ghc-7.10.2/index.html

Integrate Hoodle into GHCi:
```
$ echo >> ~/.ghci ':def hoogle \x -> return $ ":!hoogle \"" ++ x ++ "\""'
$ echo >> ~/.ghci ':def doc \x -> return $ ":!hoogle --info \"" ++ x ++ "\""'

Download and build Hoogle databases:
$ hoogle data
```

Try :doc and :hoogle
```
ghci> :doc nub
Data.List nub :: Eq a => [a] -> [a]

O(n^2). The nub function removes duplicate elements from a list. In particular, it keeps only the first occurrence of each element. (The name nub means `essence'.) It is a special case of nubBy, which allows the programmer to supply their own equality test. 

From package base
nub :: Eq a => [a] -> [a]

```

# Notes on the book Learn You a Haskell for Great Good

## Chapter 6. Modules