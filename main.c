#include<stdio.h>
#include<stdlib.h>
#include<string.h>

enum estado {matricula = 1, emcurso = 2, fimdeperiodo = 3};

struct aluno {
    char username[100];
    char password[16];
    int desvinculado;
};


struct professor {
    char username[100];
    char password[16];
};


struct coordenador {
    char username[100];
    char password[16];
};


struct disciplina {
    char name[100];
    int id;
    int numerodealunos;
    int prerequisitos[];
};


struct usuario {
    char username[100];
    char password[16];
    int tipo; //{aluno = 1, professor = 2, coordenador = 3};
};


int menuinicial() {
    printf("\n| ------------ Controle Academico CC ------------ |\n\n");
    printf("1) Logar \n");
    printf("2) Sair\n");
    printf("\n| ----------------------------------------------- |\n");
    int entrada;
    scanf("%d", &entrada);
    return entrada;
}


struct usuario* menulogin() {
    char username[100];
    char password[16];
    printf("username: \n");
    scanf("%s", username);
    printf("password: \n");
    scanf("%s", password);

    // TODO 01 - implementar uma subrotina que valide o username e password do arquivo usuarios.csv,
    // se for válido colocar o tipo de usuario (1 - aluno, 2 - professor, 3 - coordenador), se for invalido
    // colocar -1 para indicar que o usuário não está cadastrado no sistema.
    struct usuario* usr = {username, password, 2};
    return usr;
}


// TODO 02 - implementar o menu que lida com o aluno, deve conter as seguintes funcionalidades: 
// realizar Matrícula, trancar Disciplina, trancar Curso, ver Disciplina, ver Histórico
void menualuno() {
    printf("TODO: show the aluno menu\n");
}


// TODO 03 - implementar o menu que lida com o professor, deve conter as seguintes funcionalidades: 
// fazer Chamada , fechar Disciplina
void menuprofessor() {
    printf("TODO: show the professor menu\n");
}


// TODO 04 - implementar o menu que lida com o coordenador, deve conter as seguintes funcionalidades: 
// cadastrar Aluno, cadastrar Professor, aceitar Trancamento, recusar Trancamento
void menucoordenador() {
    printf("TODO: show the coordenador menu\n");
}


void mainmenu() {
    int command = menuinicial();
    while (1) {

        //printf("command: %d\n", command);

        if (command == 0) {
            command = menuinicial();
        }

        if (command == 2) {
            printf("quit...\n");
            exit(0);
        } 
        
        if (command == 1) {
            struct usuario* usr = menulogin();
            int tipo = usr->tipo;

            // TODO 07 - descobrir o bug que está fazendo que a estrutura usr fique vazia.
            printf("name: %s\n", usr->username);
            printf("pass: %s\n", usr->password);
            printf("tipo: %d\n", usr->tipo);

            if (tipo == 1) {
                menualuno();
            } else if (tipo == 2) {
                menuprofessor();
            } else if (tipo == 3) {
                menucoordenador();
            } else {
                // command = 0; // vai para tela inicial...
            }
        }

        if (command < 1 || command > 2) {
            printf("insert a valid command...\n");
        }
        command = 0; // remover depois
    }
}


void main() {
    // TODO 05 - Implementar o código que carrega todos os dados cadastrados no CSV;
    // a ideia é de otimizar a permanencia de dados, mas inves de manipular arquivos diretamente(processo
    // altamente custoso), fazemos isso apenas duas vezes: no início e final da execução do programa.
    
    mainmenu();

    // TODO 06 - Implementar o código que armazena/atualiza os dados da estrutura de dados no arquivo CSV;
}


