import Interface
import Util
import Constants
import Persistence
import Data.Maybe
import Numeric 
import Services

{-
   Responsável por gerenciar a lógica do menu principal
   (entrar, sair, fechar sistema)

   Params:  opção escolhida no menu principal
   Returns: IO()
-}
controlador_principal :: Int -> IO()
controlador_principal option = do
   if option /= c_fechar_sistema then do
      if option == c_entrar then 
         controlador_login
      else if option == c_sair then do
         sair_sistema      
      else do
         printStr "Opção inválida!"
         espere

      -- Reinicia o ciclo
      option <- menu_inicial
      controlador_principal option

   else do
      printStrLn "Fechando sistema..."
      return ()

{-
   Responsável por gerenciar a lógica do login
   (autentica, salva em sessão e redireciona para o controlador adequado)

   Params:  ---
   Returns: IO()
-}
controlador_login :: IO()
controlador_login = do

   -- Verifica se o usuário da sessão está disponível
   existeSessao <- existe_sessao_ativa
   usuarioInterface <- case existeSessao of
                           False -> do
                              temp <- menu_login
                              return (temp)
                           True -> do
                              sessao <- leSessao
                              let usuario = fromJust sessao
                              let temp = (matricula usuario, senha usuario)
                              return (temp)

   -- Usuário identificado no banco
   usuarioBD <- leUsuario (fst usuarioInterface)

   let loginValido = case usuarioBD of
                           Nothing -> False
                           Just u -> senha (fromJust usuarioBD) == (snd usuarioInterface)
   
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
         espere
   else do
      printCenter "Login inválido!"
      espere

{-
   Responsável por gerenciar a lógica do menu de aluno
   (fazer matrícula, trancar disciplina, trancar curso, ver disciplina e ver histórico)

   Params:  Tipo de dado aluno e opção escolhida no menu de aluno
   Returns: IO()
-}
controlador_aluno :: Aluno -> Int -> IO()
controlador_aluno aluno option = do
   if option /= c_a_voltar then do
      if option == c_fazer_matricula then do

         disciplinas <- leDisciplinas  
         imprimeDisciplinas disciplinas
         printStr prompt
         idEscolhido <- getLineInt

         if idEscolhido > 131 || idEscolhido < 101 then do
            printStrLn "Disciplina inválida."
            espere
            reiniciaCicloAluno aluno
         else do
            let disciplinaJaMatriculada = verificaDisciplinaJaMatriculada idEscolhido (Persistence.disciplinas aluno)

            let disciplina = getDisciplina idEscolhido disciplinas
            let prereq1 = p_requisito disciplina
            let prereq2 = s_requisito disciplina
            let dispensaP1 = (prereq1 == 0) || (verificaDisciplinaJaMatriculada prereq1 (Persistence.disciplinas aluno))
            let dispensaP2 = (prereq2 == 0) || (verificaDisciplinaJaMatriculada prereq2 (Persistence.disciplinas aluno))

            if disciplinaJaMatriculada || (disciplinasMatriculadas aluno) >= 6 || not dispensaP1 || not dispensaP2 then do
               
               if disciplinaJaMatriculada then do
                  printStr "Disciplina já foi matriculada"
               else do

                  if (disciplinasMatriculadas aluno) >= 6 then do
                     printStr "O limite de disciplinas(6) já foi atingido"
                  else do
                     printStr "Faltam prerequisitos"
                     
               espere
               reiniciaCicloAluno aluno

            else do
               let disciplina = getDisciplina idEscolhido disciplinas
               let newmetadisciplina = MetaDisciplina (Persistence.id disciplina)  (nomeDisciplina disciplina)  0 [0,0,0] "em curso"   
               let newlista = [newmetadisciplina] ++ (Persistence.disciplinas aluno)
               let newaluno = Aluno (matriculaAluno aluno) (nomeAluno aluno) (1 + disciplinasMatriculadas aluno) (estaDesvinculado aluno) newlista
               atualizaAluno newaluno
               reiniciaCicloAluno newaluno

      else if option == c_trancar_disciplina then do
         if (disciplinasMatriculadas aluno) > 4 then do
            imprimeMetaDisciplinas (disciplinas aluno)
            opcao <- menu_trancamento_disc
            let newTrancamento = TrancamentoDisciplina "TrancamentoDisciplina" (matriculaAluno aluno) opcao
            salvaTrancamento newTrancamento
         else do
            printStr "É necessário estar matriculado em mais de 4 disciplinas para solicitar o trancamento\n"

         espere
         reiniciaCicloAluno aluno

      else if option == c_trancar_curso then do
         opcao <- menu_trancamento_curso 
         if opcao == "s" then do
            let newTrancamento = TrancamentoCurso "TrancamentoCurso" (matriculaAluno aluno)
            salvaTrancamento newTrancamento
         else do
            menu_desiste_trancamento
            
         espere
         reiniciaCicloAluno aluno

      else if option == c_ver_disciplina then do
         printStrLn "Disciplina: "
         printStr prompt
         id_disciplina <- getLineInt
         printStrLn(verDisciplina (disciplinas aluno) id_disciplina)
         espere
         reiniciaCicloAluno aluno

      else if option == c_ver_historico then do
         printStrLn "Histórico"
         printStr "ID\tNOME\tMEDIA\tESTADO\n"
         verHistorico (disciplinas aluno)
         espere
         reiniciaCicloAluno aluno

      else do
         printStr "Opção Invalida"
         espere
         reiniciaCicloAluno aluno

   else
      return ()

