#include <iostream>
#include <stdio.h>
#include <cstdlib>
#include <string>
#include <map>
#include <fstream>
#include <iomanip>
#include <curses.h>

#include "files.h"
#include "util.h"

using namespace std;

// Constante do sistema
enum Estado              {MATRICULA = 1, EM_CURSO = 2, FIM_DE_PERIODO = 3};
enum ComandosPrincipais  {MENU_INICIAL, LOGAR, SAIR, FECHAR_SISTEMA};
enum TipoUsuario         {NONE = 0, ALUNO = 1, PROFESSOR = 2, COORDENADOR = 3};
enum ComandoCoordenador  {CADASTRA_ALUNO = 1, CADASTRA_PROFESSOR = 2, ANALISA_TRANCAMENTO = 3, ALOCAR_PROFESSOR = 4, ALTERA_ESTADO = 5};
enum ComandoAluno        {FAZER_MATRICULA = 1, TRANCAR_DISCIPLINA = 2, TRANCAR_CURSO = 3, VER_DISCIPLINA = 4, VER_HISTORICO = 5};
enum ComandoProfessor    {FAZER_CHAMADA = 1, FECHAR_DISCIPLINA = 2, INSERIR_NOTAS = 3};

// Definição de protótipos dos menus do sistema
void main_menu();
void menu_inicial();
void menu_aluno();
void menu_professor();
void menu_coordenador();
void menu_login();

void realizar_matricula();
void trancar_disciplina();
void trancar_curso();
void ver_disciplina();
void ver_historico();

void fazer_chamada();
void fechar_disciplina();
void notas_aluno(int estagio);


// Funções auxiliares de autenticação e atualização de usuário operante
bool valida_usuario(string username, string password);
void atualiza_tipo_de_usuario(string username);

// Funções de gerencia de pessoal por parte do usuário coordenador
void cadastra_aluno();
void cadastra_professor();
void analisa_trancamento();
void alocar_professor();
void altera_estado();

int usrtipo = NONE; // Tipo do usuário operante
string username = "";
string password = "";

// Usuários do sistema ( matricula --> senha, tipo, nome )
map<string, array<string, 3>> usuarios;

// Disciplinas no sistema ( codigo --> Disciplina )
map<string, Disciplina> disciplinas;

// Alunos no sistema ( matrícula --> aluno )
map<string, Aluno> alunos;

//Solicitacoes de trancamento
vector<array <string, 2>> trancamentos;

// Professor e Disciplina
vector<array <string, 2>>  professor_disciplina;

// Comandos principais do sistema
int command = MENU_INICIAL;
int estado;


int main() {

  usuarios = lerUsuarios();
  disciplinas = lerDisciplinas();
  alunos = lerAlunos();
  estado = MATRICULA;
  professor_disciplina = lerProfessor_Disciplina();

  // Se quiserem testar, fçam o seguinte: Vejam o csv de alunos, depois
  // descomentem essa seção que cadastra mais usuários e depois rodem o
  // programa e vejam o alunos.csv denovo

  // Aluno test;
  // test.matricula = "22222222";
  // test.nome = "wizar matteus";
  // test.esta_desvinculado = 2;

  // DisciplinaEmAluno disciplina;
  // disciplina.faltas = 2;
  // disciplina.notas[0] = 9.3;
  // disciplina.notas[1] = 8.2;
  // disciplina.notas[2] = 7.1;
  // disciplina.estado = "concluida";
  // disciplina.estado = "trancada";

  // test.historico["120"] = disciplina;

  // alunos[test.matricula] = test;
  // alunos["11911919"] = test;

  main_menu();

  salvarAlunos(alunos);
  salvarDisciplinas(disciplinas);
  salvarUsuarios(usuarios);
  salvarTrancamentos(trancamentos);
  salvarProfessor_Disciplina(professor_disciplina);

  return 0;
}

bool usuario_esta_logado () {
  return !username.empty() && !password.empty();
}

