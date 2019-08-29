# Controle Acadêmico de Computação


## Objetivo

Desenvolver uma versão simplificada do controle academico online da UFCG em três paradigmas de programação diferentes: imperativa (C), funcional (haskell) e lógica (prolog).

## Descrição do Projeto

O Controle Acadêmico CC consiste em uma versão simplificada do Controle 
Acadêmico UFCG, onde os usuários (alunos, professores e coordenador) podem realizar funcionalidades básicas, como: se matricular em disciplinas, cadastrar alunos, atualizar faltas de uma turma, solicitar trancamento e etc.


## Requisitos Funcionais

### Aluno

**Um aluno pode...**

Se matricular em disciplinas (montar sua grade do semestre). Cada disciplina possui pre-requisitos, sendo possível a matrícula em uma disciplina se somente se os pre-requisitos desta forem satisfeitos.

Visualizar seu histórico: uma lista de disciplinas e suas respectivas notas, informações sobre o aluno e seu cra. 

Visualizar o status das disciplinas que estão sendo cursadas atualmente: ver o número de faltas e notas dos três estágios.

Solicitar o trancamento de uma disciplina.

Solicitar o trancamento do curso.



### Professor

**Um professor pode ...**


Atualizar  o número de faltas e notas dos três estágios dos seus alunos.

Fechar uma disciplina.


### Coordenador

**Um coordenador pode ...**

Criar a lista de disciplinas que serão ofertadas no próximo semestre.

Analizar solicitações de trancamento de curso ou de disciplinas.

Cadastrar Alunos e Professores.
