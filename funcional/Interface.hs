module Interface where

import Util

-- Limpa a tela adicionando cem quebras de linha no terminal
limpar_tela :: IO()
limpar_tela = do
    putStr (repeteCaractere "\n" 100)

-- Define o cabeçalho padrão do sistema
header :: String
header =  (repeteCaractere " " n_spaces) ++ "╔═╗┌─┐┌┐┌┌┬┐┬─┐┌─┐┬  ┌─┐  ╔═╗┌─┐┌─┐┌┬┐┌─┐┌┬┐┬┌─┐┌─┐  ╔═╗╔═╗\n"  ++
          (repeteCaractere " " n_spaces) ++ "║  │ ││││ │ ├┬┘│ ││  ├┤   ╠═╣│  ├─┤ ││├┤ │││││  │ │  ║  ║  \n"  ++  
          (repeteCaractere " " n_spaces) ++ "╚═╝└─┘┘└┘ ┴ ┴└─└─┘┴─┘└─┘  ╩ ╩└─┘┴ ┴─┴┘└─┘┴ ┴┴└─┘└─┘  ╚═╝╚═╝\n\n"

-- Define o rodapé padrão do sistema
footer :: String
footer =  (repeteCaractere " " n_spaces) ++ "-----------------------------------------------------------\n"

-- Define a messagem de login
login :: String 
login = (repeteCaractere " " n_spaces) ++ "╦  ╔═╗╔═╗╦╔╗╔\n" ++
        (repeteCaractere " " n_spaces) ++ "║  ║ ║║ ╦║║║║\n" ++
        (repeteCaractere " " n_spaces) ++ "╩═╝╚═╝╚═╝╩╝╚╝\n"

prompt :: String
prompt = (repeteCaractere " " n_spaces) ++ "> "


{-
    Menus principais do sistema
-}

menu_inicial :: IO Int
menu_inicial = do
    limpar_tela
    
    putStr header
    printStr "1) Entrar         "
    printStr "2) Sair           "
    printStr "3) Fechar sistema "
    putStr footer
    putStr prompt

    option <- readLn :: IO Int
    return option

menu_login :: IO (String, String)
menu_login = do
    limpar_tela
    putStr $ login ++ (repeteCaractere "\n" 2)

    putStr $ (repeteCaractere " " n_spaces) ++ "Nome: "
    nome <- getLine

    putStr $ (repeteCaractere " " n_spaces) ++ "Senha: "
    senha <- getSenha
    
    return (nome, senha)

menu_aluno :: IO Int
menu_aluno = do 
    limpar_tela
    
    putStr   header
    printStr "aluno...              "
    printStr "1) Fazer Matrícula    "
    printStr "2) Trancar Disciplina "
    printStr "3) Trancar Curso      "  
    printStr "4) Ver Disciplina     " 
    printStr "5) Ver Histórico      " 
    printStr "6) Voltar...          " 
    putStr   footer                     
    putStr   prompt

    option <- readLn :: IO Int
    return option

menu_professor :: IO Int
menu_professor = do
    limpar_tela

    putStr   header
    printStr "professor...          "
    printStr "1) Fazer Chamada      "
    printStr "2) Fechar Disciplina  "
    printStr "3) Inserir Notas      "
    printStr "4) Voltar...          "
    putStr   footer                     
    putStr   prompt

    option <- readLn :: IO Int
    return option

menu_coordenador :: IO Int
menu_coordenador = do
    limpar_tela

    putStr   header       
    printStr "coordenador...                   "
    printStr "1) Cadastrar Aluno               "   
    printStr "2) Cadastrar Professor           "   
    printStr "3) Analisar Trancamenos          "  
    printStr "4) Alocar professor a Disciplina "   
    printStr "5) Modificar estado do sistema   "  
    printStr "6) Voltar...                     "   
    putStr   footer                                  
    putStr   prompt

    option <- readLn :: IO Int
    return option

{-
    Menus auxiliares
-}

menu_altera_estado :: IO Int
menu_altera_estado = do
    limpar_tela

    putStr   header       
    printStr "Selecione o estado do sistema:    ";
    printStr "1) Semana de matrículas.          ";
    printStr "2) Período em curso.              ";
    printStr "3) Final de período               ";
    printStr "4) Voltar ao menu do Coordenador. ";   
    putStr   footer                                  
    putStr   prompt

    option <- readLn :: IO Int
    return option