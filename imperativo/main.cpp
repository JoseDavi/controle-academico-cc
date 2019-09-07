#include <iostream>
#include <stdio.h>
#include <stdlib.h>
#include <string>
#include <map>
#include <vector>

using namespace std;

enum estado {matricula = 1, emcurso = 2, fimdeperiodo = 3};

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
string username;
string password;

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

int command = 0;

void main_menu() {

    menu_inicial();
    while (true) {
        if(command == 0){
          menu_inicial();
        }

        if (command == 2) {
            printf("quit...\n");
            exit(0);
        }

        if (command == 1) {
            menu_login();
            if (usrtipo == 1) {
                menu_aluno();
            } else if (usrtipo == 2) {
                menu_professor();
            } else if (usrtipo == 3) {
                menu_coordenador();
            } else {
                // command = 0; // vai para tela inicial...
            }
        }
        fflush(stdin);
        command = 0;
    }
}


void menu_inicial() {
    printf("\n| ------------ Controle Academico CC ------------ |\n\n");
    printf("1) Entrar \n");
    printf("2) Sair\n");
    printf("\n| ----------------------------------------------- |\n");
    scanf("%d", &command);
}


void menu_login() {

    if (!username.empty() && !password.empty()){
        return; // o usuário já esta logado.
    }

    string usr;
    printf("username: \n");
    cin >> usr;
    username = usr;

    string psw;
    printf("password: \n");
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
    for(int i = 0; i < 100;i++){
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
     for(int i = 0; i < 100;i++){
        if(users[i][0].compare(username)==0){
            if(users[i][2].compare("aluno")==0){
                usrtipo = 1;
            }
            else if(users[i][2].compare("professor")==0){
                usrtipo = 2;
            }
            else if(users[i][2].compare("coordenador") == 0){
                usrtipo = 3;
            }
            return;
        }
}
}


void menu_aluno() {

    if (username.empty() || password.empty()) {
        printf("INVALID USER !");
        return;
    }

    while (true) {
        int command;
        printf("\n| ------------ Controle Academico CC ------------ |\n");
        printf("aluno...\n\n");
        printf("1) Fazer Matrícula\n");
        printf("2) Trancar Disciplina\n");
        printf("3) Trancar Curso\n");
        printf("4) Ver Disciplina\n");
        printf("5) Ver Histórico\n");
        printf("6) Voltar...\n");
        printf("\n| ----------------------------------------------- |\n");
        scanf("%d", &command);

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

    if (username.empty() || password.empty()) {
        printf("INVALID USER !");
        return;
    }

    while (true) {
        printf("\n| ------------ Controle Academico CC ------------ |\n");
        printf("professor...\n\n");
        printf("1) Fazer Chamada\n");
        printf("2) Fechar Disciplina\n");
        printf("3) Inserir Notas\n");
        printf("4) Voltar...\n");
        printf("\n| ----------------------------------------------- |\n");
        scanf("%d", &command);

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

    if (username.empty() || password.empty()) {
        printf("INVALID USER !");
        return;
    }

    while (true) {
        printf("\n| ------------ Controle Academico CC ------------ |\n");
        printf("coordenador...\n\n");
        printf("1) Cadastrar Aluno\n");
        printf("2) Cadastrar Professor\n");
        printf("3) Analisar Trancamenos\n");
        printf("4) Voltar...\n");
        printf("\n| ----------------------------------------------- |\n");
        scanf("%d", &command);

        if (command == 4) {
            username = "";
            password = "";
            break;
        }

        // TODO issue #4
    }
}
