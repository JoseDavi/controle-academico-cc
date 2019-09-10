#include <map>

using namespace std;

void esvaziarArquivo(string nomeArquivo);

void salvarUsuarios(map<string, array<string, 2>> usuarios);
map<string, array<string, 2>> lerUsuarios();

void salvarDisciplinas(map<string, string> disciplinas);
map<string, string> lerDisciplinas();
