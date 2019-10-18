module Services where

import Util
import Constants
import Persistence
import Data.Maybe
import Numeric 
import Interface

{- Funções utilitárias de login (comeco) -}

existe_sessao_ativa :: IO Bool
existe_sessao_ativa = do
   sessao <- leSessao
   return $ case sessao of
               Nothing -> False
               Just u -> True

{- Funções utilitárias de login (fim) -}

{- Funções utilitárias de controlador de aluno (começo) -}

imprimeDisciplinas :: [Disciplina] -> IO()
imprimeDisciplinas disciplinas = do 
    printStr "ID\tNOME\t\tLIMITE\tPREREQ1\tPREREQ2\n"
    imprimeDisciplinasAux  disciplinas

imprimeDisciplinasAux :: [Disciplina] -> IO()
imprimeDisciplinasAux [] = putStr "\n"
imprimeDisciplinasAux (head:tail) =  do   
    printStr ("" ++ show (Persistence.id head) ++ "\t" ++ 
                    nomeDisciplina head ++ "\t\t" ++ 
                    show (limite head) ++ "\t" ++ 
                    show (p_requisito head) ++ "\t" ++ 
                    show (s_requisito head) ++ "\n")
    imprimeDisciplinasAux tail 

imprimeMetaDisciplinas :: [MetaDisciplina] -> IO()
imprimeMetaDisciplinas metadisciplinas = do 
    printStr "ID\tNOME\n"
    imprimeMetaDisciplinasAux  metadisciplinas

imprimeMetaDisciplinasAux :: [MetaDisciplina] -> IO()
imprimeMetaDisciplinasAux [] = putStr "\n"
imprimeMetaDisciplinasAux (head:tail) =  do   
    printStr ("" ++ show (Persistence.idMetaDisciplina head) ++ "\t" ++ nomeMetaDisciplina head ++ "\n")
    imprimeMetaDisciplinasAux tail 


verDisciplina :: [MetaDisciplina] -> Int -> String
verDisciplina lista id
 | lista == [] = "Disciplina não cursada ou matriculada"
 | Persistence.idMetaDisciplina (head lista) == id = "ID\tNOME\tFALTAS\tNOTAS\t\tESTADO\n\t\t\t\t\t" ++ show (Persistence.idMetaDisciplina (head lista)) ++ "\t" ++ nomeMetaDisciplina (head lista) ++ "\t" ++ show (faltas (head lista)) ++ "\t" ++ show (notas (head lista)) ++ "\t" ++ estado (head lista) ++ "\n"
 | otherwise = verDisciplina (tail lista) id

verificaSituacao :: Double -> Int -> String ->  String
verificaSituacao media faltas estado
 | estado == "trancada" = "Trancada"
 | (media >= 7.0) && (faltas <= 7) = "Aprovado"
 | otherwise = "Reprovado"

verHistorico :: [MetaDisciplina] -> IO()
verHistorico lista
 | lista == [] = printStr "\n"
 | otherwise = do
      if(estado (head lista) == "em curso") then verHistorico (tail lista)
      else do
            printStr (show (Persistence.idMetaDisciplina (head lista)) ++ "\t" ++ 
                      nomeMetaDisciplina (head lista) ++ "\t" ++ 
                      (showFFloat (Just 1) media "") ++ "\t" ++ 
                      (verificaSituacao media (faltas (head lista)) (estado (head lista))) ++ 
                      "\n")
            verHistorico (tail lista)
 where media = ((sum (notas (head lista))) / 3)

{- Funções utilitárias de aluno (fim) -}

{- Funções utilitárias de controlador de professor (começo) -}

disciplinasEmProfessor :: [ProfessorDisciplina] -> String -> [Int]
disciplinasEmProfessor lista id
 | lista == [] = []
 | otherwise = do
    if(matriculaProfessor (head lista) == id) then 
        Persistence.disciplinasProfessor (head lista)
    else 
        disciplinasEmProfessor (tail lista) id

imprimeDisciplinasProfessor :: [Int] -> IO()
imprimeDisciplinasProfessor [] = printStr "\n"
imprimeDisciplinasProfessor (head:tail) = do 
    printStr (show(head) ++ "\n")
    imprimeDisciplinasProfessor tail

contains :: [MetaDisciplina] -> Int -> Bool
contains lista id = do
    if(lista == []) then False
    else do
        if ((idMetaDisciplina (head lista) == id) && ((estado (head lista)) == "em curso")) then True
        else (contains (tail lista) id)

listaDeAlunos :: [Aluno] -> Int -> [Aluno]
listaDeAlunos lista id = do
    if(lista == []) then  []
    else do
        let disciplinaQUERY = [d | d <- disciplinas (head lista), idMetaDisciplina d == id]
        if (contains (disciplinas (head lista)) id && estado (head disciplinaQUERY) /= "trancado" ) then
            return (head lista) ++ (listaDeAlunos (tail lista) id)
        else 
            listaDeAlunos (tail lista) id

adicionafalta :: [MetaDisciplina] -> Int -> [MetaDisciplina]
adicionafalta lista id = do
    if lista == [] then []
    else do
        if (idMetaDisciplina (head lista)) == id then do
            let newmetadisciplina = MetaDisciplina (idMetaDisciplina (head lista))  (nomeMetaDisciplina (head lista))  (1 + (faltas (head lista))) (notas (head lista)) (estado (head lista))
            return newmetadisciplina ++ (tail lista)
        else
            [(head lista)] ++ (adicionafalta (tail lista) id)

