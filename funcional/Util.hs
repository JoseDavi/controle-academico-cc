module Util where

import System.IO
import Control.Exception

-- Constantes
n_spaces = 40

-- Seção de controle de strings

repeteCaractere :: String -> Int -> String
repeteCaractere _ 0 = ""
repeteCaractere c n = c ++ repeteCaractere c (n-1)

printStr s = putStr $ (repeteCaractere " " n_spaces) ++ s ++ "\n"

-- Seção de login

getSenha :: IO String
getSenha = do
  hFlush stdout
  pass <- comEco False getLine
  putChar '\n'
  return pass

comEco :: Bool -> IO a -> IO a
comEco echo action = do
  old <- hGetEcho stdin
  bracket_ (hSetEcho stdin echo) (hSetEcho stdin old) action