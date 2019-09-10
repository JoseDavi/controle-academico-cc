#include <map>

using namespace std;

void esvaziarArquivo(string nomeArquivo);

void salvarUsuarios(map<string, array<string, 2>> usuarios);
map<string, array<string, 2>> lerUsuarios();

void salvarDisciplinas(map<string, string> disciplinas);
map<string, string> lerDisciplinas();

// Definição do estado de um aluno em uma disciplina
typedef struct DisciplinaEmAluno {
  int faltas = 0;
  double notas[3];
  // estado (em curso, concluída, trancada)
  string estado = "";
} DisciplinaEmAluno;

// Definição do tipo aluno
typedef struct Aluno {
  string matricula = "";
  string nome = "";
  bool esta_desvinculado = 0;
  // Codigo de disciplina - struct do estado do aluno
  map<string, DisciplinaEmAluno> historico;
} Aluno;

void salvarAlunos(map<string, Aluno> alunos);
map<string, Aluno> lerAlunos();