void main_menu() {

  menu_inicial();
  bool exit = false;
  while (!exit) {
    switch(command) {
      case MENU_INICIAL:
        menu_inicial();
      break;
      case LOGAR:
        menu_login();
        switch (usrtipo) {
          case ALUNO:
            menu_aluno();
          break;
          case PROFESSOR:
            menu_professor();
          break;
          case COORDENADOR:
            menu_coordenador();
          break;
          default:
            cout << " Usuário inválido! " << endl;
            press_any_key();
            command = MENU_INICIAL;
          break;
        }
      break;
      case SAIR:
        if (usuario_esta_logado()) {
          cout << "saindo da conta...\n";
          username = "";
          password = "";
        } else {
          cout << "Você ainda não está logado!";
        }
        press_any_key();
        command = MENU_INICIAL;
      break;
      case FECHAR_SISTEMA:
        cout << "saindo...\n";
        exit = true;
      break;
      default:
        cout << "Opção inválida";
        command = MENU_INICIAL;
    }
  }
}

void menu_inicial() {
  limparTela();
  cout << "\n| ------------ Controle Academico CC ------------ |\n\n";
  cout << "1) Entrar \n";
  cout << "2) Sair\n";
  cout << "3) Fechar sistema\n";
  cout << "\n| ----------------------------------------------- |\n";
  cout << "> ";

  cin >> command;
  testa_falha_cin();
}

void menu_login() {

  if (usuario_esta_logado()){
    return; // o usuário já esta logado.
  }

  char user[50], pass[50];

  initscr();

  clear();

  printw("Matricula: ");

  getstr(user);

  printw("Senha: ");

  noecho();

  getstr(pass);

  echo();

  endwin();

  username = user;
  password = pass;

  if (!valida_usuario(username,password)) {
    username = "";
    password = "";
    usrtipo = NONE;
    return;
  }

  atualiza_tipo_de_usuario(username);
}

bool valida_usuario(string username, string password) {
  if (usuarios.count(username) > 0) {
    array<string, 3> user = usuarios[username];
    if (user[0].compare(password) == 0) {
      return true;
    } else{
      cout << "Senha inválida.";
      return false;
    }
  } else {
    cout << "Usuário inexistente!";
  }
}

void atualiza_tipo_de_usuario(string username) {
  array<string, 3> user = usuarios[username];
  if(user[1].compare("aluno") == 0){
    usrtipo = ALUNO;
  }
  else if(user[1].compare("professor") == 0){
    usrtipo = PROFESSOR;
  }
  else if(user[1].compare("coordenador") == 0){
    usrtipo = COORDENADOR;
  }
}


void menu_aluno() {

  if (!usuario_esta_logado()) {
    cout << "Usuário não está logado!";
    return;
  }

  while (true) {

    limparTela();
    cout << "\n| ------------ Controle Academico CC ------------ |\n";
    cout << "aluno...\n\n";
    cout << "1) Fazer Matrícula\n";
    cout << "2) Trancar Disciplina\n";
    cout << "3) Trancar Curso\n";
    cout << "4) Ver Disciplina\n";
    cout << "5) Ver Histórico\n";
    cout << "6) Voltar...\n";
    cout << "\n| ----------------------------------------------- |\n";
    cout << "> ";

    cin >> command;
    testa_falha_cin();

    if (command == 6) {
      //username = "";
      //password = "";
      break;
    }

  switch (command) {
    case FAZER_MATRICULA:
      realizar_matricula();
      press_any_key();
      break;
    case TRANCAR_DISCIPLINA:
      trancar_disciplina();
      break;
    case TRANCAR_CURSO:
      trancar_curso();
      press_any_key();
      break;
    case VER_DISCIPLINA:
      ver_disciplina();
      press_any_key();
      break;
    case VER_HISTORICO:
      ver_historico();
      press_any_key();
      break;
    default:
      cout << "Opção inválida!" << endl;
      break;
    }
  }
  return;
}

