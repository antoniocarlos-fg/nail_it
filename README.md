# Nail It!

Aplicativo mobile para organizar e acompanhar uma coleção pessoal de esmaltes, desenvolvido com **Flutter** e **Dart** como projeto acadêmico.

## Sobre

O Nail It! ajuda quem gosta de esmaltes a consultar um catálogo, controlar os itens da própria coleção, acompanhar o estado de uso e manter uma lista de desejos.

## Funcionalidades

- Cadastro e login de usuários.
- Consulta de recuperação de senha: valida o formato do e-mail e verifica se há uma conta correspondente. O envio de instruções e a redefinição da senha ainda não estão disponíveis, pois dependem de um back-end.
- Pesquisa do catálogo por nome ou marca e cadastro manual de esmaltes.
- Adição de esmaltes ao estoque pessoal, com opção de alterar o estado de uso ou remover itens.
- Wishlist de esmaltes.
- Perfil com visualização e atualização dos dados do usuário.
- Tela com informações sobre o projeto e a equipe.

Os estados de uso disponíveis são **Novo**, **Usando** e **Acabando**.

### Armazenamento nesta etapa

A manutenção local dos dados é temporária: contas, alterações no catálogo, estoques e wishlist ficam somente na memória durante a execução do aplicativo. Os dados são perdidos ao fechar o app. Uma etapa futura poderá adicionar persistência adequada.

### Próximos passos

- Integrar a pesquisa à [API do Mercado Livre](https://developers.mercadolivre.com.br/), para consultar esmaltes e permitir adicioná-los ao estoque ou à wishlist.
- Implementar recuperação e redefinição de senha com suporte de um back-end.
- Persistir os dados entre execuções do aplicativo.

## Desenvolvedores

- [Daniel Santana](https://github.com/daniel-zip)
- [Antonio Carlos](https://github.com/antoniocarlos-fg)

## Tecnologias

- [Flutter](https://flutter.dev/) e Dart.
- Provider e `ChangeNotifier` para gerenciamento de estado.
- Material Design para os componentes da interface.

## Executar o projeto

É necessário ter o Flutter SDK instalado. Clone o repositório, instale as dependências e execute o app:

```bash
git clone https://github.com/antoniocarlos-fg/nail_it.git
cd nail_it
flutter pub get
flutter run
```

## Contexto acadêmico

Projeto prático da disciplina de **Programação para Dispositivos Móveis**, do curso de Tecnologia em Análise e Desenvolvimento de Sistemas da Fatec Ribeirão Preto.

## Licença

Este projeto tem finalidade acadêmica e educacional.
