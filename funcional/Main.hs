import Interface
import Util
import Constants
import Persistence
import Data.Maybe

controlador_principal :: Int -> IO()
controlador_principal option = do
   if option /= c_fechar_sistema then do
      if option == c_entrar then 
         controlador_login
      else if option == c_sair then do
         sair_sistema      
      else do
         printStr "Opção inválida!"
         espere

      -- Reinicia o ciclo
      option <- menu_inicial
      controlador_principal option

   else do
      printStrLn "Fechando sistema..."
      return ()

controlador_login :: IO()
controlador_login = do

   -- Verifica se o usuário da sessão está disponível
   existeSessao <- existe_sessao_ativa
   usuarioInterface <- case existeSessao of
                           False -> do
                              temp <- menu_login
                              return (temp)
                           True -> do
                              sessao <- leSessao
                              let usuario = fromJust sessao
                              let temp = (matricula usuario, senha usuario)
                              return (temp)

   -- Usuário identificado no banco
   usuarioBD <- leUsuario (fst usuarioInterface)

   let loginValido = case usuarioBD of
                           Nothing -> False
                           Just u -> True
   
   if loginValido then do
      -- Usuário logado no sistema
      let usuarioLogado = fromJust usuarioBD

      -- Salva uma sessão com as informações do usuário logado
      salvaSessao usuarioLogado
      
      let tipoLogin = tipoUsuario usuarioLogado

      if tipoLogin == "aluno" then do
         option <- menu_aluno
         alunoBD <- leAluno (fst usuarioInterface)
         controlador_aluno (fromJust alunoBD) option
      else if tipoLogin == "coordenador" then do
         option <- menu_coordenador
         controlador_coordenador option
      else if tipoLogin == "professor" then do
         option <- menu_professor
         controlador_professor option
      else do
         printStr "Tipo não definido de usuário"
         espere
   else do
      printStrLn "Login inválido!"
      espere



imprimeDisciplinas :: [Disciplina] -> IO()
imprimeDisciplinas disciplinas = do printStr "ID\tNOME\t\tLIMITE\tPREREQ1\tPREREQ2\n"
                                    imprimeDisciplinasAux  disciplinas

imprimeDisciplinasAux :: [Disciplina] -> IO()
imprimeDisciplinasAux [] = putStr "\n"
imprimeDisciplinasAux (head:tail) =  do   printStr ("" ++ show (Persistence.id head) ++ "\t" ++ nomeDisciplina head ++ "\t\t" ++ show (limite head) ++ "\t" ++ show (p_requisito head) ++ "\t" ++ show (s_requisito head) ++ "\n")
                                          imprimeDisciplinasAux tail 

imprimeMetaDisciplinas :: [MetaDisciplina] -> IO()
imprimeMetaDisciplinas metadisciplinas = do printStr "ID\tNOME\n"
                                            imprimeMetaDisciplinasAux  metadisciplinas

imprimeMetaDisciplinasAux :: [MetaDisciplina] -> IO()
imprimeMetaDisciplinasAux [] = putStr "\n"
imprimeMetaDisciplinasAux (head:tail) =  do   printStr ("" ++ show (Persistence.idMetaDisciplina head) ++ "\t" ++ nomeMetaDisciplina head ++ "\n")
                                              imprimeMetaDisciplinasAux tail 



verDisciplina :: [MetaDisciplina] -> Int -> String
verDisciplina lista id
 |lista == [] = "Disciplina não cursada ou matriculada"
 |Persistence.idMetaDisciplina (head lista) == id = "ID\tNOME\tFALTAS\tNOTAS\t\tESTADO\n\t\t\t\t\t" ++ show (Persistence.idMetaDisciplina (head lista)) ++ "\t" ++ nomeMetaDisciplina (head lista) ++ "\t" ++ show (faltas (head lista)) ++ "\t" ++ show (notas (head lista)) ++ "\t" ++ estado (head lista) ++ "\n"
 |otherwise = verDisciplina (tail lista) id

