-- October 9, 2015

let multi3 x = x*3
[multi3 x | x <- [1..5]]

let boombang arr = [if x > 10 then "BOOM" else "BANG" | x <- arr, odd x]
boombang [1..20]

[x*y | x <- [1..5], y <- [2,3]]

let length' xs = sum [1 | _ <- xs]
length' "12345"
--> 5

let removeAllUppercase xs = [x | x <- xs, x `elem` ['A'..'Z']]
removeAllUppercase "asDqwE"
--> DE

let xxs = [[1,3,5,2,3,1,2,4,5],[1,2,3,4,5,6,7,8,9],[1,2,4,2,1,6,3,1,3,2,3,6]]
[ [a | a <- x, even a] | x <- xxs]
--> [[2,2,4],[2,4,6,8],[2,4,2,6,2,6]]

zip [1.. ] ["apple","orange","mango"]
--> [(1,"apple"),(2,"orange"),(3,"mango")]

Which right triangle that has integers for all sides and all sides equal to or smaller than 10 has a perimeter of 24?
[(a,b,c) | a <- [1..10], b <- [1..10], c <- [1..10], a*a + b*b == c*c, a+b+c == 24 ]
--> [(6,8,10),(8,6,10)]

--
-- Types and Typeclasses
--

-- :: is read as "has type of"

factorial :: Integer -> Integer
factorial x = product [1..x]

-- Everything before the => symbol is called a class constraint.

-- The Eq typeclass provides an interface for testing for equality. 

head' :: [a] -> a
head' [] = error "Emptly list does not have a head"
head' x:_ = x


-- let
-- let <bindings> in <expression>

4 * (let a = 9; b = 5 in a + b)
--> 56

[let square x = x^2 in (square 5, square 7, square 9)]
--> [(25,49,81)]

let (a, b, c) = (5, 7, 9) in sum [a, b, c]
--> 21


-- case
-- case <expression> of <pattern> -> <result>
--                      <pattern> -> <result>
--                      ...

--
-- Higher-order Functions
-- 
minus5 :: Int -> Int
minus5 = subtract 5

applyTwice :: (a -> a) -> a -> a
applyTwice f x = f ( f x )

applyTwice minus5 12
--> 2

applyTwice (3:) [1]
--> [3,3,1]

map (++ "!") ["boom","bang"]

map fst [(1,2), (5,6), (7,8)]

filter (>3) [1,2,3,4,5]

let notNull x = not (null x) in filter notNull [[1],[2,3],[],[5,6,7]]
--> [[1],[2,3],[5,6,7]]

filter (`elem` ['a'..'z']) "i loVe tO PLay cHesS"

let isOK x = x `mod` 3829 == 0 in maximum (filter isOK [1..100000])
--> 99554

let isOK x = x `mod` 3829 == 0 in head (filter isOK [100000,99999..])

takeWhile (/= ' ') "elefant is an animal"

let listOfFun = map (*) [0..]
(listOfFun !! 4) 5                  -- Returns element with index 4 from array: [1,2,3,4,5] !! 4 == 5
>>> 20


--
-- Type Classes (p138)
--

class Eq a where
    (==) :: a -> a -> Bool
    (/=) :: a -> a -> Bool
    x == y = not (x /= y)
    x /= y = not (x == y)

data TrafficLight = Red | Yellow | Green

-- Now we make type TrafficLight to be an instance of Eq:
instance Eq TrafficLight where
    Red == Red = True
    Green == Green = True
    Yellow == Yellow = True
    _ == _ = False

instance Show TrafficLight where
    show Red = "Red Light"
    show Yellow = "Red Yellow"
    show Green = "Red Green"

-- This has the same effect as using "deriving":
data TrafficLight = Red | Yellow | Green deriving (Eq, Show)

-- Subclass is just a class constraint on a class declaration:
class (Eq a) => Ord a where
    ...

-- Parameterized Types as Instances of Type Classes:
instance (Eq m) => Eq (Maybe m) where
    Just x == Just y = x == y
    Nothing == Nothing = True
    _ == _ = False