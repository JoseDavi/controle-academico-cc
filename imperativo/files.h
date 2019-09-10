#include <map>

using namespace std;

// Definição de uma disciplina
typedef struct Disciplina {
  string codigo;
  string nome;
  int vagas = 0;
  string codigo_prerequisitos[2];
} Disciplina;

// Definição do estado de um aluno em uma disciplina
typedef struct DisciplinaEmAluno {
  string codigo;
  string nome;
  int faltas = 0;
  double notas[3];
  // estado (em curso, concluída, trancada)
  string estado = "";
} DisciplinaEmAluno;

// Definição do tipo aluno
typedef struct Aluno {
  string matricula = "";
  string nome = "";
  int disciplinas_matriculadas = 0;
  bool esta_desvinculado = 0;
  // Codigo de disciplina - struct do estado do aluno
  map<string, DisciplinaEmAluno> historico;
} Aluno;

void esvaziarArquivo(string nomeArquivo);

void salvarUsuarios(map<string, array<string, 3>> usuarios);
map<string, array<string, 3>> lerUsuarios();

void salvarDisciplinas(map<string, Disciplina> disciplinas);
map<string, Disciplina> lerDisciplinas();

void salvarAlunos(map<string, Aluno> alunos);
map<string, Aluno> lerAlunos();
