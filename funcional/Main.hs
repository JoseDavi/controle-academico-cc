import Interface
import Util
import Constants
import Persistence

sleep :: IO()
sleep = getLine >>= putStrLn

controlador_principal :: Int -> IO()
controlador_principal option = do
   if option /= c_fechar_sistema then do
      if option == c_entrar then 
         controlador_login
      else if option == c_sair then do
         sair_sistema      
      else
         printStr "Opção inválida!"

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
   
   -- Todos os usuário registrados até o momento
   usuariosBD <- leUsuarios
   
   -- Todos os usuário registrados até o momento
   alunosBD <- leAlunos

   -- Realiza uma pesquisa sobre os usuários existentes
   let usuarioQUERY = [u | u <- usuariosBD, 
                           matricula u == (fst usuarioInterface),
                           senha u == (snd usuarioInterface)]

   let loginValido = length usuarioQUERY /= 0
   
   if loginValido then do

      let usuarioTemp = (usuarioQUERY !! 0)
      -- Salva uma sessão com as informações do usuário logado
      salvaSessao usuarioTemp 
      if tipoUsuario usuarioTemp == "aluno" then do
         option <- menu_aluno
         let alunoQUERY = [aluno | aluno <- alunosBD, 
                           matriculaAluno aluno == (fst usuarioInterface)]
         controlador_aluno (head alunoQUERY) option
      else if tipoUsuario usuarioTemp == "coordenador" then do
         option <- menu_coordenador
         controlador_coordenador option
      else
         printStr "Tipo não definido de usuário"
   else
      printStrLn "Login inválido!"


imprimeDisciplinas :: [Disciplina] -> IO()
imprimeDisciplinas [] = putStr "\n"
imprimeDisciplinas (head:tail) =  do printStr ("" ++ show (Persistence.id head) ++ "\t" ++ nomeDisciplina head ++ "\t\t" ++ show (limite head) ++ "\t" ++ show (p_requisito head) ++ "\t" ++ show (s_requisito head) ++ "\n")
                                     imprimeDisciplinas tail 

verDisciplina :: [MetaDisciplina] -> Int -> String
verDisciplina lista id
 |lista == [] = "Disciplina não cadastrada"
 |Persistence.id (head lista) == id = show (Persistence.id (head lista)) ++ "\t" ++ nomeDisciplina (head lista) ++ "\t" ++ show (limite (head lista)) ++ "\t" ++ show (p_requisito (head lista)) ++ "\t" ++ show (s_requisito (head lista)) ++ "\n"
 |otherwise = verDisciplina (tail lista) id

controlador_aluno :: Aluno -> Int -> IO()
controlador_aluno aluno option = do
   if option /= c_a_voltar then do
      if option == c_fazer_matricula then do
         disciplinas <- leDisciplinas  
         printStr "ID\tNOME\t\tLIMITE\tPREREQ1\tPREREQ2\n"
         imprimeDisciplinas disciplinas
         idEscolhido <- readLn :: IO Int
         let disciplina = getDisciplina idEscolhido disciplinas
         print disciplina
         print aluno
         --let newmetadisciplina = MetaDisciplina (show (Persistence.id disciplina))  (nomeDisciplina disciplina)  0 [0,0,0] "em curso"   
         --let newlista = metadisciplinas ++ [newmetadisciplina]


         --print newmetadisciplina



      else if option == c_trancar_disciplina then
         printStrLn "Trancar disciplina"
      else if option == c_trancar_curso then
         printStrLn "Trancar curso"
      else if option == c_ver_disciplina then
            printStrLn "Ver disciplina"
            disciplinas <- disciplinas aluno
            id_disciplina <- readLn :: IO Int
            printStrLn(verDisciplina disciplinas id_disciplina)
            sleep
      else
         printStrLn "Ver histórico"

      -- Reinicia o ciclo
      option <- menu_aluno
      controlador_aluno aluno option
   else
      return ()

      controlador_professor :: Int -> IO()
      controlador_professor option = do
            if option /= c_p_voltar then do
                  if option == c_fazer_chamada then
                     printStrLn "Fazer Chamada"
                  else if option == c_fechar_disciplina then
                     printStrLn "Fechar Disciplina"
                  else if option == c_inserir_notas then
                     printStrLn "Inserir Notas"       
                  else
                     printStrLn "Comando inválido"
            
                  -- Reinicia o ciclo
                  option <- menu_professor
                  controlador_professor option
            else
                  return ()

controlador_coordenador :: Int -> IO()
controlador_coordenador option = do
   if option /= c_a_voltar then do
      if option == c_cadastra_aluno then
         printStrLn "Cadastrar Aluno"
      else if option == c_cadastra_professor then
         printStrLn "Cadastrar professor"
      else if option == c_analisa_trancamento then
         printStrLn "Analisar trancamento"
      else if option == c_alocar_professor then
         printStrLn "Alocar professor"
      else if option == c_altera_estado then
         printStrLn "Alterar estado"       
      else
         printStrLn "Comando inválido"

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