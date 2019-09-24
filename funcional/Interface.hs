module Interface where

import Util

-- Limpa a tela adicionando cem quebras de linha no terminal
limpar_tela :: IO()
limpar_tela = do
    putStr $ repeatNewLine 100

-- Define o cabeçalho padrão do sistema
header :: String
header =  "\n╔═╗┌─┐┌┐┌┌┬┐┬─┐┌─┐┬  ┌─┐  ╔═╗┌─┐┌─┐┌┬┐┌─┐┌┬┐┬┌─┐┌─┐  ╔═╗╔═╗\n" ++
            "║  │ ││││ │ ├┬┘│ ││  ├┤   ╠═╣│  ├─┤ ││├┤ │││││  │ │  ║  ║\n"   ++  
            "╚═╝└─┘┘└┘ ┴ ┴└─└─┘┴─┘└─┘  ╩ ╩└─┘┴ ┴─┴┘└─┘┴ ┴┴└─┘└─┘  ╚═╝╚═╝\n\n"

-- Define o rodapé padrão do sistema
footer :: String
footer =  "\n-----------------------------------------------------------\n"


menu_inicial :: IO Int
menu_inicial = do
    limpar_tela
    putStr $   header                 ++
               "1) Entrar \n"         ++
               "2) Sair\n"            ++
               "3) Fechar sistema\n"  ++
               footer                 ++
               "> "
    option <- readLn :: IO Int
    return option

menu_aluno :: IO Int
menu_aluno = do 
    limpar_tela
    putStr $ header                    ++
             "aluno...\n\n"            ++
             "1) Fazer Matrícula\n"    ++
             "2) Trancar Disciplina\n" ++
             "3) Trancar Curso\n"      ++
             "4) Ver Disciplina\n"     ++
             "5) Ver Histórico\n"      ++
             "6) Voltar...\n"          ++
             footer                    ++
             "> "
    option <- readLn :: IO Int
    return option

menu_professor :: IO Int
menu_professor = do
    limpar_tela
    putStr $  header                     ++
              "professor...\n\n"         ++
              "1) Fazer Chamada\n"       ++
               "2) Fechar Disciplina\n"  ++
              "3) Inserir Notas\n"       ++
              "4) Voltar...\n"           ++
              footer                     ++
              "> "
    option <- readLn :: IO Int
    return option

menu_coordenador :: IO Int
menu_coordenador = do
    limpar_tela
    putStr $  header                                ++
              "coordenador...\n\n"                  ++
              "1) Cadastrar Aluno\n"                ++
              "2) Cadastrar Professor\n"            ++
              "3) Analisar Trancamenos\n"           ++
              "4) Alocar professor a Disciplina\n"  ++
              "5) Modificar estado do sistema\n"    ++
              "6) Voltar...\n"                      ++
              footer                                ++
              "> "
    option <- readLn :: IO Int
    return option