void menu_professor() {

  if (!usuario_esta_logado()) {
    cout << "Usuário não está logado!";
    return;
  }

  while (true) {

    limparTela();
    cout << "\n| ------------ Controle Academico CC ------------ |\n";
    cout << "professor...\n\n";
    cout << "1) Fazer Chamada\n";
    cout << "2) Fechar Disciplina\n";
    cout << "3) Inserir Notas\n";
    cout << "4) Voltar...\n";
    cout << "\n| ----------------------------------------------- |\n";
    cout << "> ";

    cin >> command;
    testa_falha_cin();

    if (command == 4) {
      //username = "";
      //password = "";
      break;
    }

    switch (command) {

      case FAZER_CHAMADA:
      fazer_chamada();
      break;
      case FECHAR_DISCIPLINA:
      fechar_disciplina();
      break;
      case INSERIR_NOTAS:
      while (true){
      cout << "Qual estágio? Digite 0 para voltar." << endl;
      int estagio;
      cin >> estagio;
      if(estagio == 0){
        break;
      }
      else if(estagio > 3 || estagio < 1){
        cout << "Estágio invalido, por favor escolha entre os estágios 1, 2 e 3." << endl;
      }else{
      notas_aluno(estagio);
      }
      }
      break;
      default:
      cout << "Opção inválida!" << endl;
      break;
    }
  }

}

void menu_coordenador() {

  if (!usuario_esta_logado()) {
    cout << "Usuário não está logado!";
    return;
  }

  while (true) {

    limparTela();
    cout << "\n| ------------ Controle Academico CC ------------ |\n";
    cout << "coordenador...\n\n";
    cout << "1) Cadastrar Aluno\n";
    cout << "2) Cadastrar Professor\n";
    cout << "3) Analisar Trancamenos\n";
    cout << "4) Alocar professor a Disciplina\n";
    cout << "5) Modificar estado do sistema\n";
    cout << "6) Voltar...\n";
    cout << "\n| ----------------------------------------------- |\n";
    cout << "> ";

    cin >> command;
    testa_falha_cin();

    if (command == 6) {
      //username = "";
      //password = "";
      break;
    }

    switch (command) {

      case CADASTRA_ALUNO:
      cadastra_aluno();
      break;
      case CADASTRA_PROFESSOR:
      cadastra_professor();
      break;
      case ANALISA_TRANCAMENTO:
      analisa_trancamento();
      break;
      case ALOCAR_PROFESSOR:
      alocar_professor();
      break;
      case ALTERA_ESTADO:
      altera_estado();
      default:
      cout << "Opção inválida!" << endl;
      break;
    }

  }

}

/* Seção onde se gerencia os alunos */


void imprime_disciplinas_disponiveis(map<string, DisciplinaEmAluno> historico) {
  bool disciplina_nunca_matriculada, disciplina_trancada;
  map<string, Disciplina>::iterator it;
  for(it = disciplinas.begin(); it != disciplinas.end(); it++){
    disciplina_nunca_matriculada = !historico.count(it->first);   // key not exists
    disciplina_trancada = historico.count(it->first) && historico.find(it->first)->second.estado.compare("trancada") == 0;
    if (disciplina_nunca_matriculada || disciplina_trancada){
        cout << it->first << ") " <<  it->second.nome << endl;
    }
  }
}


string verifica_prerequisitos(string disciplina_id, map<string, DisciplinaEmAluno> historico ) {
    string prerequisito1 = disciplinas.find(disciplina_id)->second.codigo_prerequisitos[0];
    string prerequisito2 = disciplinas.find(disciplina_id)->second.codigo_prerequisitos[1];
    bool prerequisitos_satisfeitos, sem_prerequisito1, sem_prerequisito2, sem_nenhum_prerequisito;

    prerequisitos_satisfeitos = (prerequisito1.compare("0") == 0 && prerequisito2.compare("0") == 0) ||
        historico.count(prerequisito1) && historico.find(prerequisito1)->second.estado.compare("concluida") == 0 &&
        historico.count(prerequisito2) && historico.find(prerequisito2)->second.estado.compare("concluida") == 0 ;

    sem_prerequisito1 = prerequisito1.compare("0") != 0 && (!historico.count(prerequisito1) || historico.find(prerequisito1)->second.estado.compare("concluida") != 0);
    sem_prerequisito2 = prerequisito2.compare("0") != 0 && (!historico.count(prerequisito2) || historico.find(prerequisito2)->second.estado.compare("concluida") != 0);
    sem_nenhum_prerequisito = sem_prerequisito1 && sem_prerequisito2;

    if (prerequisitos_satisfeitos) {
      return "";
    }  else if (sem_nenhum_prerequisito) {
      return "Disciplinas " + disciplinas.find(prerequisito1)->second.nome + " e " + disciplinas.find(prerequisito2)->second.nome + " não concluidas";
    } else if (sem_prerequisito1) {
      return "Disciplina " + disciplinas.find(prerequisito1)->second.nome + " não concluida";
    } else if (sem_prerequisito2) {
      return "Disciplina " + disciplinas.find(prerequisito2)->second.nome + " não concluida";
    }
}


