import Interface
import Util
import Constants
import Persistence
import Data.Maybe

sleep :: IO()
sleep = getLine >>= putStrLn

controlador_principal :: Int -> IO()
controlador_principal option = do
   if option /= c_fechar_sistema then do
      if option == c_entrar then 
         controlador_login
      else if option == c_sair then do
         sair_sistema      
      else do
         printStr "Opção inválida!"
         sleep

      -- Reinicia o ciclo
      option <- menu_inicial
      controlador_principal option

   else do
      printStrLn "Fechando sistema..."
      return ()

controlador_login :: IO()
controlador_login = do
   -- Usuário informado pela interface
   usuarioInterface <- menu_login
   
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
         sleep
   else do
      printStrLn "Login inválido!"
      sleep


imprimeDisciplinas :: [Disciplina] -> IO()
imprimeDisciplinas [] = putStr "\n"
imprimeDisciplinas (head:tail) =  do printStr ("" ++ show (Persistence.id head) ++ "\t" ++ nomeDisciplina head ++ "\t\t" ++ show (limite head) ++ "\t" ++ show (p_requisito head) ++ "\t" ++ show (s_requisito head) ++ "\n")
                                     imprimeDisciplinas tail 

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
         printStr "ID\tNOME\t\tLIMITE\tPREREQ1\tPREREQ2\n"
         imprimeDisciplinas disciplinas
         printStr prompt
         idEscolhido <- readLn :: IO Int
         let disciplina = getDisciplina idEscolhido disciplinas
         print disciplina
         print aluno
         sleep
         --let newmetadisciplina = MetaDisciplina (show (Persistence.id disciplina))  (nomeDisciplina disciplina)  0 [0,0,0] "em curso"   
         --let newlista = metadisciplinas ++ [newmetadisciplina]


         --print newmetadisciplina



      else if option == c_trancar_disciplina then do
         printStrLn "Trancar disciplina"
         sleep
      else if option == c_trancar_curso then do
         printStrLn "Trancar curso"
         sleep
      else if option == c_ver_disciplina then do
            printStrLn "Ver disciplina: "
            printStr prompt
            id_disciplina <- readLn :: IO Int
            printStrLn(verDisciplina (disciplinas aluno) id_disciplina)
            sleep
      else if option == c_ver_historico then do
            printStrLn "Ver histórico"
            printStr "ID\tNOME\tFALTAS\tNOTAS\t\tESTADO\n"
            verHistorico (disciplinas aluno)
            sleep
      else do
            printStr "Opção Invalida"
            sleep

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
               sleep
            else if option == c_fechar_disciplina then do
               printStrLn "Fechar Disciplina"
               sleep
            else if option == c_inserir_notas then do
                  printStrLn "Inserir Notas"
                  sleep 
            else do
                  printStrLn "Comando inválido"
                  sleep
            
            -- Reinicia o ciclo
            option <- menu_professor
            controlador_professor option
      else
            return ()

controlador_coordenador :: Int -> IO()
controlador_coordenador option = do
   if option /= c_a_voltar then do
      if option == c_cadastra_aluno then do
         printStrLn "Cadastrar Aluno"
         sleep
      else if option == c_cadastra_professor then do
         printStrLn "Cadastrar professor"
         sleep
      else if option == c_analisa_trancamento then do
         printStrLn "Analisar trancamento"
         sleep
      else if option == c_alocar_professor then do
         printStrLn "Alocar professor"
         sleep
      else if option == c_altera_estado then do
         printStrLn "Alterar estado"
         sleep
      else do
         printStrLn "Comando inválido"
         sleep

      -- Reinicia o ciclo
      option <- menu_coordenador
      controlador_coordenador option
   else
      return ()

sair_sistema :: IO()
sair_sistema = do
   printStr ("Sai da conta...")
   espere
   return ()
            
main = do
   option <- menu_inicial
   controlador_principal option