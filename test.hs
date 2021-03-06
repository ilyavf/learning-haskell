import Data.List

-- Learning Haskell examples.

doubleMe x = x + x
doubleUs x y = doubleMe x + doubleMe y
doubleSmall x = if x > 100 then x else doubleMe x


removeUpperCase :: [Char] -> [Char]
removeUpperCase x = [y | y <- x, y `elem` ['A'..'Z'] ]

factorial :: Integer -> Integer
factorial x = product [1..x]

lucky :: (Integral a) => a -> String  
lucky 7 = "LUCKY NUMBER SEVEN!"  
lucky x = "Sorry, you're out of luck, pal!"

fact :: (Integral a) => a -> a
fact 0 = 1
fact x = x * fact (x - 1)

head' :: [a] -> a
head' [] = error "empty list does not have a head"
head' (x:_) = x

add' :: Int -> Int -> Int
add' 5 5 = error "twenty five"
add' x y = x + y

tell :: (Show a) => [a] -> String
tell [] = "This string is empty"
tell [x] = "This string has one element " ++ show x
tell [x,y] = "This string has two elements " ++ show x ++ " and " ++ show y
tell (x:y:_) = "This string is long and has two elements " ++ show x ++ " and " ++ show y

length' :: [a] -> Int
length' [] = 0
length' (_:xs) = 1 + length' xs

sum' :: (Num a) => [a] -> a
sum' [x] = x
sum' (x:xs) = x + sum' xs

bmiTell :: Double -> Double -> String
bmiTell weight height
    | bmi <= skinny = "You are underweight, eat more!"
    | bmi <= normal = "Looking good!"
    | bmi <= 30.0 = "You are overwieght!"
    | otherwise  = "You're a whale!"
    where bmi = weight / height ^ 2
          skinny = 18.5
          normal = 25.0

max' :: Int -> Int -> Int
max' a b
    | a < b = b
    | otherwise = a

compare' :: Int -> Int -> String
a `compare'` b
    | a < b = "LT"
    | a > b = "GT"
    | otherwise = "EQ"

-- p.44
initials :: String -> String -> String
initials first last = [f] ++ ". " ++ [l] ++ "."
  where (f:_) = first
        (l:_) = last

-- global vars:
greeting :: String
greeting = "Hi, "

greet :: String -> String
greet "Juan" = greeting ++ "Juan!"
greet x = "Hello, " ++ x

calcBmis :: [(Double, Double)] -> [Double]
calcBmis xs = [bmi x y | (x, y) <- xs]
  where bmi weight height = weight / height ^ 2

-- p.45
cilindr :: Double -> Double -> Double
cilindr r h =
  let sideArea = 2 * pi * r * h
      topArea = pi * r ^ 2
  in sideArea + 2 * topArea

-- p.48
describeList :: [a] -> String
describeList ls = "List is "
    ++ case ls of  [] -> "empty"
                   [x] -> "singleton"
                   (x:_) -> "long"
    ++ "!"
    ++ case ls of [] -> " Yes, empty."
                  xs -> " Yes, NOT empty."

--
-- Recursion
-- 

fibonacci :: Int -> Int
fibonacci 0 = 0
fibonacci 1 = 1
fibonacci x = fibonacci (x - 1) + fibonacci (x - 2)

maximum' :: [Int] -> Int
maximum' [x] = x
--maximum' (x:xs) = (let rest = maximum' xs in if x > rest then x else rest)
maximum' (x:xs) = max x (maximum' xs)

replicate' :: Int -> a -> [a]
--replicate' 1 x = [x]
--replicate' n x = x : replicate' (n-1) x
replicate' n x
  | n <= 0 = []
  | otherwise = x : replicate' (n-1) x


take' :: Int -> [a] -> [a]
--take' n xs
--  | n <= 0    = []
--  | xs == []  = []
--  | otherwise = case xs of (x:xss) -> x : take' (n-1) xss
take' n _
  | n <= 0 = []
take' _ [] = []
take' n (x:xs) = x : take' (n-1) xs


reverse' :: [a] -> [a]
reverse' [] = []
reverse' (x:xs) = reverse' xs ++ [x]

repeat' :: a -> [a]
repeat' x = x : repeat' x

zip' :: [a] -> [b] -> [(a,b)]
zip' [] _ = []
zip' _ [] = []
zip' (x:xs) (y:ys) = (x,y) : zip' xs ys

elem' :: (Eq a) => a -> [a] -> Bool
elem' _ [] = False
elem' z (x:xs) = z == x || elem' z xs

quickSort :: (Ord a) => [a] -> [a]
quickSort [] = []

quickSort (x:xs) = quickSort smaller  ++ [x] ++ quickSort larger
  where smaller = [a | a <- xs, a <= x]
        larger = [a | a <- xs, a > x]

--
-- Higher-order Functions
-- 

divideBy10 :: Double -> Double
divideBy10 = (/10)

minus5 :: Int -> Int
minus5 = subtract 5

applyTwice :: (a -> a) -> a -> a
applyTwice f x = f ( f x )

zipWith' :: (a -> b -> c) -> [a] -> [b] -> [c]
zipWith' _ [] _ = []
zipWith' _ _ [] = []
zipWith' f (x:xs) (y:ys) = f x y : zipWith' f xs ys

flip' :: (a -> b -> c) -> b -> a -> c
flip' f x y = f y x
--flip' :: (a -> b -> c) -> (b -> a -> c)
--flip' f = g
--  where g x y = f y x

map' :: (a -> b) -> [a] -> [b]
map' _ [] = []
map' f (x:xs) = f x : map' f xs 

--filter' :: (a -> Bool) -> [a] -> [a]
--filter' _ [] = []
--filter' f (x:xs) = (if f x then [x] else []) ++ filter' f xs

