module Interface where

import Util
import Constants

-- Define o cabeçalho padrão do sistema
header :: String
header = do
    adiciona_espacos c_espacos_padrao $
        "\n╔═╗┌─┐┌┐┌┌┬┐┬─┐┌─┐┬  ┌─┐  ╔═╗┌─┐┌─┐┌┬┐┌─┐┌┬┐┬┌─┐┌─┐  ╔═╗╔═╗\n"  ++
          "║  │ ││││ │ ├┬┘│ ││  ├┤   ╠═╣│  ├─┤ ││├┤ │││││  │ │  ║  ║  \n"  ++  
          "╚═╝└─┘┘└┘ ┴ ┴└─└─┘┴─┘└─┘  ╩ ╩└─┘┴ ┴─┴┘└─┘┴ ┴┴└─┘└─┘  ╚═╝╚═╝\n\n"

-- Define o rodapé padrão do sistema
footer :: String
footer = do
    adiciona_espacos c_espacos_padrao "\n-----------------------------------------------------------\n"

prompt :: String
prompt = "> "

-- Define o cabeçalho de login
login :: String 
login = do
    adiciona_espacos c_espacos_centro $ 
        "\n╦  ╔═╗╔═╗╦╔╗╔\n" ++
          "║  ║ ║║ ╦║║║║\n" ++
          "╩═╝╚═╝╚═╝╩╝╚╝"

trancar_curso_mensagem :: String 
trancar_curso_mensagem = do
    adiciona_espacos c_espacos_padrao $
        "\n╔╦╗┬─┐┌─┐┌┐┌┌─┐┌─┐┬─┐  ╔═╗┬ ┬┬─┐┌─┐┌─┐\n" ++
          " ║ ├┬┘├─┤││││  ├─┤├┬┘  ║  │ │├┬┘└─┐│ │\n" ++
          " ╩ ┴└─┴ ┴┘└┘└─┘┴ ┴┴└─  ╚═╝└─┘┴└─└─┘└─┘\n\n"

emoticon_triste :: String
emoticon_triste = " (▰ ︶︹︺▰) "


{-
    Menus principais do sistema
-}

menu_inicial :: IO Int
menu_inicial = do
    limpar_tela
    
    putStr header
    putStrLn "  1) Entrar         "
    printStrLn "2) Sair           "
    printStrLn "3) Fechar sistema "
    putStr footer
    putStr prompt

    option <- getLineInt
    return option

menu_login :: IO (String, String)
menu_login = do
    limpar_tela
    putStr $ login ++ "\n\n"

    printCenter "Nome: "
    nome <- getLine

    printCenter "Senha: "
    senha <- getSenha
    
    return (nome, senha)

menu_aluno :: IO Int
menu_aluno = do 
    limpar_tela
    
    putStr   header
    putStrLn "  aluno...              \n"
    printStrLn "1) Fazer Matrícula    "
    printStrLn "2) Trancar Disciplina "
    printStrLn "3) Trancar Curso      "  
    printStrLn "4) Ver Disciplina     " 
    printStrLn "5) Ver Histórico      " 
    printStrLn "6) Voltar...          " 
    putStr   footer                     
    putStr   prompt

    option <- readLn :: IO Int
    return option

menu_professor :: IO Int
menu_professor = do
    limpar_tela

    putStr   header
    putStrLn "  professor...          \n"
    printStrLn "1) Fazer Chamada      "
    printStrLn "2) Fechar Disciplina  "
    printStrLn "3) Inserir Notas      "
    printStrLn "4) Voltar...          "
    putStr   footer                     
    putStr   prompt

    option <- readLn :: IO Int
    return option

menu_coordenador :: IO Int
menu_coordenador = do
    limpar_tela

    putStr   header       
    putStrLn "  coordenador...                   \n"
    printStrLn "1) Cadastrar Aluno               "   
    printStrLn "2) Cadastrar Professor           "   
    printStrLn "3) Analisar Trancamenos          "  
    printStrLn "4) Alocar professor a Disciplina "   
    printStrLn "5) Modificar estado do sistema   "  
    printStrLn "6) Voltar...                     "   
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
    putStrLn "  Selecione o estado do sistema:    \n";
    printStrLn "1) Semana de matrículas.          ";
    printStrLn "2) Período em curso.              ";
    printStrLn "3) Final de período               ";
    printStrLn "4) Voltar ao menu do Coordenador. ";   
    putStr   footer                                  
    putStr   prompt

    option <- readLn :: IO Int
    return option


menu_cadastro_professor :: IO (String, String, String)
menu_cadastro_professor = do
    limpar_tela

    putStr  header       
    
    putStrLn "  Cadastrando professor... \n"

    printStr "Matricula: "
    matricula <- getLine
    printStr "Nome: "
    nome <- getLine
    printStr "Senha: "
    senha <- getSenha
    printStr "Confirme a senha: "
    senhaConfirmada <- getSenha

    if senhaConfirmada == senha then
        return (matricula, nome, senha)
    else do
        printStr "Senhas não batem, cadastro abortado..."
        espere
        menu_cadastro_professor

menu_cadastro_aluno :: IO (String, String, String)
menu_cadastro_aluno = do
    limpar_tela

    putStr  header       
    
    putStrLn "  Cadastrando aluno... \n"

    printStr "Matricula: "
    matricula <- getLine
    printStr "Nome: "
    nome <- getLine
    printStr "Senha: "
    senha <- getSenha
    printStr "Confirme a senha: "
    senhaConfirmada <- getSenha

    if senhaConfirmada == senha then
        return (matricula, nome, senha)
    else do
        printStr "Senhas não batem, cadastro abortado..."
        espere
        menu_cadastro_aluno

menu_trancamento_curso :: IO String
menu_trancamento_curso = do
    limpar_tela

    printCenter trancar_curso_mensagem
    putStr $ " Você tem certeza " ++ emoticon_triste ++ " s/n ? "

    op <- getLine

    return op