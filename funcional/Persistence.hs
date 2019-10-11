{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}

module Persistence where

import qualified Data.Text as T
import qualified Data.ByteString.Lazy as B

import GHC.Generics
import Data.Aeson
import Data.Maybe
import Control.DeepSeq
import System.Directory

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


-- Representação do estado do sistema
data Estado = Estado
    { estadoSistema :: Int
    } deriving (Show, Generic, Eq)

instance FromJSON Estado
instance ToJSON Estado


-- Representação da vinculação entre professor e disciplina
data ProfessorDisciplina = ProfessorDisciplina
    { matriculaProfessor :: String
    , disciplinasProfessor :: [Int]
    }

instance FromJSON ProfessorDisciplina
instance ToJSON ProfessorDisciplina


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

salvaUsuario :: Usuario -> IO()
salvaUsuario usuario = do
    usuarios <- leUsuarios
    B.writeFile "resources/usuarios_temp.json" (encode (usuarios ++ [usuario]))
    removeFile "resources/usuarios.json"
    renameFile "resources/usuarios_temp.json" "resources/usuarios.json"

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

salvaAluno :: Aluno -> IO()
salvaAluno novoAluno = do
    alunos <- leAlunos
    B.writeFile "resources/alunos_temp.json" (encode (alunos ++ [novoAluno]))
    removeFile "resources/alunos.json"
    renameFile "resources/alunos_temp.json" "resources/alunos.json"

atualizaAluno :: Aluno -> IO()
atualizaAluno aluno = do
    alunosBD <- leAlunos
    let alunos = (removeAluno aluno alunosBD)
    B.writeFile "resources/alunos_temp.json" (encode (alunos ++ [aluno]))
    removeFile "resources/alunos.json"
    renameFile "resources/alunos_temp.json" "resources/alunos.json"

removeAluno :: Aluno -> [Aluno] -> [Aluno]
removeAluno _ []  = []
removeAluno a (a1:an) | matriculaAluno a == matriculaAluno a1 = removeAluno a an
                      | otherwise = a1 : removeAluno a an
    
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

salvaEstado :: Estado -> IO()
salvaEstado estado = do
    B.writeFile "resources/estado.json" (encode estado)

leEstado :: IO (Maybe Estado)
leEstado = do
    byteStrEstado <- B.readFile "resources/estado.json"
    let estado = decode byteStrEstado :: Maybe Estado
    return (estado)

leProfessorDisciplinas :: IO ([ProfessorDisciplina])
leProfessorDisciplinas = do
    byteStrProfessorDisciplina <- B.readFile "resources/professor_disciplina.json"
    let professorDisciplina = fromJust (decode byteStrProfessorDisciplina :: Maybe [ProfessorDisciplina])
    return (professorDisciplina)

alocaProfessor :: (String, Int) -> IO()
alocaProfessor professor_disciplina = do
    let usuariosBD = leUsuarios
    let disciplinasBD = leDisciplinas

    let usuarioQUERY = [u | u <- usuariosBD, 
                            matricula u == (fst professor_disciplina)]

    let disciplinaQUERY = [d | d <- disciplinasBD, 
                               Persistence.id d == (snd professor_disciplina)]

    if (usuarioQUERY /= [] && disciplinaQUERY /= []) then
        let professorDisciplinasBD = leProfessorDisciplinas
        let professor_temp = [p | p <- professorDisciplinasBD,
                                  matriculaProfessor p == (fst professor_disciplina)]
        insert <- case professor_temp of
                    [] -> do
                        let temp = ProfessorDisciplina (fst professor_disciplina) [fst professor_disciplina]
                        return (professorDisciplinasBD ++ [temp])
                    p -> do
                        
    else
        printStr "Usuário ou disciplina incorretos..."

getDisciplina :: Int -> [Disciplina] ->  Disciplina
getDisciplina idBusca disciplinas =  head [disc | disc <- disciplinas, (Persistence.id disc) == idBusca]


verificaDisciplinaJaMatriculada :: Int -> [MetaDisciplina]-> Bool
verificaDisciplinaJaMatriculada idBusca listaDisciplinas = [] /= [disc | disc <- listaDisciplinas, (idMetaDisciplina disc) == idBusca] 
                     