filter' :: (a -> Bool) -> [a] -> [a]
filter' _ [] = []
filter' f (x:xs)
  | f x = x : filter' f xs
  | otherwise = filter' f xs

-- 100,000  3,829
largestDivisible :: Integer
largestDivisible = head (filter p [100000,99999..])
  where p x = x `mod` 3829 == 0

-- Sum of all odd squares that are less than 10,000:
sumOfOdd :: Integer
sumOfOdd = sum (takeWhile (<10000) (filter odd (map (^2) [1..])))

-- Collatz chain:
-- if 1, stop
-- if even, /2
-- if odd, * 3 + 1
collatzChain :: Int -> [Int]
collatzChain 1 = [1]
collatzChain x = x : collatzChain (next x)
  where next x
          | x == 1 = 1
          | even x = x `div` 2
          | odd x = x * 3 + 1

-- How many collatz chains starting with [1..100] is longer than 15?
collatzGreater15 :: Int
collatzGreater15 = length (filter (long 15) (map collatzChain [1..100]))
  where long n xs = length xs > n


--
-- Fold
-- 

-- :t foldl
-- foldl :: Foldable t => (b -> a -> b) -> b -> t a -> b

sum'':: (Num a) => [a] -> a
--sum'' xs = foldl (\acc x -> acc + x) 0 xs
sum'' xs = foldl (+) 0 xs

map'':: (a -> b) -> [a] -> [b]
map'' f xs = foldr (\x acc ->  f x : acc ) [] xs

elem'':: (Eq a) => a -> [a] -> Bool
elem'' a xs = foldr (\x acc -> acc || x == a) False xs

maximum'':: (Ord a) => [a] -> a
--maximum'' xs = foldl1 max xs
maximum'' = foldl1 max

reverse'':: [a] -> [a]
--reverse'' = foldl (\acc x -> x:acc) [] 
reverse'' = foldl (flip (:)) []

product'':: (Num a) => [a] -> a
product'' = foldr1 (*)

filter'':: (a -> Bool) -> [a] -> [a]
filter'' f = foldr (\x acc -> if f x then x:acc else acc) []

last'':: [a] -> a
--last'' = foldr1 (\x acc -> acc)
--
last'' = foldl1 (\_ x -> x)

and'' :: [Bool] -> Bool
and'' = foldr (&&) True

-- How many elements does it take for the sum of sqrt of natural elements to exceed 100?
--sumOfSqrt = length (takeWhile (<1000) (scanl (\acc x -> sqrt x + acc) 0 [1..1000]))
sumOfSqrt = length (takeWhile (<1000) (scanl1 (+) (map sqrt [1..]) )) + 1


-- 
-- Function application with $
-- p80

application1 = replicate 2 . product . map (*3) $ zipWith max [1,2] [4,5]
-- [180, 180]


-- October 24, 2015

--
-- Chapter 6. Modules
-- 

-- Find how many times each word appears in a string:
str1 = "boom bip bip boom boom"
wordCount = map (\xs -> (head xs, length xs)) .group . sort . words
-- >>> [("bip",2),("boom",3)]

-- Check if 1st list is wholly contained in the 2nd list:
l1 = [3,4]
l2 = [1,2,3,4,5]
isContained :: (Eq a) => [a] -> [a] -> Bool
-- v1:
--isContained _ [] = False
--isContained xs ys = (xs `elem` tails ys) || (isContained xs (init ys))
-- v2:
--isContained xs ys = foldl (||) False $ map (isPrefixOf xs) $ tails ys
isContained xs ys = any (isPrefixOf xs) $ tails ys
-- In the book:
needle `isIn` haystack = any (needle `isPrefixOf`) (tails haystack)
-- Data.List has "isInfixOf".



--
-- Chapter 7.
--
-- Recursive data structure:

-- data List a = Empty | Cons a (List a) deriving (Show, Read, Eq, Ord)
-- 7 `Cons` (5 `Cons` Empty)

-- Now lets define an infix constructor for our list:
-- Infix constructors must begin with a colon.
infixr 5 :-:
data List a = Empty | a :-: (List a) deriving (Show, Read, Eq, Ord)
--
--    5 :-: (6 :-: Empty)

-- Lets create infix list concat:
infix 5 ^++
(^++) :: List a -> List a -> List a
Empty ^++ ys = ys
(x :-: xs) ^++ ys = x :-: (xs ^++ ys)
--
--    ghci> let a = 5 :-: Empty
--    ghci> let b = 7 :-: Empty
--    ghci> a ^++ b
--    5 :-: (7 :-: Empty)

-- Trees:

-- data Tree a = Empty | Node a (Tree a) (Tree a) ()

-- [test]
-- [test]

newtype Product a = Product { getProduct :: a}
    deriving (Eq, Show)

instance Num a => Monoid (Product a) where
    mempty = Product 1
    Product x `mappend` Product y = Product (x * y)

newtype Any = Any { getBoolOr :: Bool }
    deriving (Eq, Show)

instance Monoid Any where
    mempty = Any False
    Any x `mappend` Any y = Any (x || y)



--
-- Monads:
--
foo :: Maybe Int
foo = Just 6        >>= (\x ->
      Just (x + 5)  >>= (\y ->
      Just (y * 2)))

foo2 :: Maybe Int
foo2 = do
    x <- Just 6
    y <- Just (x + 5)
    Just (y * 2)

-- splitWhen (== ';') "A;BB;;DDDD"
-- takeWhile (== ';') "A;BB;;DDDD"

splitWhen :: (a -> Bool) -> [a] -> [[a]]
splitWhen f [] = []
splitWhen f a = x : (splitWhen f xs)
    where splitted = (span (not . f) a)
          x = fst splitted
          _:xs = snd splitted
