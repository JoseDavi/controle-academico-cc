#include <iostream>
#include <stdio.h>
#include <stdlib.h>
#include <string>
#include <map>

using namespace std;

enum estado {matricula = 1, emcurso = 2, fimdeperiodo = 3};

void mainmenu();
void menuinicial();
void menualuno();
void menuprofessor();
void menucoordenador();
bool validausuario(string username, string password);
void menulogin();


int main() {
    // TODO  Implementar o código que carrega todos os dados cadastrados no CSV;
    // a ideia é de otimizar a permanencia de dados, mas inves de manipular arquivos diretamente(processo
    // altamente custoso), fazemos isso apenas duas vezes: no início e final da execução do programa.
    
    // TODO issue #5 (carregar disciplinas)

    mainmenu();

    // TODO  Implementar o código que armazena/atualiza os dados da estrutura de dados no arquivo CSV;
    return 0;
}

int usrtipo = 1; // alterar para 0 depois
string username;
string password;

int command = 0;

void mainmenu() {
    menuinicial();
    while (true) {

        if (command == 0) {
            menuinicial();
        }

        if (command == 2) {
            printf("quit...\n");
            exit(0);
        } 
        
        if (command == 1) {
            menulogin();
            if (usrtipo == 1) {
                menualuno();
            } else if (usrtipo == 2) {
                menuprofessor();
            } else if (usrtipo == 3) {
                menucoordenador();
            } else {
                // command = 0; // vai para tela inicial...
            }
        }
        
        command = 0; 
    }
}


void menuinicial() {
    printf("\n| ------------ Controle Academico CC ------------ |\n\n");
    printf("1) Entrar \n");
    printf("2) Sair\n");
    printf("\n| ----------------------------------------------- |\n");
    scanf("%d", &command);
}


void menulogin() {

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

    if (!validausuario(username,password)) {
        username = "";
        password = "";
        return;
    }

    atualizatipodeusuario();
}


bool validausuario(string username, string password) {
    // TODO issue #1
    return true;
}


void atualizatipodeusuario() {
    // TODO issue #6
}


void menualuno() {

    if (username.empty() || password.empty()) {
        printf("INVALID USER !");
        return;
    }

    while (true) {
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
            break;
        }

        // TODO issue #2
    }
    
}


void menuprofessor() {
    
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
            break;
        }

        // TODO issue #3
    }
}


void menucoordenador() {
    
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
            break;
        }

        // TODO issue #4
    }
}