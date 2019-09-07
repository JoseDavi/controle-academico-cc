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
void atualizatipodeusuario(string username);


int main() {
    // TODO  Implementar o código que carrega todos os dados cadastrados no CSV;
    // a ideia é de otimizar a permanencia de dados, mas inves de manipular arquivos diretamente(processo
    // altamente custoso), fazemos isso apenas duas vezes: no início e final da execução do programa.
    
    // TODO issue #5 (carregar disciplinas)

    mainmenu();

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
string users[100][3];
int command = 0;
void mainmenu() {
//Coloquei aqui dentro do metodo de validação somente para testar a implementação, não pensei num jeito
//de puxar os users lá do main sem ficar sempre mandando o array, o que achei que não ia ficar muito legal.

// user teste 1, joao com senha 123, coordenador.
users[0][0] = "joao";
users[0][1] = "123";
users[0][2] = "coordenador";
// user teste 2, jose com senha 321, professor.
users[1][0] = "jose";
users[1][1] = "321";
users[1][2] = "professor";
//user teste 3, jonas com senha 456, aluno.
users[2][0] = "jonas";
users[2][1] = "456";
users[2][2] = "aluno";

    menuinicial();
    while (true) {
        if(command == 0){
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
        fflush(stdin);
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
    atualizatipodeusuario(username);

}

//Bem simples, só checando se o usuario existe no array de usuarios, e se ele existir, checando se a senha corresponde.
bool validausuario(string username, string password) {
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
void atualizatipodeusuario(string username) {
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


void menualuno() {

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
            username = "";
            password = "";
            break;
        }

        // TODO issue #3
    }
    return;
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
            username = "";
            password = "";
            break;
        }

        // TODO issue #4
    }
}