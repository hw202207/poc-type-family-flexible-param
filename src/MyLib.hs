{-# LANGUAGE DerivingStrategies #-}
{-# LANGUAGE TypeFamilies #-}

module MyLib where

class HasTokenRequest a where
    type AuthCode a
    data TokenRequestParam a

    mkTokenRequestParam :: a -> AuthCode a -> TokenRequestParam a

    toRequestString :: TokenRequestParam a -> String

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

    mkTokenRequestParam :: Foo -> String -> TokenRequestParam Foo
    mkTokenRequestParam _ code =
        FooTokenRequestParam
            { fooAge = 12
            , authCode = code
            }
    toRequestString :: TokenRequestParam Foo -> String
    toRequestString = show

data NoAuthCode = NoAuthCode

instance HasTokenRequest Bar where
    -- Bar doesn't need AuthCode at all.
    -- I regard use '()' type as work around
    type AuthCode Bar = NoAuthCode

    data TokenRequestParam Bar = BarTokenRequestParam
        { barUserName :: String
        , barPassword :: String
        }
        deriving stock (Show)

    mkTokenRequestParam :: Bar -> NoAuthCode -> TokenRequestParam Bar
    mkTokenRequestParam _ _ =
        BarTokenRequestParam
            { barUserName = "login@test.com"
            , barPassword = "12345"
            }
    toRequestString :: TokenRequestParam Bar -> String
    toRequestString = show

conduitTokenRequest ::
    (HasTokenRequest a) =>
    a ->
    AuthCode a ->
    IO String
conduitTokenRequest a ac = do
    -- There will be many logic here under IO computation
    pure (toRequestString $ mkTokenRequestParam a ac)
