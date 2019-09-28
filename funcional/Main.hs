import Interface

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


main = do
    menu_inicial
    menu_login
    menu_aluno
    menu_professor
    menu_coordenador
    menu_altera_estado
    menu_cadastro_professor
    menu_cadastro_aluno
    menu_trancamento_curso