verHistorico :: [MetaDisciplina] -> IO()
verHistorico lista
 |lista == [] = printStr "\n"
 |otherwise = do
      printStr (show (Persistence.idMetaDisciplina (head lista)) ++ "\t" ++ nomeMetaDisciplina (head lista) ++ "\t" ++ show (faltas (head lista)) ++ "\t" ++ show (notas (head lista)) ++ "\t" ++ estado (head lista) ++ "\n")
      verHistorico (tail lista)

reiniciaCicloAluno :: Aluno -> IO()
reiniciaCicloAluno aluno = do
            option <- menu_aluno
            controlador_aluno aluno option

controlador_aluno :: Aluno -> Int -> IO()
controlador_aluno aluno option = do
   if option /= c_a_voltar then do
      if option == c_fazer_matricula then do

         

      
      
         disciplinas <- leDisciplinas  
         imprimeDisciplinas disciplinas
         printStr prompt
         idEscolhido <- getLineInt

         if idEscolhido > 131 || idEscolhido < 101 then do
            printStrLn "Disciplina inválida."
            espere
            reiniciaCicloAluno aluno
         else do
            let disciplinaJaMatriculada = verificaDisciplinaJaMatriculada idEscolhido (Persistence.disciplinas aluno)

            let disciplina = getDisciplina idEscolhido disciplinas
            let prereq1 = p_requisito disciplina
            let prereq2 = s_requisito disciplina
            let dispensaP1 = (prereq1 == 0) || (verificaDisciplinaJaMatriculada prereq1 (Persistence.disciplinas aluno))
            let dispensaP2 = (prereq2 == 0) || (verificaDisciplinaJaMatriculada prereq2 (Persistence.disciplinas aluno))

            if disciplinaJaMatriculada || (disciplinasMatriculadas aluno) >= 6 || not dispensaP1 || not dispensaP2 then do
               
               if disciplinaJaMatriculada then do
                  printStr "Disciplina já foi matriculada"
               else do

                  if (disciplinasMatriculadas aluno) >= 6 then do
                     printStr "O limite de disciplinas(6) já foi atingido"
                  else do
                     printStr "Faltam prerequisitos"
                     
               espere
               reiniciaCicloAluno aluno

            else do
               let disciplina = getDisciplina idEscolhido disciplinas
               let newmetadisciplina = MetaDisciplina (Persistence.id disciplina)  (nomeDisciplina disciplina)  0 [0,0,0] "em curso"   
               let newlista = [newmetadisciplina] ++ (Persistence.disciplinas aluno)
               let newaluno = Aluno (matriculaAluno aluno) (nomeAluno aluno) (1 + disciplinasMatriculadas aluno) (estaDesvinculado aluno) newlista
               atualizaAluno newaluno
               reiniciaCicloAluno newaluno

         else if option == c_trancar_disciplina then do
            if (disciplinasMatriculadas aluno) > 4 then do
               imprimeMetaDisciplinas (disciplinas aluno)
               opcao <- menu_trancamento_disc
               let newTrancamento = TrancamentoDisciplina "TrancamentoDisciplina" (matriculaAluno aluno) opcao
               salvaTrancamento newTrancamento
            else do
               printStr "É necessário estar matriculado em mais de 4 disciplinas para solicitar o trancamento\n"

            espere
            reiniciaCicloAluno aluno

         else if option == c_trancar_curso then do
            opcao <- menu_trancamento_curso 
            if opcao == "s" then do
               let newTrancamento = TrancamentoCurso "TrancamentoCurso" (matriculaAluno aluno)
               salvaTrancamento newTrancamento
            else do
               menu_desiste_trancamento
               
            espere
            reiniciaCicloAluno aluno

         else if option == c_ver_disciplina then do
            printStrLn "Ver disciplina: "
            printStr prompt
            id_disciplina <- getLineInt
            print id_disciplina
            printStrLn(verDisciplina (disciplinas aluno) id_disciplina)
            espere
            reiniciaCicloAluno aluno

         else if option == c_ver_historico then do
            printStrLn "Ver histórico"
            printStr "ID\tNOME\tFALTAS\tNOTAS\t\tESTADO\n"
            verHistorico (disciplinas aluno)
            espere
            reiniciaCicloAluno aluno

         else do
            printStr "Opção Invalida"
            espere
            reiniciaCicloAluno aluno

   else
      return ()