void realizar_matricula() {

  if (estado != MATRICULA) {
      cout << "O tempo de realização de matrícula foi esgotado." << endl;
      return;
  }

  string matricula = username;
  Aluno aluno =  alunos.find(matricula)->second;
  map<string, DisciplinaEmAluno> novohistorico = alunos.find(matricula)->second.historico;

  imprime_disciplinas_disponiveis(novohistorico);

  string codigo;
  cout << "Código da disciplina: " << endl;
  cin >> codigo;

  if (!disciplinas.count(codigo)) {
    cout << "Código de disciplina inválido" <<  endl;
    return;
  }

  string msg = verifica_prerequisitos(codigo, alunos.find(matricula)->second.historico);
  if (msg.compare("") != 0){
    cout << "Matrícula não permitida. " << msg <<  endl;
    return;
  }

  struct DisciplinaEmAluno disciplina;

  disciplina.codigo = codigo;
  disciplina.estado = "em curso";
  disciplina.nome = disciplinas.find(codigo)->second.nome;

  if (aluno.disciplinas_matriculadas < 6) {
    novohistorico.insert(pair<string,DisciplinaEmAluno>(codigo, disciplina));
    alunos.find(matricula)->second.historico = novohistorico;
    alunos.find(matricula)->second.disciplinas_matriculadas++;
  } else {
    cout << "Matricula não permitida. O aluno já está matriculado em 6 cadeiras." <<  endl;
  }
}

void trancar_disciplina() {
  string op, disciplina_id, estado;

    Aluno aluno =  alunos.find(username)->second;

    if (aluno.disciplinas_matriculadas <= 4) {
      cout << "Para solicitar o trancamento, é necessário estar matriculado em mais de 4 disciplinas. Pressione qualquer tecla para voltar." << endl;
      cin >> op;
    } else {

      do {
        cout << "\nDigite o ID da disciplina que deseja trancar: ";
        cin >> disciplina_id;

        estado = aluno.historico.find(disciplina_id)->second.estado;
        if (aluno.historico.count(disciplina_id) > 0 &&  estado.compare("em curso") == 0) {
          trancamentos.push_back({disciplina_id, username});
          cout << "Solicitação enviada com sucesso!";
        } else if (aluno.historico.count(disciplina_id) > 0 && estado.compare("trancada") == 0) {
          cout << "Disciplina já foi trancada!" << endl;
        } else {
          cout << "Aluno não matriculado nessa disciplina!" << endl;
        }

        cout << "\nDeseja solicitar o trancamento de mais uma disciplina? s/n" << endl;
        cin >> op;

      } while (op == "s");

    }

}

void trancar_curso() {
  string op;

  cout << "\nDeseja solicitar o trancamento total do curso? s/n" << endl;
  cin >> op;

  if (op == "s") {
    trancamentos.push_back({"curso", username});
    cout << "Solicitação enviada com sucesso!";
  } else {
    cout << "Operação não realizada!";
  }

}

void ver_disciplina() {
  string matricula = username;
  map<string, DisciplinaEmAluno> historico = alunos.find(matricula)->second.historico;

  string codigo;
  cout << "Código da disciplina: " << endl;
  cin >> codigo;

  if (historico.count(codigo)) {
      cout << "" << endl;
      cout << "Nome: " + historico.find(codigo)->second.nome << endl;
      cout << "Estado: " + historico.find(codigo)->second.estado << endl;
      cout << "Faltas: " + to_string(historico.find(codigo)->second.faltas) << endl;
      cout << "1° estágio: " + to_string(historico.find(codigo)->second.notas[0])<< endl;
      cout << "2° estágio: " + to_string(historico.find(codigo)->second.notas[1])<< endl;
      cout << "3° estágio: " + to_string(historico.find(codigo)->second.notas[2])<< endl;
  } else {
      cout << "Disciplina inválida." << endl;
  }
}


float calcula_media(double array[3]){
    return (array[0] + array[1] + array[2]) / 3;
}

