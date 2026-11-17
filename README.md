# Nail It!

Aplicativo desenvolvido com **Flutter** e **Dart** para organizar e acompanhar uma coleção pessoal de esmaltes, com autenticação e persistência em nuvem via **Google Firebase**.

> 🇬🇧 *An app built with **Flutter** and **Dart** to organize and track a personal nail polish collection, featuring authentication and cloud persistence powered by **Google Firebase**. Please note that the app and documentation are written in Portuguese for academic purposes.*

> **Versão Web:** [nail-it-5bcb4.web.app](https://nail-it-5bcb4.web.app)

## Sobre

O **Nail It!** ajuda quem gosta de esmaltes a pesquisar produtos reais, cadastrar itens personalizados, controlar o estoque da própria coleção, acompanhar o estado de uso e manter uma lista de desejos sincronizada na nuvem.

## Funcionalidades

- **Autenticação e Conta (Firebase Auth):**
  - Cadastro de novos usuários com e-mail e senha.
  - Login com feedback de carregamento e tratamento de erros.
  - Recuperação e redefinição de senha via envio de e-mail.
- **Pesquisa e Catálogo:**
  - Busca de esmaltes reais integrada à **API da VTEX (Ikesaki)** via HTTP.
  - Cadastro manual de esmaltes no catálogo pessoal do usuário.
- **Estoque Pessoal:**
  - Adição de esmaltes ao inventário.
  - Acompanhamento e alteração do estado de uso: **Novo**, **Usando** e **Acabando**.
  - Busca local e remoção de itens do estoque.
- **Wishlist:**
  - Lista de desejos vinculada ao usuário.
- **Perfil e Informações:**
  - Visualização e atualização dos dados cadastrais do usuário no Cloud Firestore.
  - Tela com informações sobre o projeto e a equipe.

## Persistência e Segurança

Os dados são armazenados no **Cloud Firestore** em tempo real (`StreamBuilder`) e isolados por usuário autenticado (`uid`), distribuídos nas coleções:

- `usuarios` — dados cadastrais do perfil.
- `estoque` — itens da coleção pessoal e seus estados de uso.
- `wishlist` — lista de desejos do usuário.
- `catalogo_pessoal` — esmaltes cadastrados manualmente pelo usuário.

O acesso às coleções é protegido por **Firestore Security Rules**, garantindo que cada usuário leia e modifique apenas os próprios documentos.

## Tecnologias

- [Flutter](https://flutter.dev/) e Dart
- [Firebase Authentication](https://firebase.google.com/docs/auth), [Cloud Firestore](https://firebase.google.com/docs/firestore) e [Firebase Hosting](https://firebase.google.com/docs/hosting)
- [Provider](https://pub.dev/packages/provider) (`ChangeNotifier`) para gerenciamento de estado
- [http](https://pub.dev/packages/http) para integração com a API da VTEX
- [get_it](https://pub.dev/packages/get_it)
- Material Design

## Executar o projeto

É necessário ter o Flutter SDK instalado. Clone o repositório, instale as dependências e execute o app:

```bash
git clone https://github.com/antoniocarlos-fg/nail_it.git
cd nail_it
flutter pub get
flutter run
```

Para gerar o build Web:

```bash
flutter build web
```

## Desenvolvedores

- [Daniel Santana](https://github.com/daniel-zip)
- [Antonio Carlos](https://github.com/antoniocarlos-fg)

## Contexto acadêmico

Projeto prático da disciplina de **Programação para Dispositivos Móveis**, do curso de Tecnologia em Análise e Desenvolvimento de Sistemas da **Fatec Ribeirão Preto**.

## Licença

Este projeto está licenciado sob a **Licença MIT** — consulte o arquivo [LICENSE](LICENSE) para mais detalhes.