reiniciaCicloAluno :: Aluno -> IO()
reiniciaCicloAluno aluno = do
            option <- menu_aluno
            controlador_aluno aluno option

{-
   Responsável por gerenciar a lógica do menu de professor
   (fazer chamada, fechar disciplina e inserir notas)

   Params:  opção escolhida no menu de professor
   Returns: IO()
-}
controlador_professor :: Int -> IO()
controlador_professor option = do
   if option /= c_p_voltar then do
      if option == c_fazer_chamada then do
         limpar_tela
         professorDisciplina <- leProfessorDisciplinas
         sessao <- leSessao
         let disciplinas = disciplinasEmProfessor professorDisciplina (matricula (fromJust sessao))
         if disciplinas == [] then
            printStr "Professor não alocado para nenhuma disciplina"
         else do
            printStr "Disciplinas disponiveis.\n"
            printStr "Pressione 0 para sair"
            imprimeDisciplinasProfessor disciplinas
            printStr prompt
            disciplina <- readLn :: IO Int
            if disciplina == 0 then do 
                  controlador_professor 4
            else do
                  if (elem disciplina disciplinas) then do
                  alunosNoSistema <- leAlunos
                  let alunos = listaDeAlunos alunosNoSistema disciplina
                  printStr "1: para presente ou 2: para faltou\n"
                  fazerChamada alunos disciplina
                  else do
                  limpar_tela
                  printStr "Disciplina não está na lista"
                  espere
                  controlador_professor c_fazer_chamada
                  espere
      else if option == c_fechar_disciplina then do
         limpar_tela
         professorDisciplina <- leProfessorDisciplinas
         sessao <- leSessao
         let disciplinas = disciplinasEmProfessor professorDisciplina (matricula (fromJust sessao))
         if disciplinas == [] then
            printStr "Professor não alocado para nenhuma disciplina"
         else do
            printStr "Disciplinas disponiveis.\n"
            printStr "Pressione 0 para sair"
            imprimeDisciplinasProfessor disciplinas
            printStr prompt
            disciplina <- readLn :: IO Int
            if disciplina == 0 then do
                  controlador_professor 4
            else do
                  if (elem disciplina disciplinas) then do
                  alunosNoSistema <- leAlunos
                  let alunos = listaDeAlunos alunosNoSistema disciplina
                  fecharDisciplina alunos disciplina
                  else do
                  limpar_tela
                  printStr "Disciplina não está na lista"
                  espere
                  controlador_professor c_fechar_disciplina
                  espere
      else if option == c_inserir_notas then do
         limpar_tela
         professorDisciplina <- leProfessorDisciplinas
         sessao <- leSessao
         let disciplinas = disciplinasEmProfessor professorDisciplina (matricula (fromJust sessao))
         if disciplinas == [] then
            printStr "Professor não alocado para nenhuma disciplina"
         else do
            printStr "Disciplinas disponiveis.\n"
            printStr "Pressione 0 para sair"
            imprimeDisciplinasProfessor disciplinas
            printStr prompt
            disciplina <- readLn :: IO Int
            if disciplina == 0 then do
                  controlador_professor 4
            else do
                  if (elem disciplina disciplinas) then do
                  alunosNoSistema <- leAlunos
                  let alunos = listaDeAlunos alunosNoSistema disciplina
                  printStr "Escolha o estágio.\n"
                  estagio <- readLn :: IO Int
                  if (estagio < 1 || estagio > 3) then do
                        limpar_tela
                        printStr "Estágio inválido, insira por favor um estágio de 1 a 3.\n"
                        espere
                        controlador_professor c_inserir_notas
                  else do
                        atribuirNotas alunos disciplina estagio
                  else do
                  limpar_tela
                  printStr "Disciplina não está na lista"
                  espere
                  controlador_professor c_inserir_notas
                  espere 

      else do
         printStrLn "Comando inválido"
         espere
      
      reiniciaCicloProfessor
   else
         return ()

