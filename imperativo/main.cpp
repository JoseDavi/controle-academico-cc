#include <iostream>
#include <stdio.h>
#include <stdlib.h>
#include <string>
#include <map>
#include <fstream>

using namespace std;

enum Estado {matricula = 1, emcurso = 2, fimdeperiodo = 3};
enum ComandoPrincipais {MENU_INICIAL, LOGAR, SAIR, FECHAR_SISTEMA};
enum TipoUsuario {ALUNO = 1, PROFESSOR = 2, COORDENADOR = 3};

// Menus dos funcionários
void main_menu();
void menu_inicial();
void menu_aluno();
void menu_professor();
void menu_coordenador();
void menu_login();

bool valida_usuario(string username, string password);
void atualiza_tipo_de_usuario(string username);

void salvarUsuarios();
void esvaziarArquivo(string nomeArquivo);
void lerUsuarios();

int main() {
    // TODO  Implementar o código que carrega todos os dados cadastrados no CSV;
    // a ideia é de otimizar a permanencia de dados, mas inves de manipular arquivos diretamente(processo
    // altamente custoso), fazemos isso apenas duas vezes: no início e final da execução do programa.

    // TODO issue #5 (carregar disciplinas)

    main_menu();

    // TODO  Implementar o código que armazena/atualiza os dados da estrutura de dados no arquivo CSV;
    return 0;
}

int usrtipo = 0;
string username = "";
string password = "";

//Users é um array de arrays, onde os arrays mais internos tem 3 posições, nome, senha e tipo, mas o plano é
//guardar também matricula, e talvez um array com as cadeiras que ele já pagou, ou um apontador pra elas.
//Inicie ele com poucas posições para testar, mas a gente pode aumentar ou diminur se necessário.
//Lembrando que estou utilizando username como identificador, talvez seja melhor identificar o user por outro meio.

map<string, array<string, 2>> usuarios;

int command = MENU_INICIAL;

void main_menu() {

    lerUsuarios();
    salvarUsuarios();

    menu_inicial();
    while (true) {
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
            exit(0);
          default:
            cout << "Opção inválida";
            command = MENU_INICIAL;
        }
        fflush(stdin);
    }
}

// Estranho, mas é padrão: http://www.cplusplus.com/articles/4z18T05o/
void limparTela() {
  int n;
  for (n = 0; n < 10; n++) {
    cout << "\n\n\n\n\n\n\n\n\n\n";
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
}

// Checa se o usuário está logado
bool esta_logado () {
  return !username.empty() && !password.empty();
}

void menu_login() {

    if (esta_logado()){
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
        usrtipo = 0;
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

    if (!esta_logado) {
        cout << "Usuário não está logado!";
        return;
    }

    while (true) {
        int command;

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

    if (!esta_logado) {
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

    if (!esta_logado) {
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

        if (command == 4) {
            //username = "";
            //password = "";
            break;
        }

        // TODO issue #4
    }
}

void salvarUsuarios() {
  // Ponteiro para arquivo
  fstream fout;

  // Esvaziar conteúdo do arquivo de usuário antes de preenchê-lo novamente
  esvaziarArquivo("usuarios.csv");

  // Abre um arquivo .csv ou cria um se necessário
  fout.open("usuarios.csv", ios::out | ios::app);

  map<string, array<string, 2>>::iterator it;

  for(it = usuarios.begin(); it != usuarios.end(); it++){
    fout << it->first << ","
         << it->second[0] << ","
         << it->second[1] << "\n";
  }
}

// Esvazia qualquer arquivo .csv
void esvaziarArquivo(string nomeArquivo) {
  ofstream ofs;
  ofs.open(nomeArquivo, std::ofstream::out | std::ofstream::trunc);
  ofs.close();
}

void lerUsuarios() {

  // Ponteiro para o arquivo
  ifstream file;

  // Abrir arquivo existente
  file.open("usuarios.csv");

  string username, password, type;

  while (file.peek() != EOF) {
    getline(file, username, ',');
    getline(file, password, ',');
    getline(file, type, '\n');

    usuarios.insert(pair<string, array<string, 2>>(username, {password, type}));
  }

  file.close();

}
