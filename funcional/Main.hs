import Interface
import Util
import Constants

{-

Funções a serem implementadas:

   esta_logado :: Bool

   -- Função para escolher qual menu ou ação será chamada apartir do menu inicial
   controlador_principal

   -- Função que valida o usuário que está tentando se logar
   autentica

   Comentário: temos que pensar em algum mecanismo de sessão para o usuário,
   já que haskell não suporta estados penso isso que vai ser guardado em um arquivo.

   -- Função para escolher qual menu ou ação será chamada apartir do menu de professor
   controlador_professor

   -- Função para escolher qual menu ou ação será chamada apartir do menu de aluno
   controlador_aluno

   -- Função para escolher qual menu ou ação será chamada apartir do menu de coordenador
   controlador_coordenador

   ...

-}

controlador_principal :: Int -> IO()
controlador_principal option
   | option == c_entrar         = printStr "Entrei"
   | option == c_sair           = printStr "Sai"
   | option == c_fechar_sistema = return ()
   | otherwise                  = printStr "Opção inválida"
   
main = do
   option <- menu_inicial

   controlador_principal option