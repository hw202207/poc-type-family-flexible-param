module Main where

import MyLib

main :: IO ()
main = do
  conduitTokenRequest Foo "foo-auth-code-12" >>= print
  conduitTokenRequest Bar NoAuthCode >>= print

{-
I guess ideal if we could do
  conduitTokenRequest Foo "foo-auth-code-12" >>= print
  conduitTokenRequest Bar >>= print
-}
