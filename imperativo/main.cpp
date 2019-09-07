#include <iostream>
#include <stdio.h>
#include <stdlib.h>
#include <string>
#include <map>
#include <vector>

using namespace std;

enum Estado {matricula = 1, emcurso = 2, fimdeperiodo = 3};
enum ComandoPrincipais {MENU_INICIAL, LOGAR, SAIR};
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

int main() {
    // TODO  Implementar o código que carrega todos os dados cadastrados no CSV;
    // a ideia é de otimizar a permanencia de dados, mas inves de manipular arquivos diretamente(processo
    // altamente custoso), fazemos isso apenas duas vezes: no início e final da execução do programa.

    // TODO issue #5 (carregar disciplinas)

    main_menu();

    // TODO  Implementar o código que armazena/atualiza os dados da estrutura de dados no arquivo CSV;
    return 0;
}

int usrtipo = 0; // alterar para 0 depois
string username = "";
string password = "";

//Users é um array de arrays, onde os arrays mais internos tem 3 posições, nome, senha e tipo, mas o plano é
//guardar também matricula, e talvez um array com as cadeiras que ele já pagou, ou um apontador pra elas.
//Inicie ele com poucas posições para testar, mas a gente pode aumentar ou diminur se necessário.
//Lembrando que estou utilizando username como identificador, talvez seja melhor identificar o user por outro meio.

/* Penso que seja melhor usarmos um vector (array dinâmico) para guardar os usuários,
   sendo mais eficiente para memória e retirando limites de tamanho de arrays */
vector <array<string, 3>> users = {
  {"joao", "123", "coordenador"},
  {"jose", "321", "professor"},
  {"jonas", "456", "aluno"}
};

int command = MENU_INICIAL;

void main_menu() {

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
                cout << "Usuário inválido! " << usrtipo;
            }
            break;
          case SAIR:
            cout << "saindo...\n";
            exit(0);
          default:
            cout << "Opção inválida";
        }
        fflush(stdin);
        command = MENU_INICIAL;
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
    cout << "\n| ----------------------------------------------- |\n";
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
        return;
    }

    atualiza_tipo_de_usuario(username);

}

//Bem simples, só checando se o usuario existe no array de usuarios, e se ele existir, checando se a senha corresponde.
bool valida_usuario(string username, string password) {
    for(vector<array<string, 3>>::size_type i = 0; i != users.size(); i++){
        if(users[i][0].compare(username)==0){
            if(users[i][1].compare(password)==0){
                return true;
            }else{
                cout << "Senha inválida.";
                return false;
            }
        }
    }
    return false;
}

//Bem simplificado, somente a checagem do tipo em string e atribuindo o usrtipo ao numero equivalente.
void atualiza_tipo_de_usuario(string username) {
   for(vector<array<string, 3>>::size_type i = 0; i != users.size(); i++){
      if(users[i][0].compare(username) == 0) {
          if(users[i][2].compare("aluno") == 0){
              usrtipo = ALUNO;
          }
          else if(users[i][2].compare("professor") == 0){
              usrtipo = PROFESSOR;
          }
          else if(users[i][2].compare("coordenador") == 0){
              usrtipo = COORDENADOR;
          }
          return;
      }
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
            username = "";
            password = "";
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
            username = "";
            password = "";
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
            username = "";
            password = "";
            break;
        }

        // TODO issue #4
    }
}
