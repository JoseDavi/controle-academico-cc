module Util where

import System.IO
import Control.Exception
import Constants
import Data.List

{- Seção de controle de strings -}

-- Retorna uma string com um caractere repetido determinadas vezes
repeteCaractere :: String -> Int -> String
repeteCaractere char vezes = unwords $ take vezes $ repeat char

-- Adiciona espaços após quebras de linhas
adiciona_espacos :: Int -> String -> String
adiciona_espacos spaces str = do 
  intercalate "" (map replace str) 
    where 
      replace :: Char -> String
      replace '\n' = "\n" ++ (repeteCaractere " " spaces)
      replace c = [c]

{- Seção de login -}

-- Recebe uma senha na entrada padrão
getSenha :: IO String
getSenha = do
  hFlush stdout
  pass <- comEco False getLine
  putChar '\n'
  return pass

-- Recebe uma string sem echo na entrada padrão
comEco :: Bool -> IO a -> IO a
comEco echo action = do
  old <- hGetEcho stdin
  bracket_ (hSetEcho stdin echo) (hSetEcho stdin old) action


{- Seção de utilitários para "interface gráfica" -}

-- Limpa a tela adicionando cem quebras de linha no terminal
limpar_tela :: IO()
limpar_tela = do
    putStr (repeteCaractere "\n" 100)

-- Exibe uma mensagem com identação na saída padrão com quebra de linha
printStrLn :: String -> IO()
printStrLn s = putStr $ (repeteCaractere " " spaces_idented) ++ s ++ "\n"

-- Exibe uma mensagem com identação para a tela de login na saída padrão
printCenter :: String -> IO()
printCenter s = putStr $ (repeteCaractere " " spaces_center) ++ s

-- Exibe uma mensagem identada na sáida sem quebra de linha
printStr :: String -> IO()
printStr s = putStr $ (repeteCaractere " " spaces_idented) ++ s