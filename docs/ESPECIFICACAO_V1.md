# BINGÃO — Especificação V1

## 1. Objetivo

Criar uma plataforma de Bingo Online recreativo, composta por aplicativo do jogador, painel administrativo, servidor e banco de dados.

## 2. Bingo

- Bingo tradicional de 75 bolas.
- Cartela 5x5.
- Casa central livre.
- Números distribuídos nas colunas B-I-N-G-O.
- Histórico completo das bolas sorteadas.

## 3. Cartelas

- Cada cartela possui identificador único.
- O jogador poderá utilizar de 1 a 11 cartelas por rodada na V1.
- As cartelas ficam vinculadas ao jogador e à rodada.
- Após o início da rodada, as cartelas ficam bloqueadas.
- O aplicativo organiza as cartelas do jogador pela quantidade de acertos.

## 4. Modalidades

A V1 deverá permitir configurar:

- Linha
- Duas linhas
- Coluna
- Janelão
- Cruz
- Quatro cantos
- Cartela cheia

A modalidade será definida pelo administrador antes da rodada.

## 5. Empates

Se duas ou mais cartelas completarem uma modalidade na mesma bola:

- todas serão consideradas vencedoras;
- o sistema registrará todas as cartelas;
- o aplicativo mostrará a quantidade de vencedores simultâneos;
- os créditos virtuais da modalidade serão divididos entre os vencedores conforme a regra configurada.

## 6. Rodadas

Cada rodada terá:

- identificação única;
- data;
- horário;
- modalidade;
- participantes;
- cartelas;
- status;
- sequência de bolas;
- resultados.

Status possíveis:

- Agendada
- Aguardando mínimo
- Em andamento
- Pausada
- Encerrada
- Cancelada

## 7. Participantes

Não haverá limite comercial fixo de participantes.

A capacidade real dependerá da infraestrutura do servidor.

A rodada terá um número mínimo configurável de cartelas ou participantes para poder começar.

## 8. Início automático

A rodada poderá possuir data e horário programados.

Quando o horário chegar:

- se o mínimo for atingido, a rodada inicia automaticamente;
- se o mínimo não for atingido, a rodada não começa;
- os créditos virtuais reservados são devolvidos aos participantes.

## 9. Sorteio

Existirão dois modos:

### Automático

O sistema sorteia bolas automaticamente em intervalos configuráveis.

### Manual

O administrador controla cada sorteio.

O servidor será responsável pela sequência oficial das bolas.

Uma bola não poderá ser sorteada duas vezes na mesma rodada.

## 10. Aplicativo do jogador

O aplicativo deverá possuir:

- Login
- Cadastro
- Recuperação de acesso
- Tela inicial
- Minhas cartelas
- Salas
- Sala ao vivo
- Histórico
- Perfil
- Notificações
- Configurações

## 11. Cartelas no aplicativo

O jogador poderá:

- visualizar várias cartelas;
- deslizar entre cartelas;
- utilizar visualização compacta;
- ver a cartela com maior número de acertos primeiro;
- visualizar a quantidade de acertos;
- acompanhar o progresso das modalidades;
- escolher a cor de marcação.

Cores disponíveis inicialmente:

- Verde
- Azul
- Vermelho

## 12. Sala ao vivo

A sala deverá mostrar:

- bola atual;
- animação da bola;
- histórico das bolas;
- todas as bolas de 1 a 75;
- cartelas do jogador;
- quantidade de acertos;
- progresso;
- status da rodada;
- vencedores já registrados.

## 13. Áudio

O aplicativo poderá possuir:

- som do sorteio;
- voz anunciando a bola;
- vibração.

Cada recurso poderá ser ativado ou desativado pelo jogador.

## 14. Aparência

O aplicativo deverá possuir:

- modo claro;
- modo escuro;
- modo automático conforme o aparelho.

## 15. Animações

O sorteio deverá possuir animação visual da bola.

A animação não será responsável pela lógica do sorteio.

A sequência oficial será determinada pelo servidor.

## 16. Vencedores

Quando uma cartela vencer:

- o servidor valida a vitória;
- o jogador recebe uma notificação;
- o vencedor aparece para os demais participantes conforme as configurações;
- o administrador visualiza o vencedor no painel.

## 17. Ticket de vitória

Cada vitória gera um ticket único.

O ticket deverá possuir:

- identificador único;
- rodada;
- jogador;
- cartela;
- modalidade;
- quantidade de vencedores simultâneos;
- créditos virtuais;
- data e hora;
- QR Code;
- status.

O ticket será validado pelo servidor.

Possíveis estados:

- Pendente
- Conferido
- Inválido
- Já utilizado

## 18. Painel administrativo

O administrador poderá:

- criar rodadas;
- programar horários;
- configurar modalidades;
- configurar mínimo;
- visualizar participantes;
- visualizar cartelas;
- iniciar rodada;
- pausar;
- continuar;
- encerrar;
- controlar sorteio;
- visualizar bolas sorteadas;
- consultar vencedores;
- conferir tickets;
- consultar histórico.

## 19. Modo de teste

O sistema terá um modo de teste separado das partidas normais.

O administrador poderá testar:

- sorteio;
- cartelas;
- vitórias;
- empates;
- tickets;
- reconexão;
- modalidades.

## 20. Reconexão

Se o jogador perder a conexão:

- o aplicativo informará a desconexão;
- tentará reconectar automaticamente;
- recuperará os eventos perdidos;
- sincronizará novamente a rodada.

## 21. Segurança

O servidor será responsável pela validação de:

- cartelas;
- sorteios;
- vitórias;
- tickets;
- créditos virtuais;
- permissões administrativas.

O aplicativo não poderá alterar dados oficiais da partida.

## 22. Créditos

A V1 utilizará créditos exclusivamente virtuais, sem implementação de conversão para dinheiro, pagamentos ou saques.

## 23. Arquitetura

Componentes principais:

- Aplicativo do jogador
- Painel administrativo
- API/Servidor
- Banco de dados
- Comunicação em tempo real

## 24. Identidade

Nome do projeto:

BINGÃO

Nome poderá ser alterado futuramente sem alterar a arquitetura interna.
