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
