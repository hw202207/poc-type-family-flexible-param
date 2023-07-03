{-# LANGUAGE DerivingStrategies #-}
{-# LANGUAGE TypeFamilies #-}

module MyLib where

class HasTokenRequest a where
    type AuthCode a
    data TokenRequestParam a

    mkTokenRequestParam :: AuthCode a -> TokenRequestParam a

data Foo = Foo
data Bar = Bar

instance HasTokenRequest Foo where
    -- Foo request a AuthCode (String type)
    type AuthCode Foo = String

    data TokenRequestParam Foo = FooTokenRequestParam
        { fooAge :: Int
        , authCode :: String
        }
        deriving stock (Show)

    mkTokenRequestParam :: String -> TokenRequestParam Foo
    mkTokenRequestParam code =
        FooTokenRequestParam
            { fooAge = 12
            , authCode = code
            }

instance HasTokenRequest Bar where
    -- Bar doesn't need AuthCode at all.
    -- I regard use '()' type as work around
    type AuthCode Bar = ()

    data TokenRequestParam Bar = BarTokenRequestParam
        { barUserName :: String
        , barPassword :: String
        }
        deriving stock (Show)

    mkTokenRequestParam :: () -> TokenRequestParam Bar
    mkTokenRequestParam _ =
        BarTokenRequestParam
            { barUserName = "login@test.com"
            , barPassword = "12345"
            }

conduitTokenRequest ::
    (HasTokenRequest a) =>
    AuthCode a ->
    IO (TokenRequestParam a)
conduitTokenRequest ac = do
    pure (mkTokenRequestParam ac)
