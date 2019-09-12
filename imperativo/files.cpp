#include <fstream>
#include <iostream>
#include <algorithm>
#include <vector>
#include "files.h"
#include "util.h"

void esvaziarArquivo(string nomeArquivo) {
  ofstream ofs;
  ofs.open("resources/" + nomeArquivo, std::ofstream::out | std::ofstream::trunc);
  ofs.close();
}

void salvarUsuarios(map<string, array<string, 3>> usuarios) {
  // Ponteiro para arquivo
  fstream fout;

  // Esvaziar conteúdo do arquivo de usuário antes de preenchê-lo novamente
  esvaziarArquivo("usuarios.csv");

  // Abre um arquivo .csv ou cria um se necessário
  fout.open("resources/usuarios.csv", ios::out | ios::app);

  map<string, array<string, 3>>::iterator it;

  for(it = usuarios.begin(); it != usuarios.end(); it++){
    fout << it->first << ","
         << it->second[0] << ","
         << it->second[1] << ","
         << it->second[2] << "\n";
  }
}
map<string, array<string, 3>> lerUsuarios() {

  // Usuários que serão lidos
  map<string, array<string, 3>> usuarios;

  // Ponteiro para o arquivo
  ifstream file;

  // Abrir arquivo existente
  file.open("resources/usuarios.csv");

  string username, password, type, name;

  while (file.peek() != EOF) {
    getline(file, username, ',');
    getline(file, password, ',');
    getline(file, name, ',');
    getline(file, type, '\n');

    usuarios.insert(pair<string, array<string, 3>>(username, {password, type, name}));
  }

  file.close();

  return usuarios;
}

void salvarDisciplinas(map<string, Disciplina> disciplinas) {
  // Ponteiro para arquivo
  fstream fout;

  // Esvaziar conteúdo do arquivo de disciplinas antes de preenchê-lo novamente
  esvaziarArquivo("disciplinas.csv");

  // Abre um arquivo .csv ou cria um se necessário
  fout.open("resources/disciplinas.csv", ios::out | ios::app);

  map<string, Disciplina>::iterator it;

  for(it = disciplinas.begin(); it != disciplinas.end(); it++){
    fout << it->first << ","
         << it->second.nome << ","
         << to_string(it->second.vagas) << ","
         << it->second.codigo_prerequisitos[0] << ","
         << it->second.codigo_prerequisitos[1] << "\n";
  }
}
map<string, Disciplina> lerDisciplinas() {

  // Disciplinas que serão lidas
  map<string, Disciplina> disciplinas;

  // Ponteiro para o arquivo
  ifstream file;

  // Abrir arquivo existente
  file.open("resources/disciplinas.csv");

  string code, name, vagas, prerequisito1, prerequisito2;

  while (file.peek() != EOF) {
    getline(file, code, ',');
    getline(file, name, ',');
    getline(file, vagas, ',');
    getline(file, prerequisito1, ',');
    getline(file, prerequisito2, '\n');

    struct Disciplina disciplina;
    disciplina.codigo = code.c_str();
    disciplina.nome = name.c_str();
    disciplina.vagas = stoi(vagas.c_str());
    disciplina.codigo_prerequisitos[0] = prerequisito1;
    disciplina.codigo_prerequisitos[1] = prerequisito2.c_str();

    disciplinas.insert(pair<string, Disciplina>(code, disciplina));
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
         << it->second.disciplinas_matriculadas << ","
         << it->second.esta_desvinculado << ",";

    map<string, DisciplinaEmAluno> historico = it->second.historico;
    map<string, DisciplinaEmAluno>::iterator itHist;

    fout << "[";
    for (itHist = historico.begin(); itHist != historico.end(); itHist++) {
      fout << itHist->first << ";"
           << itHist->second.nome << ";"
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
    string disciplina, codDisciplina, estado, disciplinas_matriculadas;
    int faltas;
    double notas[3];

    Aluno al;
    DisciplinaEmAluno disc;

    while (file.peek() != EOF) {
      getline(file, matricula, ',');
      getline(file, nome, ',');
      getline(file, disciplinas_matriculadas, ',');
      getline(file, esta_desvinculado, ',');
      getline(file, disciplina, '\n');

      // Modificando primeiros atributos de aluno
      al.matricula = matricula;
      al.nome = nome;
      al.disciplinas_matriculadas = std::stoi(disciplinas_matriculadas);
      al.esta_desvinculado = (esta_desvinculado == "1");

      // Processando a string de disciplinas
      disciplina.erase(std::remove(disciplina.begin(), disciplina.end(), '['), disciplina.end());
      disciplina.erase(std::remove(disciplina.begin(), disciplina.end(), ']'), disciplina.end());

      map <string, DisciplinaEmAluno> historico;

      vector<string> disciplinas = split(disciplina, '+');

      for(std::size_t i=0; i<disciplinas.size(); i++) {
        vector<string> disciplinaInfo = split(disciplinas[i], ';');

        disc.codigo = disciplinaInfo[0];
        disc.nome = disciplinaInfo[1];
        disc.faltas = std::stoi(disciplinaInfo[2]);
        disc.notas[0] = std::stod(disciplinaInfo[3]);
        disc.notas[1] = std::stod(disciplinaInfo[4]);
        disc.notas[2] = std::stod(disciplinaInfo[5]);
        disc.estado = disciplinaInfo[6];

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

void salvarTrancamentos(vector<array <string, 2>> trancamentos) {
  // Ponteiro para arquivo
  fstream fout;

  // Esvaziar conteúdo do arquivo de trancamentos antes de preenchê-lo novamente
  esvaziarArquivo("trancamentos.csv");

  // Abre um arquivo .csv ou cria um se necessário
  fout.open("resources/trancamentos.csv", ios::out | ios::app);

  for(auto i = 0; i != trancamentos.size(); i++){
    fout << trancamentos[i][0] << ","
         << trancamentos[i][1] << "\n";
  }
}

vector<array<string,2>> lerTrancamentos() {

  // Trancamentos que serão lidas
  vector<array <string, 2>> trancamentos;

  // Ponteiro para o arquivo
  ifstream file;

  // Abrir arquivo existente
  file.open("resources/trancamentos.csv");

  string codDisciplina, matricula;
  while (file.peek() != EOF) {
    getline(file, codDisciplina, ',');
    getline(file, matricula, '\n');
    trancamentos.push_back({codDisciplina.c_str(), matricula.c_str()});

  }

  file.close();

  return trancamentos;
}

void salvarProfessor_Disciplina(vector<array <string, 2>> professor_disciplina) {

  fstream fout;

  esvaziarArquivo("professores_disciplinas.csv");

  fout.open("resources/professores_disciplinas.csv", ios::out | ios::app);

  for(auto i = 0; i != professor_disciplina.size(); i++){
    fout << professor_disciplina[i][0] << ","
         << professor_disciplina[i][1] << "\n";
  }
}

vector<array <string, 2>> lerProfessor_Disciplina() {

  vector<array <string, 2>> professores_disciplinas;

  ifstream file;

  file.open("resources/professores_disciplinas.csv");

  string nome, codigo;

  while (file.peek() != EOF) {
    getline(file, nome, ',');
    getline(file, codigo, '\n');

    professores_disciplinas.push_back({nome.c_str(), codigo.c_str()});
  }

  file.close();

  return professores_disciplinas;
}