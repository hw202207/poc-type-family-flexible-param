module Main where

import  MyLib

main :: IO ()
main = do
  conduitTokenRequest @Foo "foo-auth-code-12" >>= print
  conduitTokenRequest @Bar () >>= print