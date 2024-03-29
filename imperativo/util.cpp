#include <limits>
#include <iostream>
#include <vector>
#include <sstream>

#include "util.h"

using namespace std;

// Padrão para limpar tela em terminal: http://www.cplusplus.com/articles/4z18T05o/
void limparTela() {
  int n;
  for (n = 0; n < 10; n++) {
    cout << "\n\n\n\n\n\n\n\n\n\n";
  }
}

// Verifica se o cin está em estado de falha e o recupera descartando os
// caracteres indesejados.
void testa_falha_cin() {
  if (cin.fail()){
     // get rid of failure state
     cin.clear();
     // discard 'bad' character(s)
     cin.ignore(std::numeric_limits<std::streamsize>::max(), '\n');
     // Error message
     cout << "Entrada inválida, por favor escolha um item do menu.";
     getchar();
  }
}

vector<string> split(const string& s, char delimiter) {
   vector<string> tokens;
   string token;
   istringstream tokenStream(s);
   while (getline(tokenStream, token, delimiter))
   {
      tokens.push_back(token);
   }
   return tokens;
}

void press_any_key() {
  cin.get();
  cin.ignore();
}
