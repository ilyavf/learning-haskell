# Chapter 3

_Algebraic data type_ can have more than one value constructor:
```haskell
data Bool = True | False

type CardHolder = String
type CardNumber = String
type Address = [String]

data BillingInfo = CreditCard CardNumber CardHolder Address
                 | CashOnDelivery
                 | Invoice CustomerID
                   deriving (Show)
```