void ver_historico() {
  string matricula = username;
  double media;
  double cra = 0.0;
  int disciplinas_concluidas = 0;

  map<string, DisciplinaEmAluno> historico = alunos.find(matricula)->second.historico;

  map<string, DisciplinaEmAluno>::iterator it;

   cout << "\n| ID | NOME | MEDIA | SITUAÇÃO |" << endl;
   for(it = historico.begin(); it != historico.end(); it++){
     if (it->second.estado == "em curso") {
        cout << "| " << it->first + " | " <<  it->second.nome << " | - | " << "em curso |" << endl;
     } else {
        string situacao;
        media = calcula_media(it->second.notas);

        if (it->second.estado.compare("trancado") == 0){
            situacao = "trancado";
        } else if (media >= 7) {
            situacao = "aprovado";
        } else {
            situacao = "reprovado";
        }

        cout << "| " << it->first + " | " <<  it->second.nome << " | " << setprecision(3) << media << " | " << situacao << " |" << endl;
        if (it->second.estado == "concluida") {
          cra += media;
          disciplinas_concluidas++;
        }
     }
  }
  cra = cra / disciplinas_concluidas;
  if (disciplinas_concluidas >= 1) {
    cout << "CRA: " << cra << endl;
  } else {
    cout << "O aluno ainda não possui CRA definido!" << endl;
  }
}

/* Seção onde se gerencia os professores */

void fazer_chamada() {
  int op;
  for (auto i = 0; i != professor_disciplina.size(); i++)
  {
    if(professor_disciplina[i][0] == username){

      map<string, Aluno>::iterator it;

      for(it = alunos.begin(); it != alunos.end(); it++){
        map<string, DisciplinaEmAluno> historicoAluno = it->second.historico;
        if(historicoAluno.count(professor_disciplina[i][1])){
          if(historicoAluno.find(professor_disciplina[i][1])->second.estado == "em curso"){
            cout << "Matricula: " << it->first << " Nome: " << it->second.nome << endl;
            cout << "0) Aluno presente." << endl;
            cout << "1) Aluno faltou." << endl;
            cin >> op;
            if(op){
              it->second.historico.find(professor_disciplina[i][1])->second.faltas++;
            }
          }
        }
      }
    }
  }
}
void fechar_disciplina() {
  for (auto i = 0; i != professor_disciplina.size(); i++)
  {
    if(professor_disciplina[i][0] == username){

      map<string, Aluno>::iterator it;

      for(it = alunos.begin(); it != alunos.end(); it++){
        string codigo = professor_disciplina[i][1];
        map<string, DisciplinaEmAluno> historicoAluno = it->second.historico;
        if(historicoAluno.count(codigo)){
          if(historicoAluno.find(codigo)->second.estado == "em curso"){
            it->second.historico.find(codigo)->second.estado = "concluida";
          }
        }
      }
    }
  }
}
void notas_aluno(int estagio) {

  for (auto i = 0; i != professor_disciplina.size(); i++)
  {
    if(professor_disciplina[i][0] == username){

      map<string, Aluno>::iterator it;

      for(it = alunos.begin(); it != alunos.end(); it++){
        map<string, DisciplinaEmAluno> historicoAluno = it->second.historico;
        if(historicoAluno.count(professor_disciplina[i][1])){
          if(historicoAluno.find(professor_disciplina[i][1])->second.estado == "em curso"){
            while(true){
            cout << "Matricula: " << it->first << " Nome: " << it->second.nome << endl;
            cout << "Nota do Aluno:" << endl;
            float nota;
            cin >> nota;
            if(nota < 0 || nota > 10){
              cout << "Nota inválida, por favor atribua uma nota de 0 a 10." << endl;
            }else{
            it->second.historico.find(professor_disciplina[i][1])->second.notas[estagio-1] = nota;
            break;
            }
            }
          }
        }
      }
    }
  }}

/* Seção onde se gerencia o coordenador */