reiniciaCicloProfessor :: IO()
reiniciaCicloProfessor = do
            option <- menu_professor
            controlador_professor option

{-
   Responsável por gerenciar a lógica do menu de coordenador
   (cadastra aluno, cadastra professor, analisa trancamento, aloca professor e altera estado do sistema)

   Params:  opção escolhida no menu de coordenador
   Returns: IO()
-}
controlador_coordenador :: Int -> IO()
controlador_coordenador option = do
   if option /= c_a_voltar then do
      if option == c_cadastra_aluno then do
         -- aluno em formato (matricula, nome, senha)
         aluno_temp <- menu_cadastro_aluno
         let aluno = Aluno (triple_fst aluno_temp) (triple_snd aluno_temp) 0 False []
         let usuario = Usuario (triple_fst aluno_temp) (triple_thd aluno_temp) "aluno" (triple_snd aluno_temp)
         salvaAluno aluno
         salvaUsuario usuario
         espere
      else if option == c_cadastra_professor then do
         -- professor em formato (matricula, nome, senha)
         professor_temp <- menu_cadastro_professor
         let usuario = Usuario (triple_fst professor_temp) (triple_thd professor_temp) "professor" (triple_snd professor_temp)
         salvaUsuario usuario
         espere
      else if option == c_analisa_trancamento then do
         trancamentos <- leTrancamentos
         solic <- menu_analisa_trancamento (trancamentos_para_string trancamentos 1)
         if(solic > length(trancamentos)) then do 
            printStr "Opção inválida"
            espere
         else do
            opcao <- menu_decide_tranc
            let tranc = getTrancamento 1 solic trancamentos
            if opcao == 1 then do
                  analisaTrancamento tranc trancamentos
            else do
                  printStr "A solicitação será excluída..."
            let newTrancamentos = removeTrancamento tranc trancamentos
            salvaTrancamentos newTrancamentos
         
            espere
      else if option == c_alocar_professor then do
         professor_disciplina_temp <- menu_aloca_professor
         alocaProfessor professor_disciplina_temp
         espere
      else if option == c_altera_estado then do
         -- pede o novo estado para o usuário e altera o do sistema
         estado_int <- menu_altera_estado
         let estado = Estado estado_int
         salvaEstado estado
         espere
      else do
         printStrLn "Comando inválido"
         espere

      reiniciaCicloCoordenador
   else
      return ()

reiniciaCicloCoordenador :: IO()
reiniciaCicloCoordenador = do
            option <- menu_coordenador
            controlador_coordenador option

sair_sistema :: IO()
sair_sistema = do
   existeSessao <- existe_sessao_ativa
   if (existeSessao == False) then
      printStr "Não existe usuário logado no momento!"
   else do
      limpaSessao
      printStr ("Você saiu com sucesso...")
   espere
   return ()

-- Gatilho principal
main = do
option <- menu_inicial
controlador_principal option