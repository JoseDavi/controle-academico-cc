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

emoticon_feliz :: String
emoticon_feliz = " (✿ ◠‿◠ ) "


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

    printCenter "Matricula: "
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

    option <- getLineInt
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

    option <- getLineInt
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

    option <- getLineInt
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

    option <- getLineInt
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

menu_desiste_trancamento :: IO ()
menu_desiste_trancamento = do
    limpar_tela

    printCenter trancar_curso_mensagem
    putStr $ "Obrigado por continuar conosco! " ++ emoticon_feliz ++ "\n"

    return ()

menu_trancamento_disc :: IO Int
menu_trancamento_disc = do

    printStr prompt
    putStr "Digite o ID da disciplina que deseja trancar\n"
    printStr prompt
    op <- getLineInt

    return op
   
menu_aloca_professor :: IO (String, Int)
menu_aloca_professor = do
    limpar_tela

    putStr  header       
    
    putStrLn "  Alocando professor... \n"

    printStr "Matricula do professor: "
    matricula <- getLine

    printStr "Codigo da disciplina: "
    codigo <- getLineInt

    return (matricula, codigo)

menu_analisa_trancamento :: String -> IO Int
menu_analisa_trancamento trancamentos = do
    limpar_tela

    putStr  header       
    
    putStr " Solicitações de trancamento... \n\n"

    printStrLn (adiciona_espacos c_espacos_identados trancamentos) 

    printStrLn "Digite o número da solicitação que deseja analisar: "

    printStr  prompt

    option <- getLineInt
    return option

menu_decide_tranc :: IO Int
menu_decide_tranc = do
    limpar_tela

    putStr  header

    putStr "  1) Aceitar solicitação\n"
    printStrLn "2) Recusar solicitação\n"

    printStr  prompt

    option <- getLineInt
    return option