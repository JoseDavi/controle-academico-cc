#include <fstream>

#include "files.h"

void esvaziarArquivo(string nomeArquivo) {
  ofstream ofs;
  ofs.open("resources/" + nomeArquivo, std::ofstream::out | std::ofstream::trunc);
  ofs.close();
}

void salvarUsuarios(map<string, array<string, 2>> usuarios) {
  // Ponteiro para arquivo
  fstream fout;

  // Esvaziar conteúdo do arquivo de usuário antes de preenchê-lo novamente
  esvaziarArquivo("usuarios.csv");

  // Abre um arquivo .csv ou cria um se necessário
  fout.open("resources/usuarios.csv", ios::out | ios::app);

  map<string, array<string, 2>>::iterator it;

  for(it = usuarios.begin(); it != usuarios.end(); it++){
    fout << it->first << ","
         << it->second[0] << ","
         << it->second[1] << "\n";
  }
}
map<string, array<string, 2>> lerUsuarios() {

  // Usuários que serão lidos
  map<string, array<string, 2>> usuarios;

  // Ponteiro para o arquivo
  ifstream file;

  // Abrir arquivo existente
  file.open("resources/usuarios.csv");

  string username, password, type;

  while (file.peek() != EOF) {
    getline(file, username, ',');
    getline(file, password, ',');
    getline(file, type, '\n');

    usuarios.insert(pair<string, array<string, 2>>(username, {password, type}));
  }

  file.close();

  return usuarios;
}

void salvarDisciplinas(map<string, string> disciplinas) {
  // Ponteiro para arquivo
  fstream fout;

  // Esvaziar conteúdo do arquivo de disciplinas antes de preenchê-lo novamente
  esvaziarArquivo("disciplinas.csv");

  // Abre um arquivo .csv ou cria um se necessário
  fout.open("resources/disciplinas.csv", ios::out | ios::app);

  map<string, string>::iterator it;

  for(it = disciplinas.begin(); it != disciplinas.end(); it++){
    fout << it->first << ","
         << it->second << "\n";
  }
}
map<string, string> lerDisciplinas() {

  // Disciplinas que serão lidas
  map<string, string> disciplinas;

  // Ponteiro para o arquivo
  ifstream file;

  // Abrir arquivo existente
  file.open("resources/disciplinas.csv");

  string code, name;

  while (file.peek() != EOF) {
    getline(file, code, ',');
    getline(file, name, '\n');

    disciplinas.insert(pair<string, string>(code, name));
  }

  file.close();

  return disciplinas;
}

void salvarAlunos(map<string, Aluno> alunos) {
  // Ponteiro para arquivo
  fstream fout;

  // Esvaziar conteúdo do arquivo de alunos antes de preenchê-lo novamente
  esvaziarArquivo("alunos.csv");

  // Abre um arquivo .csv ou cria um se necessário
  fout.open("resources/alunos.csv", ios::out | ios::app);

  map<string, Aluno>::iterator it;

  for(it = alunos.begin(); it != alunos.end(); it++){
    fout << it->first << ","
         << it->second.nome << ","
         << it->second.esta_desvinculado << ",";

    map<string, DisciplinaEmAluno> historico = it->second.historico;
    map<string, DisciplinaEmAluno>::iterator itHist;

    fout << "[";
    for (itHist = historico.begin(); itHist != historico.end(); itHist++) {
      fout << itHist->first << ";"
           << itHist->second.faltas << ";"
           << itHist->second.notas[0] << ";"
           << itHist->second.notas[1] << ";"
           << itHist->second.notas[2] << ";"
           << itHist->second.estado;
           if (next(itHist) != historico.end()) {
             fout << "+";
           }
    }
    fout << "]\n";
  }
}