// Análise de trancamento po parte do coordenador
void analisa_trancamento() {
  if (!usuario_esta_logado()) {
    cout << "Usuário não está logado!";
    return;
  }

  int numero_solicitacao, operacao;

  while (true) {
    limparTela();
    for (int i = 0; i < trancamentos.size(); i++) {
      cout << i+1 << ")" << "Aluno de matricula: " << trancamentos[i][1] << " solicita trancamento de:  " << trancamentos[i][0] << endl;
    }

    cout << "Digite o número da solicitação que deseja analisar ou digite 0 para sair." << endl;
    cin >> numero_solicitacao;

    if (numero_solicitacao == 0) {
      break;
    }

    cout << "1) Aceitar solicitação" << endl;
    cout << "2) Recusar solicitação" << endl;
    cin >> operacao;

    if (operacao == 1) {
      string matricula = trancamentos[numero_solicitacao-1][1];
      string codigo_disciplina = trancamentos[numero_solicitacao-1][0];
      if (trancamentos[numero_solicitacao-1][0] == "curso") {
        alunos.find(matricula)->second.esta_desvinculado = 1;
      } else {
        alunos.find(matricula)->second.historico[codigo_disciplina].estado = "trancada";
        alunos.find(matricula)->second.disciplinas_matriculadas--;
      }
    }
    trancamentos.erase(trancamentos.begin() + numero_solicitacao - 1);
  }
}

// Cadastramento de aluno por parte do coordenador
void cadastra_aluno() {
  string nome, op, pswd, matricula;

  if (!usuario_esta_logado()) {
    cout << "Usuário não está logado!";
    return;
  }

  while (true) {

    cout << "\nMatricula: ";
    cin >> matricula;

    cout << "Nome: ";
    cin >> nome;

    cout << "Senha do aluno: ";
    cin >> pswd;

    if (usuarios.count(nome) == 0) {
      usuarios[matricula] = {pswd, "aluno", nome};
      struct Aluno aluno;
      aluno.nome = nome;
      aluno.matricula = matricula;
      alunos.insert(pair<string, Aluno>(matricula, aluno));
    } else {
      cout << "\n\nCadastro negado. Aluno já consta no sistema!\n" << endl;
    }

    cout << "\nDeseja cadastrar mais um aluno? s/n" << endl;
    cin >> op;

    if (op == "n") {
      //username = "";
      //password = "";
      break;
    }

  }

}

// Cadastramento de professor por parte do coordenador
void cadastra_professor() {
  string mat, name, pswd, op;

  if (!usuario_esta_logado()) {
    cout << "Usuário não está logado!";
    return;
  }

  while (true) {

    cout << "\nMatricula do professor: ";
    cin >> mat;

    cout << "Nome do professor: ";
    cin >> name;

    cout << "Senha do professor: ";
    cin >> pswd;

    if (usuarios.count(mat) == 0) {
      usuarios[mat] = {pswd,"professor", name};
    } else {
      cout << "\nCadastro negado. Professor já consta no sistema!\n" << endl;
    }

    cout << "\nDeseja cadastrar mais um professor? s/n" << endl;
    cin >> op;

    if (op == "n") {
      //username = "";
      //password = "";
      break;
    }

  }

}

// Aloca professor em uma disciplina
void alocar_professor(){
  string matricula, codigo;
  cout << "\nMatricula do professor: ";
  cin >> matricula;

  cout << "\nCodigo da disciplina: ";
  cin >> codigo;

  if(usuarios.count(matricula) && disciplinas.count(codigo)){
    professor_disciplina.push_back({matricula,codigo});
  }else{
    if(usuarios.count(matricula) == 0){
      cout << "\nMatricula do professor invalida!";
    }
    cout << "\nCodigo da disciplina invalido!";
  }
}

// Altera o estado do controle acadêmico (semana de matrícula, período em curso ou fim de período)
void altera_estado() {

  while (true)  {
    limparTela();

    cout << "Selecione o estado do sistema:\n";
    cout << "1) Semana de matrículas.\n";
    cout << "2) Período em curso.\n";
    cout << "3) Final de período\n";
    cout << "4) Voltar ao menu do Coordenador.\n";

    cin >> command;
    testa_falha_cin();

    if (command == 4) {
      break;
    }


    switch (command) {
      case 1:
      estado = MATRICULA;
      break;
      case 2:
      estado = EM_CURSO;
      break;
      case 3:
      estado = FIM_DE_PERIODO;
      break;
      default:
      cout << "Opção inválida!" << endl;
      break;
    }
  }
}
