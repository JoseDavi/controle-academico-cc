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

controlador_aluno :: Aluno -> Int -> IO()
controlador_aluno aluno option = do
   if option /= c_a_voltar then do
      if option == c_fazer_matricula then do
         disciplinas <- leDisciplinas  
         imprimeDisciplinas disciplinas
         printStr prompt
         idEscolhido <- readLn :: IO Int

         let disciplinaJaMatriculada = verificaDisciplinaJaMatriculada idEscolhido (Persistence.disciplinas aluno)

         if disciplinaJaMatriculada || (disciplinasMatriculadas aluno) >= 6 then do
            
            if disciplinaJaMatriculada then do
               printStr "Disciplina já foi matriculada"
            else do
               printStr "O limite de disciplinas(6) já foi atingido"
            
            espere
            -- Reinicia o ciclo
            option <- menu_aluno
            controlador_aluno aluno option
         else do
            let disciplina = getDisciplina idEscolhido disciplinas
            let newmetadisciplina = MetaDisciplina (Persistence.id disciplina)  (nomeDisciplina disciplina)  0 [0,0,0] "em curso"   
            let newlista = [newmetadisciplina] ++ (Persistence.disciplinas aluno)
            let newaluno = Aluno (matriculaAluno aluno) (nomeAluno aluno) (1 + disciplinasMatriculadas aluno) (estaDesvinculado aluno) newlista
            atualizaAluno newaluno

            -- Reinicia o ciclo
            option <- menu_aluno
            controlador_aluno newaluno option

         else if option == c_trancar_disciplina then do
            printStrLn "Trancar disciplina"
            espere
            
            -- Reinicia o ciclo
            option <- menu_aluno
            controlador_aluno aluno option
      else if option == c_trancar_curso then do
         printStrLn "Trancar curso"
         espere

         -- Reinicia o ciclo
         option <- menu_aluno
         controlador_aluno aluno option
      else if option == c_ver_disciplina then do
         printStrLn "Ver disciplina: "
         printStr prompt
         id_disciplina <- readLn :: IO Int
         printStrLn(verDisciplina (disciplinas aluno) id_disciplina)
         espere

         -- Reinicia o ciclo
         option <- menu_aluno
         controlador_aluno aluno option
      else if option == c_ver_historico then do
         printStrLn "Ver histórico"
         printStr "ID\tNOME\tFALTAS\tNOTAS\t\tESTADO\n"
         verHistorico (disciplinas aluno)
         espere

         -- Reinicia o ciclo
         option <- menu_aluno
         controlador_aluno aluno option
      else do
         printStr "Opção Invalida"
         espere

         -- Reinicia o ciclo
         option <- menu_aluno
         controlador_aluno aluno option

   else
      return ()

controlador_professor :: Int -> IO()
controlador_professor option = do
      if option /= c_p_voltar then do
            if option == c_fazer_chamada then do
               printStrLn "Fazer Chamada"
               espere
            else if option == c_fechar_disciplina then do
               printStrLn "Fechar Disciplina"
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
         printStrLn "Analisar trancamento"
         espere
      else if option == c_alocar_professor then do
         printStrLn "Alocar professor"
         espere
      else if option == c_altera_estado then do
         printStrLn "Alterar estado"
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