disciplinasEmProfessor :: [ProfessorDisciplina] -> String -> [Int]
disciplinasEmProfessor lista id
 |lista == [] = []
 |otherwise = do
                  if(matriculaProfessor (head lista) == id) then Persistence.disciplinasProfessor (head lista)
                  else disciplinasEmProfessor (tail lista) id

imprimeDisciplinasProfessor :: [Int] -> IO()
imprimeDisciplinasProfessor [] = printStr "\n"
imprimeDisciplinasProfessor (head:tail) = do printStr(show(head) ++ "\n")
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
      else listaDeAlunos (tail lista) id

adicionafalta :: [MetaDisciplina] -> Int -> [MetaDisciplina]
adicionafalta lista id = do
   if lista == [] then []
   else do
      if (idMetaDisciplina (head lista)) == id then do
         let newmetadisciplina = MetaDisciplina (idMetaDisciplina (head lista))  (nomeMetaDisciplina (head lista))  (1 + (faltas (head lista))) (notas (head lista)) (estado (head lista))
         return newmetadisciplina ++ (tail lista)
      else
         [(head lista)] ++ (adicionafalta (tail lista) id)

fazerChamada :: [Aluno] -> Int -> IO()
fazerChamada lista id = do
   if lista == [] then printStr "Chamada concluida!"
   else do
      printStr ("Matricula: " ++ (matriculaAluno (head lista)) ++ "\tAluno: " ++ (nomeAluno (head lista)) ++ "\n")
      printStr prompt
      p_f <- readLn :: IO Int
      if p_f == 1 then fazerChamada (tail lista) id
      else if p_f == 2 then do
         let newlista = adicionafalta (disciplinas (head lista)) id
         let newaluno = Aluno (matriculaAluno (head lista)) (nomeAluno (head lista)) (disciplinasMatriculadas (head lista)) (estaDesvinculado (head lista)) newlista
         atualizaAluno newaluno
         fazerChamada (tail lista) id
         else do
         printStr "Opção invalida: digite 1: para presente ou 2: para faltou\n"
         fazerChamada lista id

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
   if lista == [] then printStr "Fechamento concluido!"
   else do
      let newlista = fechaDisciplina (disciplinas (head lista)) id
      let newaluno = Aluno (matriculaAluno (head lista)) (nomeAluno (head lista)) (disciplinasMatriculadas (head lista)) (estaDesvinculado (head lista)) newlista
      atualizaAluno newaluno
      fecharDisciplina (tail lista) id

