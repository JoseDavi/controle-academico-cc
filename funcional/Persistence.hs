{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}

module Persistence where

import qualified Data.Text as T
import GHC.Generics
import Data.Aeson

-- Representação do usuário no sistema
data Usuario = Usuario
    { matricula :: String
    , senha :: String
    , tipo :: String
    , nomeUsuario :: String
    } deriving (Show,Generic)

instance FromJSON Usuario
instance ToJSON Usuario

-- Representação da disciplina no sistema
data Disciplina = Disciplina
    { id :: Int
    , nomeDisciplina :: String
    , limite :: Int
    , p_requisito :: Int
    , s_requisito :: Int
    } deriving (Show, Generic)

instance FromJSON Disciplina
instance ToJSON Disciplina