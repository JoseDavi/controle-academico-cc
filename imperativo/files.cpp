#include <fstream>
#include <iostream>
#include <algorithm>

#include "files.h"
#include "util.h"

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

map<string, Aluno> lerAlunos() {

    // Disciplinas que serão lidas
    map<string, Aluno> alunos;

    // Ponteiro para o arquivo
    ifstream file;

    // Abrir arquivo existente
    file.open("resources/alunos.csv");

    string matricula, nome, esta_desvinculado;
    string disciplina, codDisciplina, estado;
    int faltas;
    double notas[3];

    Aluno al;
    DisciplinaEmAluno disc;

    while (file.peek() != EOF) {
      getline(file, matricula, ',');
      getline(file, nome, ',');
      getline(file, esta_desvinculado, ',');
      getline(file, disciplina, '\n');

      // Modificando primeiros atributos de aluno
      al.matricula = matricula;
      al.nome = nome;
      al.esta_desvinculado = (esta_desvinculado == "1");

      // Processando a string de disciplinas
      disciplina.erase(std::remove(disciplina.begin(), disciplina.end(), '['), disciplina.end());
      disciplina.erase(std::remove(disciplina.begin(), disciplina.end(), ']'), disciplina.end());

      map <string, DisciplinaEmAluno> historico;

      vector<string> disciplinas = split(disciplina, '+');

      for(std::size_t i=0; i<disciplinas.size(); i++) {
        vector<string> disciplinaInfo = split(disciplinas[i], ';');

        disc.faltas = std::stoi(disciplinaInfo[1]);
        disc.notas[0] = std::stod(disciplinaInfo[2]);
        disc.notas[1] = std::stod(disciplinaInfo[3]);
        disc.notas[2] = std::stod(disciplinaInfo[4]);
        disc.estado = disciplinaInfo[5];

        historico[disciplinaInfo[0]] = disc;
      }

      al.historico = historico;

      // Limpando o histórico para o próximo aluno
      historico.clear();

      alunos.insert({matricula, al});
    }

    file.close();

    return alunos;
}