controlador_professor :: Int -> IO()
controlador_professor option = do
      if option /= c_p_voltar then do
            if option == c_fazer_chamada then do
               limpar_tela
               professorDisciplina <- leProfessorDisciplinas
               sessao <- leSessao
               let disciplinas = disciplinasEmProfessor professorDisciplina (matricula (fromJust sessao))
               if disciplinas == [] then
                  printStr "Professor não alocado para nenhuma disciplina"
               else do
                  printStr "Disciplinas disponiveis.\n"
                  imprimeDisciplinasProfessor disciplinas
                  printStr prompt
                  disciplina <- readLn :: IO Int
                  if (elem disciplina disciplinas) then do
                     alunosNoSistema <- leAlunos
                     let alunos = listaDeAlunos alunosNoSistema disciplina
                     printStr "1: para presente ou 2: para faltou\n"
                     fazerChamada alunos disciplina
                  else do
                     limpar_tela
                     printStr "Disciplina não está na lista"
                     espere
                     controlador_professor c_fazer_chamada
               espere
            else if option == c_fechar_disciplina then do
               limpar_tela
               professorDisciplina <- leProfessorDisciplinas
               sessao <- leSessao
               let disciplinas = disciplinasEmProfessor professorDisciplina (matricula (fromJust sessao))
               if disciplinas == [] then
                  printStr "Professor não alocado para nenhuma disciplina"
               else do
                  printStr "Disciplinas disponiveis.\n"
                  imprimeDisciplinasProfessor disciplinas
                  printStr prompt
                  disciplina <- readLn :: IO Int
                  if (elem disciplina disciplinas) then do
                     alunosNoSistema <- leAlunos
                     let alunos = listaDeAlunos alunosNoSistema disciplina
                     fecharDisciplina alunos disciplina
                  else do
                     limpar_tela
                     printStr "Disciplina não está na lista"
                     espere
                     controlador_professor c_fechar_disciplina
               espere
            else if option == c_inserir_notas then do
                  printStrLn "Inserir Notas"
                  espere 
            else do
                  printStrLn "Comando inválido"
                  espere
            
            -- Reinicia o ciclo
            option <- menu_professor
            controlador_professor option
      else
            return ()

controlador_coordenador :: Int -> IO()
controlador_coordenador option = do
   if option /= c_a_voltar then do
      if option == c_cadastra_aluno then do
         -- aluno em formato (matricula, nome, senha)
         aluno_temp <- menu_cadastro_aluno
         let aluno = Aluno (triple_fst aluno_temp) (triple_snd aluno_temp) 0 False []
         let usuario = Usuario (triple_fst aluno_temp) (triple_thd aluno_temp) "aluno" (triple_snd aluno_temp)
         salvaAluno aluno
         salvaUsuario usuario
         espere
      else if option == c_cadastra_professor then do
         -- professor em formato (matricula, nome, senha)
         professor_temp <- menu_cadastro_professor
         let usuario = Usuario (triple_fst professor_temp) (triple_thd professor_temp) "professor" (triple_snd professor_temp)
         salvaUsuario usuario
         espere
      else if option == c_analisa_trancamento then do
         trancamentos <- leTrancamentos
         solic <- menu_analisa_trancamento (trancamentos_para_string trancamentos 1)
         if(solic > length(trancamentos)) then do 
            printStr "Opção inválida"
            espere
         else do
            opcao <- menu_decide_tranc
            let tranc = getTrancamento 1 solic trancamentos
            if opcao == 1 then do
                  analisaTrancamento tranc trancamentos
            else do
                  printStr "A solicitação será excluída..."
            let newTrancamentos = removeTrancamento tranc trancamentos
            salvaTrancamentos newTrancamentos
         
            espere
      else if option == c_alocar_professor then do
         professor_disciplina_temp <- menu_aloca_professor
         alocaProfessor professor_disciplina_temp
         espere
      else if option == c_altera_estado then do
         -- pede o novo estado para o usuário e altera o do sistema
         estado_int <- menu_altera_estado
         let estado = Estado estado_int
         salvaEstado estado
         espere
      else do
         printStrLn "Comando inválido"
         espere

      -- Reinicia o ciclo
      option <- menu_coordenador
      controlador_coordenador option
   else
      return ()

sair_sistema :: IO()
sair_sistema = do
   existeSessao <- existe_sessao_ativa
   if (existeSessao == False) then
      printStr "Não existe usuário logado no momento!"
   else do
      limpaSessao
      printStr ("Você saiu com sucesso...")
   espere
   return ()

existe_sessao_ativa :: IO Bool
existe_sessao_ativa = do
   sessao <- leSessao
   return $ case sessao of
               Nothing -> False
               Just u -> True

main = do
   option <- menu_inicial
   controlador_principal option


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
getTrancamento cont index (h:t) | cont == index = h
                                | otherwise = getTrancamento (cont + 1) index t

