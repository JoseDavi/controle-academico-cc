import Interface
import Util
import Constants

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
   info_usuario <- menu_login
   printStr "Loguei"

   -- Procurar por usuário
   -- Manter uma sessão
   -- Chamar o controlador do tipo do usuário

   option <- menu_aluno
   controlador_aluno option

controlador_aluno :: Int -> IO()
controlador_aluno option = do
   if option /= c_a_voltar then do
      if option == c_fazer_matricula then
         printStrLn "Fazer matrícula"
      else if option == c_trancar_disciplina then
         printStrLn "Trancar curso"
      else if option == c_trancar_curso then
         printStrLn "Trancar curso"
      else if option == c_ver_disciplina then
         printStrLn "Ver disciplina"
      else
         printStrLn "Ver histórico"

      -- Reinicia o ciclo
      option <- menu_aluno
      controlador_aluno option
   else
      return ()

controlador_professor :: IO()
controlador_professor = do
   return ()

controlador_coordenador :: IO()
controlador_coordenador = do
   return ()

sair_sistema :: IO()
sair_sistema = do
   printStr ("Sai da conta...")
   espere
   return ()
            
main = do
   option <- menu_inicial
   controlador_principal option