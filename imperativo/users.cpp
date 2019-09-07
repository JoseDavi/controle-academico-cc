#include <fstream>

#include "users.h"

void salvarUsuarios(map<string, array<string, 2>> usuarios) {
  // Ponteiro para arquivo
  fstream fout;

  // Esvaziar conteúdo do arquivo de usuário antes de preenchê-lo novamente
  esvaziarArquivo("usuarios.csv");

  // Abre um arquivo .csv ou cria um se necessário
  fout.open("usuarios.csv", ios::out | ios::app);

  map<string, array<string, 2>>::iterator it;

  for(it = usuarios.begin(); it != usuarios.end(); it++){
    fout << it->first << ","
         << it->second[0] << ","
         << it->second[1] << "\n";
  }
}

void esvaziarArquivo(string nomeArquivo) {
  ofstream ofs;
  ofs.open(nomeArquivo, std::ofstream::out | std::ofstream::trunc);
  ofs.close();
}

map<string, array<string, 2>> lerUsuarios() {

  // Usuários que serão lidos
  map<string, array<string, 2>> usuarios;

  // Ponteiro para o arquivo
  ifstream file;

  // Abrir arquivo existente
  file.open("usuarios.csv");

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