adicionaNota :: [MetaDisciplina] -> Int -> Int -> Double -> [MetaDisciplina]
adicionaNota lista id estagio nota = do
    if lista == [] then []
    else do
        if (idMetaDisciplina (head lista)) == id then do
            let newnotas =  mudaNota (notas (head lista)) (estagio-1) nota
            let newmetadisciplina = MetaDisciplina (idMetaDisciplina (head lista))  (nomeMetaDisciplina (head lista))  ((faltas (head lista))) (newnotas) (estado (head lista))
            return newmetadisciplina ++ (tail lista)
        else
            [(head lista)] ++ (adicionaNota (tail lista) id estagio nota)

mudaNota :: [Double] -> Int -> Double -> [Double]
mudaNota notas indice nota = do
    if indice == 0 then do
        return nota ++ (tail notas)
    else do
        return (head notas) ++ mudaNota (tail notas) (indice - 1) nota

fazerChamada :: [Aluno] -> Int -> IO()
fazerChamada lista id = do
    if lista == [] then printStr "Chamada concluida!"
    else do
        printStr ("Matricula: " ++ (matriculaAluno (head lista)) ++ 
                  "\tAluno: " ++ (nomeAluno (head lista)) ++ "\n")
        printStr prompt
        p_f <- readLn :: IO Int

        if p_f == 1 then 
            fazerChamada (tail lista) id
        else if p_f == 2 then do
            let newlista = adicionafalta (disciplinas (head lista)) id
            let newaluno = Aluno (matriculaAluno (head lista)) (nomeAluno (head lista)) (disciplinasMatriculadas (head lista)) (estaDesvinculado (head lista)) newlista
            atualizaAluno newaluno
            fazerChamada (tail lista) id
        else do
            printStr "Opção invalida: digite 1: para presente ou 2: para faltou\n"
            fazerChamada lista id

atribuirNotas :: [Aluno] -> Int -> Int -> IO()
atribuirNotas lista id estagio = do
    if lista == [] then 
        printStr "Atribuição de notas concluída\n"
    else do
        printStr ("Matricula: " ++ (matriculaAluno (head lista)) ++ "\tAluno: " ++ (nomeAluno (head lista)) ++ "\n")
        printStr prompt
        nota <- readLn :: IO Double
        if (nota > 10 || nota < 0) then do
            printStr("Nota inválida, por favor insira uma nota de 0 a 10\n")
            atribuirNotas lista id estagio
        else do
            let newlista = adicionaNota (disciplinas (head lista)) id estagio nota
            let newaluno = Aluno (matriculaAluno (head lista)) (nomeAluno (head lista)) (disciplinasMatriculadas (head lista)) (estaDesvinculado (head lista)) newlista
            atualizaAluno newaluno
            atribuirNotas (tail lista) id estagio
      
fechaDisciplina:: [MetaDisciplina] -> Int -> [MetaDisciplina]
fechaDisciplina lista id = do
    if lista == [] then []
    else do
    if (idMetaDisciplina (head lista)) == id then do
        let newmetadisciplina = MetaDisciplina (idMetaDisciplina (head lista))  (nomeMetaDisciplina (head lista))  (faltas (head lista)) (notas (head lista)) "fechada"
        return newmetadisciplina ++ (tail lista)
    else
        [(head lista)] ++ (fechaDisciplina (tail lista) id)

fecharDisciplina :: [Aluno] -> Int -> IO()
fecharDisciplina lista id = do
    if lista == [] then 
        printStr "Fechamento concluido!"
    else do
        let newlista = fechaDisciplina (disciplinas (head lista)) id
        let newaluno = Aluno (matriculaAluno (head lista)) (nomeAluno (head lista)) (disciplinasMatriculadas (head lista)) (estaDesvinculado (head lista)) newlista
        atualizaAluno newaluno
        fecharDisciplina (tail lista) id

{- Funções utilitárias de controlador de professor (fim) -}

{- Funções utilitárias de coordenador (comeco) -}

analisaTrancamento :: Trancamento -> [Trancamento] -> IO ()
analisaTrancamento tranc trancamentos = do
    alunoVeri <- leAluno (matrTrancamento tranc)

    let alunoValido = case alunoVeri of
                        Nothing -> False
                        Just u -> True

    if alunoValido then do
        let aluno = fromJust alunoVeri
        if (tag tranc) == "TrancamentoCurso" then do
            let newaluno = Aluno (matriculaAluno aluno) (nomeAluno aluno) (disciplinasMatriculadas aluno) True (disciplinas aluno)
            atualizaAluno newaluno
        else do 
            let disc = disciplinas aluno
            let metadisciplina = getMetaDisciplina (idDisciplinaTrancamento tranc) disc
            let newmetadisciplina = MetaDisciplina (idMetaDisciplina metadisciplina)  (nomeMetaDisciplina metadisciplina)  (faltas metadisciplina) (notas metadisciplina) "trancada"
            let newlista = ((removeMetaDisciplina metadisciplina disc) ++ [newmetadisciplina])
            let newaluno = Aluno (matriculaAluno aluno) (nomeAluno aluno) (disciplinasMatriculadas aluno) (estaDesvinculado aluno) newlista
            atualizaAluno newaluno
    else do
        putStr "Aluno não existe!"

    return ()

getTrancamento ::Int -> Int -> [Trancamento] -> Trancamento
getTrancamento cont index (h:t) 
 | cont == index = h
 | otherwise = getTrancamento (cont + 1) index t

{- Funções utilitárias de coordenador (fim) -}