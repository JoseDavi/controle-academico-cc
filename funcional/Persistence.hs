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
import Data.List

import Util

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
    } deriving (Show, Generic, Eq)

instance FromJSON ProfessorDisciplina
instance ToJSON ProfessorDisciplina


-- Representação de trancamentos no sistema
data Trancamento 
    = TrancamentoDisciplina { tag :: String, matrTrancamentoDisc :: String, idDisciplinaTrancamento :: Int }
    | TrancamentoCurso { tag :: String, matrTrancamentoCur :: String } deriving (Show, Generic, Eq) 

instance FromJSON Trancamento
instance ToJSON Trancamento

-- Representação string de um trancamento
trancamento_para_string :: Trancamento -> String
trancamento_para_string (TrancamentoDisciplina tag mat id) =
    "Aluno de matrícula " ++ show mat ++ " solicita trancamento de disciplina " ++ show id
trancamento_para_string (TrancamentoCurso tag mat) =
    "Aluno de matrícula " ++ show mat ++ " solicita trancamento de curso"

-- Representação string dos trancamentos
trancamentos_para_string :: [Trancamento] -> Int -> String
trancamentos_para_string [] _ = "" 
trancamentos_para_string (t1:tn) c = 
    show c ++ ") " ++ trancamento_para_string t1 ++ "\n" ++ trancamentos_para_string tn (c+1)

    
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

removeProfessorDisciplina :: ProfessorDisciplina -> [ProfessorDisciplina] -> [ProfessorDisciplina]
removeProfessorDisciplina _ []  = []
removeProfessorDisciplina p (p1:pn) 
                        | matriculaProfessor p == matriculaProfessor p1 = removeProfessorDisciplina p pn
                        | otherwise = p1 : removeProfessorDisciplina p pn

alocaProfessor :: (String, Int) -> IO()
alocaProfessor professor_disciplina = do
    usuariosBD <- leUsuarios
    disciplinasBD <- leDisciplinas

    let usuarioQUERY = [u | u <- usuariosBD, 
                            matricula u == (fst professor_disciplina),
                            tipoUsuario u == "professor"]

    let disciplinaQUERY = [d | d <- disciplinasBD, 
                               Persistence.id d == (snd professor_disciplina)]

    if (usuarioQUERY /= [] && disciplinaQUERY /= []) then do
        professorDisciplinasBD <- leProfessorDisciplinas
        
        let professor_temp = [p | p <- professorDisciplinasBD,
                                  (matriculaProfessor p) == (fst professor_disciplina)]
        
        
        let disciplinas = disciplinasProfessor (professor_temp !! 0)
        let disciplina_repetida = [d | d <- disciplinasProfessor (professor_temp !! 0), 
                                       d == (snd professor_disciplina)]

        insert <- if professor_temp == [] then do
                    let temp = ProfessorDisciplina (fst professor_disciplina) [snd professor_disciplina]
                    return (professorDisciplinasBD ++ [temp])
                  else if disciplina_repetida == [] then do
                    let p = professor_temp
                    let professorDisciplinas = (removeProfessorDisciplina (p !! 0) professorDisciplinasBD)
                    let temp = ProfessorDisciplina (matriculaProfessor (p !! 0)) ((disciplinasProfessor (p !! 0)) ++ [(snd professor_disciplina)])
                    return (professorDisciplinas ++ [temp])
                  else do
                    putStr "\n"
                    printStrLn "Professor já esta alocado em disciplina."
                    return (professorDisciplinasBD)

        B.writeFile "resources/professor_disciplina_temp.json" (encode insert)
        removeFile "resources/professor_disciplina.json"
        renameFile "resources/professor_disciplina_temp.json" "resources/professor_disciplina.json"
    else do
        putStr "\n"
        printStrLn "Usuário ou disciplina incorretos..."

leTrancamentos :: IO ([Trancamento])
leTrancamentos = do
    byteStrTrancamentos <- B.readFile "resources/trancamentos.json"
    let trancamentos = fromJust (decode byteStrTrancamentos :: Maybe [Trancamento])
    return (trancamentos)

salvaTrancamento :: Trancamento -> IO()
salvaTrancamento trancamento = do
    trancamentos <- leTrancamentos
    B.writeFile "resources/trancamentos_temp.json" (encode (trancamentos ++ [trancamento]))
    removeFile "resources/trancamentos.json"
    renameFile "resources/trancamentos_temp.json" "resources/trancamentos.json"

getDisciplina :: Int -> [Disciplina] ->  Disciplina
getDisciplina idBusca disciplinas =  head [disc | disc <- disciplinas, (Persistence.id disc) == idBusca]


verificaDisciplinaJaMatriculada :: Int -> [MetaDisciplina]-> Bool
verificaDisciplinaJaMatriculada idBusca listaDisciplinas = [] /= [disc | disc <- listaDisciplinas, (idMetaDisciplina disc) == idBusca] 
                     