module Monade where

import qualified Data.Map.Strict as Map

-- ============================================================
--    T X = (X * S)^S
-- ============================================================

newtype State s a = State (s -> (a, s))

run :: State s a -> s -> (a, s)
run (State f) s = f s

instance Functor (State s) where
    -- fmap : (a -> b) -> (T a -> T b)
    -- fmap : (a -> b) -> ((s -> (a, s)) -> (s -> (b, s))
  fmap f (State g) = State $ \s -> let (x, s') = g s in (f x, s')

instance Applicative (State s) where
  pure x = State $ \s -> (x, s)
  State mf <*> State mx = State $ \s ->
    let (f, s')  = mf s
        (x, s'') = mx s'
    in (f x, s'')

instance Monad (State s) where
  return = pure
  State m >>= k = State $ \s ->
    let (x, s') = m s
    in run (k x) s'

get :: State s s
get = State $ \s -> (s, s)

put :: s -> State s ()
put s = State $ \_ -> ((), s)

incr :: State Int ()
incr = do
  n <- get
  put (n + 1)

example :: State Int Int
example =
  (get >>= \x -> incr >>= (\_ -> get >>= \y -> return (x * y)))

doExample :: State Int Int
doExample = do
    x <- get
    incr
    y <- get
    return (x * y)

-- ============================================================
--    T X = X*
-- ============================================================

-- newtype NonDet a = NonDet [a] deriving Show

-- instance Functor NonDet where
--   fmap f (NonDet xs) = NonDet (map f xs)

-- instance Applicative NonDet where
--   pure x = NonDet [x]
--   NonDet fs <*> NonDet xs = NonDet [f x | f <- fs, x <- xs]

-- instance Monad NonDet where
--   return = pure
--   NonDet xs >>= k = NonDet (concatMap (elements . k) xs)
--     where
--       elements (NonDet ys) = ys

-- choose :: NonDet a -> NonDet a -> NonDet a
-- choose (NonDet xs) (NonDet ys) = NonDet (xs ++ ys)

-- failure :: NonDet a
-- failure = NonDet []

-- chooseFrom :: [a] -> NonDet a
-- chooseFrom [] = failure
-- chooseFrom (x:xs) = choose (return x) (chooseFrom xs)

-- guardND :: Bool -> NonDet ()
-- guardND True  = return ()
-- guardND False = failure

-- -- pythagorean :: Int -> NonDet (Int, Int, Int)
-- pythagorean n = do
--   a <- chooseFrom [1 .. n]
--   b <- chooseFrom [a .. n]
--   c <- chooseFrom [b .. n]
--   guardND (a * a + b * b == c * c)
--   return (a, b, c)

--   -- chooseFrom [1 .. n] >>= \a ->
--   --   chooseFrom [a .. n] >>= \b ->
--   --     chooseFrom [b .. n] >>= \c ->
--   --       guardND (a * a + b * b == c * c) >>= \_ ->
--   --         return (a, b, c)

-- queens :: Int -> NonDet [(Int, Int)]
-- queens 0 = return []
-- queens n =
--   loop n
--     where
--       loop 0 = return []
--       loop c =
--         do
--           r  <- chooseFrom [1..n]
--           qs <- loop (c - 1)
--           guardND (safe (r, c) qs)
--           return ((r, c) : qs)

-- safe :: (Int, Int) -> [(Int, Int)] -> Bool
-- safe (r, c) qs = and [r /= r' && abs (c - c') /= abs (r - r') | (r', c') <- qs]

-- ============================================================
--    T X = X + 1
-- ============================================================

newtype NonDetMaybe a = NonDetMaybe (Maybe a) deriving Show

instance Functor NonDetMaybe where
  fmap f (NonDetMaybe Nothing) = NonDetMaybe Nothing
  fmap f (NonDetMaybe (Just x)) = NonDetMaybe (Just (f x))

instance Applicative NonDetMaybe where
  pure x = NonDetMaybe (Just x)
  _ <*> _ = error "Not implemented"

instance Monad NonDetMaybe where
  return = pure
  NonDetMaybe Nothing >>= k = NonDetMaybe Nothing
  NonDetMaybe (Just x) >>= k = k x

choose :: NonDetMaybe a -> NonDetMaybe a -> NonDetMaybe a
choose (NonDetMaybe (Just x)) _ = NonDetMaybe (Just x)
choose (NonDetMaybe Nothing) m = m

failure :: NonDetMaybe a
failure = NonDetMaybe Nothing

chooseFrom :: [a] -> NonDetMaybe a
chooseFrom [] = failure
chooseFrom (x:xs) = choose (return x) (chooseFrom xs)

guardND :: Bool -> NonDetMaybe ()
guardND True  = return ()
guardND False = failure

-- pythagorean :: Int -> NonDetMaybe (Int, Int, Int)
pythagorean n = do
  a <- chooseFrom [1 .. n]
  b <- chooseFrom [a .. n]
  c <- chooseFrom [b .. n]
  -- guardND (a * a + b * b == c * c)
  return a
  -- return (a, b, c)

  -- chooseFrom [1 .. n] >>= \a ->
  --   chooseFrom [a .. n] >>= \b ->
  --     chooseFrom [b .. n] >>= \c ->
  --       guardND (a * a + b * b == c * c) >>= \_ ->
  --         return (a, b, c)

queens :: Int -> NonDetMaybe [(Int, Int)]
queens 0 = return []
queens n =
  loop n
    where
      loop 0 = return []
      loop c =
        do
          r  <- chooseFrom [1..n]
          qs <- loop (c - 1)
          guardND (safe (r, c) qs)
          return ((r, c) : qs)

safe :: (Int, Int) -> [(Int, Int)] -> Bool
safe (r, c) qs = and [r /= r' && abs (c - c') /= abs (r - r') | (r', c') <- qs]

-- -- ============================================================
-- --    T X = D X
-- -- ============================================================

-- newtype Prob a = Prob [(a, Double)]

-- instance Show a => Show (Prob a) where
--   show (Prob xs) = unlines
--     [ show x ++ ": " ++ show (round (p * 100) :: Int) ++ "%" | (x, p) <- xs ]

-- instance Functor Prob where
--   fmap f (Prob xs) = Prob [(f x, p) | (x, p) <- xs]

-- instance Applicative Prob where
--   pure x = Prob [(x, 1.0)]
--   Prob fs <*> Prob xs = Prob [(f x, p * q) | (f, p) <- fs, (x, q) <- xs]

-- instance Monad Prob where
--   return = pure
--   Prob xs >>= k = Prob
--     collectProbabilities [(y, p * q) | (x, p) <- xs, (y, q) <- runProb (k x)]
--       where
--         runProb (Prob ys) = ys


-- uniform :: [a] -> Prob a
-- uniform xs = Prob [(x, 1.0 / fromIntegral (length xs)) | x <- xs]

-- die :: Prob Int
-- die = uniform [1 .. 6]

-- expected :: Prob Double -> Double
-- expected (Prob xs) = sum [x * p | (x, p) <- xs]

-- twoDice :: Prob Int
-- twoDice = do
--   d1 <- die
--   d2 <- die
--   return (d1 + d2)
