{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}

module Persistence where

import qualified Data.Text as T
import qualified Data.ByteString.Lazy as B

import GHC.Generics
import Data.Aeson
import Data.Maybe
import Control.DeepSeq

-- Representação do usuário no sistema
data Usuario = Usuario
    { matricula :: String
    , senha :: String
    , tipoUsuario :: String
    , nomeUsuario :: String
    } deriving (Show, Generic, Eq)

instance FromJSON Usuario
instance ToJSON Usuario


-- Representação do aluno no sistema
data Aluno = Aluno
    { matriculaAluno :: String
    , nomeAluno :: String
    , disciplinasMatriculadas :: Int
    , estaDesvinculado :: Bool
    , disciplinas :: [MetaDisciplina]
    } deriving (Show, Generic, Eq)

instance FromJSON Aluno
instance ToJSON Aluno

-- Representação de disciplina de um aluno
data MetaDisciplina = MetaDisciplina
    { idMetaDisciplina :: Int
    , nomeMetaDisciplina :: String
    , faltas :: Int
    , notas :: [Double]
    , estado :: String
    } deriving (Show, Generic, Eq)

instance FromJSON MetaDisciplina
instance ToJSON MetaDisciplina

-- Representação da disciplina no sistema
data Disciplina = Disciplina
    { id :: Int
    , nomeDisciplina :: String
    , limite :: Int
    , p_requisito :: Int
    , s_requisito :: Int
    } deriving (Show, Generic, Eq)

instance FromJSON Disciplina
instance ToJSON Disciplina


{- Seção para recuperação de informações dos arquivos -}

leDisciplinas :: IO ([Disciplina])
leDisciplinas = do
    byteStrDisciplinas <- B.readFile "resources/disciplinas.json"
    let disciplinas = fromJust (decode byteStrDisciplinas :: Maybe [Disciplina])
    return (disciplinas)

leUsuarios :: IO ([Usuario])
leUsuarios = do
    byteStrUsuarios <- B.readFile "resources/usuarios.json"
    let usuarios = fromJust (decode byteStrUsuarios :: Maybe [Usuario])
    return (usuarios)

leUsuario :: String -> IO (Maybe Usuario)
leUsuario matr = do
    -- Todos os usuário registrados até o momento
    usuariosBD <- leUsuarios

    -- Realiza uma pesquisa sobre os usuários existentes
    let usuarioQUERY = [u | u <- usuariosBD, 
                           matricula u == matr]
    
    if (usuarioQUERY == []) then
        return (Nothing)
    else
        return (Just (usuarioQUERY !! 0))

leAlunos :: IO ([Aluno])
leAlunos = do
    byteStrAlunos <- B.readFile "resources/alunos.json"
    let alunos = fromJust (decode byteStrAlunos :: Maybe [Aluno])
    return (alunos)

leAluno :: String -> IO (Maybe Aluno)
leAluno matr = do
    -- Todos os alunos registrados até o momento
    alunosBD <- leAlunos

    -- Realiza uma pesquisa sobre os alunos existentes
    let alunoQUERY = [a | a <- alunosBD, 
                            matriculaAluno a == matr]
    
    if (alunoQUERY == []) then
        return (Nothing)
    else
        return (Just (alunoQUERY !! 0))

salvaAlunos :: [Aluno] -> IO()
salvaAlunos alunos = do
    B.writeFile "resources/alunos.json" (encode alunos)

leSessao :: IO (Maybe Usuario)
leSessao = do
    byteStrSessao <- B.readFile "resources/sessao.json"
    let usuario = decode byteStrSessao :: Maybe Usuario
    return (usuario)

salvaSessao :: Usuario -> IO()
salvaSessao usuario = do
    B.writeFile "resources/sessao.json" (encode usuario)

limpaSessao :: IO()
limpaSessao = do
    B.writeFile "resources/sessao.json" ""

removeAluno :: Aluno -> [Aluno] -> [Aluno]
removeAluno _ []  = []
removeAluno a (a1:an) | a == a1 = removeAluno a an
                      | otherwise = a1 : removeAluno a an


getDisciplina :: Int -> [Disciplina] ->  Disciplina
getDisciplina idBusca disciplinas =  head [disc | disc <- disciplinas, (Persistence.id disc) == idBusca]

                     