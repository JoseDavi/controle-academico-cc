#include <iostream>
#include <stdio.h>
#include <stdlib.h>
#include <string>
#include <map>
#include <fstream>

#include "files.h"
#include "util.h"

using namespace std;

// Constante do sistema
enum Estado              {MATRICULA = 1, EM_CURSO = 2, FIM_DE_PERIODO = 3};
enum ComandosPrincipais  {MENU_INICIAL, LOGAR, SAIR, FECHAR_SISTEMA};
enum TipoUsuario         {NONE = 0, ALUNO = 1, PROFESSOR = 2, COORDENADOR = 3};
enum ComandoCoordenador  {CADASTRA_ALUNO = 1, CADASTRA_PROFESSOR = 2, ANALISA_TRANCAMENTO = 3};

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
void atualiza_aluno();

// Funções auxiliares de autenticação e atualização de usuário operante
bool valida_usuario(string username, string password);
void atualiza_tipo_de_usuario(string username);

// Funções de gerencia de pessoal por parte do usuário coordenador
void cadastra_aluno();
void cadastra_professor();
void analisa_trancamento();

int usrtipo = NONE; // Tipo do usuário operante
string username = "";
string password = "";

// Usuários do sistema ( nome --> senha, tipo )
map<string, array<string, 2>> usuarios;

// Disciplinas no sistema (codigo --> nome)
map<string, string> disciplinas;

// Comandos principais do sistema
int command = MENU_INICIAL;


int main() {

  usuarios = lerUsuarios();
  disciplinas = lerDisciplinas();

  main_menu();

  salvarDisciplinas(disciplinas);
  salvarUsuarios(usuarios);

  return 0;
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
            cout << "Usuário inválido! " << usrtipo << endl;
          break;
        }
      break;
      case SAIR:
        cout << "saindo da conta...\n";
        username = "";
        password = "";
        command = MENU_INICIAL;
      break;
      case FECHAR_SISTEMA:
        cout << "saindo...\n";
        exit = true;
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


bool usuario_esta_logado () {
  return !username.empty() && !password.empty();
}

void menu_login() {

  if (usuario_esta_logado()){
    return; // o usuário já esta logado.
  }

  string usr;
  cout << "Login: ";
  cin >> usr;
  username = usr;

  string psw;
  cout << "Senha: ";
  cin >> psw;
  password = psw;

  if (!valida_usuario(username,password)) {
    username = "";
    password = "";
    usrtipo = NONE;
    return;
  }

  atualiza_tipo_de_usuario(username);

}

bool valida_usuario(string username, string password) {
  array<string, 2> user = usuarios[username];
  if (user[0].compare(password)== 0) {
    return true;
  } else{
    cout << "Senha inválida.";
    return false;
  }
}

void atualiza_tipo_de_usuario(string username) {
  array<string, 2> user = usuarios[username];
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

    cin >> command;
    testa_falha_cin();

    if (command == 6) {
      //username = "";
      //password = "";
      break;
    }

    // TODO issue #2
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

    cin >> command;
    testa_falha_cin();

    if (command == 4) {
      //username = "";
      //password = "";
      break;
    }

    // TODO issue #3
  }
  return;
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
    cout << "4) Voltar...\n";
    cout << "\n| ----------------------------------------------- |\n";

    cin >> command;
    testa_falha_cin();

    if (command == 4) {
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
      default:
      cout << "Opção inválida!" << endl;
      break;
    }

  }

}

/* Seção onde se gerencia os alunos */

struct estadoDoAlunoEmDisciplina {
  int faltas = 0;
  int notas[3];

  // estado (em curso, concluída, trancada)
  string estado = "";
};

struct aluno {
  string matricula = "";
  string nome = "";
  bool esta_desvinculado = 0;

  // Codigo de disciplina - struct do estado do aluno
  map<string, estadoDoAlunoEmDisciplina> historico;
};

void realizar_matricula() {
  // To do
}
void trancar_disciplina() {
  // To do
}
void trancar_curso() {
  // To do
}
void ver_disciplina() {
  // To do
}
void ver_historico() {
  // To do
}

/* Seção onde se gerencia os professores */

void fazer_chamada() {
  // To do
}
void fechar_disciplina() {
  // To do
}
void atualiza_aluno() {
  // To do
}

/* Seção onde se gerencia o coordenador */

// Análise de trancamento po parte do coordenador
void analisa_trancamento() {
  // ainda vou finalizar
  if (!usuario_esta_logado()) {
    cout << "Usuário não está logado!";
    return;
  }
}

// Cadastramento de aluno por parte do coordenador
void cadastra_aluno() {
  string name, op, pswd;

  if (!usuario_esta_logado()) {
    cout << "Usuário não está logado!";
    return;
  }

  while (true) {
    limparTela();

    cout << "Nome do aluno: ";
    cin >> name;

    cout << "\nSenha do aluno: ";
    cin >> pswd;

    if (usuarios.count(name) == 0) {
      usuarios[name] = {pswd,"aluno"};
    } else {
      cout << "\n\nCadastro negado. Aluno já consta no sistema!\n" << endl;
    }

    cout << "Deseja cadastrar mais um aluno? s/n" << endl;
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
  string name, pswd, op;

  if (!usuario_esta_logado()) {
    cout << "Usuário não está logado!";
    return;
  }

  while (true) {
    limparTela();

    cout << "Nome do professor: ";
    cin >> name;

    cout << "\nSenha do professor: ";
    cin >> pswd;

    if (usuarios.count(name) == 0) {
      usuarios[name] = {pswd,"professor"};

    } else {
      cout << "\n\nCadastro negado. Professor já consta no sistema!\n" << endl;
    }

    cout << "Deseja cadastrar mais um professor? s/n" << endl;
    cin >> op;

    if (op == "n") {
      //username = "";
      //password = "";
      break;
    }

  }

}
