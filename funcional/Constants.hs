module Constants
where

-- Constantes do sistema

{- 
   Para não causar problema no namespace do projeto,
   é melhor usarmos um padrão para os nomes das contantes, como:
   
   *c_nome_da_contante*

   Dessa forma, onde haver esse padrão saberemos que é uma constante
   e o nome delas não irá atrapalhar se tentarmos declarar uma função
   de mesmo nome.
-}

-- espaços na interface
c_espacos_padrao    = 20 :: Int
c_espacos_identados = 21 :: Int
c_espacos_centro    = 26 :: Int

-- estado do sistema
c_matricula      = 1 :: Int
c_em_curso       = 2 :: Int
c_fim_de_periodo = 3 :: Int

-- comandos principais
c_menu_inicial   = 0 :: Int
c_logar          = 1 :: Int
c_sair           = 2 :: Int
c_fechar_sistema = 3 :: Int

-- tipo de usuario
c_none        = 0 :: Int
c_aluno       = 1 :: Int
c_professor   = 2 :: Int
c_coordenador = 3 :: Int

-- comandos do coordenador
c_cadastra_aluno      = 1 :: Int
c_cadastra_professor  = 2 :: Int
c_analisa_trancamento = 3 :: Int
c_alocar_professor    = 4 :: Int
c_altera_estado       = 5 :: Int

-- comandos do aluno
c_fazer_matricula    = 1 :: Int
c_trancar_disciplina = 2 :: Int
c_trancar_curso      = 3 :: Int
c_ver_disciplina     = 4 :: Int
c_ver_historico      = 5 :: Int

-- comandos do professor
c_fazer_chamada     = 1 :: Int
c_fechar_disciplina = 2 :: Int
c_inserir_notas     = 3 :: Int