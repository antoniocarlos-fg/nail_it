import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import '../models/usuario.dart';

/// Exceção de domínio com mensagem amigável para exibir na UI.
class UsuarioAuthException implements Exception {
  final String mensagem;
  const UsuarioAuthException(this.mensagem);

  @override
  String toString() => mensagem;
}

class UsuarioRepository {
  UsuarioRepository._();

  static const int nomeMinimoCaracteres = 3;

  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final CollectionReference<Map<String, dynamic>> _colecaoUsuarios =
      FirebaseFirestore.instance.collection('usuarios');

  /// Usuário autenticado; notifica telas quando o perfil ou a sessão muda.
  static final ValueNotifier<Usuario?> usuarioAtual = ValueNotifier(null);

  static String _traduzirErroAuth(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return 'O e-mail informado é inválido.';
      case 'user-disabled':
        return 'Esta conta foi desativada.';
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return 'E-mail ou senha incorretos.';
      case 'email-already-in-use':
        return 'Já existe uma conta cadastrada com este e-mail.';
      case 'weak-password':
        return 'A senha é muito fraca. Use pelo menos 6 caracteres.';
      case 'too-many-requests':
        return 'Muitas tentativas seguidas. Aguarde alguns instantes.';
      case 'requires-recent-login':
        return 'Por segurança, faça login novamente antes de alterar a senha.';
      case 'network-request-failed':
        return 'Sem conexão com a internet. Verifique sua rede.';
      default:
        return 'Erro na autenticação (${e.code}). Tente novamente.';
    }
  }

  /// Carrega o perfil do usuário já logado no Firebase Auth (ex.: ao reabrir o app).
  static Future<void> carregarSessaoAtual() async {
    final user = _auth.currentUser;
    if (user == null) {
      usuarioAtual.value = null;
      return;
    }

    try {
      final doc = await _colecaoUsuarios.doc(user.uid).get();
      if (doc.exists && doc.data() != null) {
        usuarioAtual.value = Usuario.fromMap(user.uid, doc.data()!);
      } else {
        usuarioAtual.value = Usuario(
          uid: user.uid,
          nome: user.displayName ?? 'Pessoa',
          email: user.email ?? '',
          telefone: '',
        );
      }
    } catch (_) {
      usuarioAtual.value = Usuario(
        uid: user.uid,
        nome: user.displayName ?? 'Pessoa',
        email: user.email ?? '',
        telefone: '',
      );
    }
  }

  /// Cadastra no Firebase Auth e salva os dados adicionais na coleção `usuarios`.
  static Future<Usuario> cadastrar({
    required String nome,
    required String email,
    required String telefone,
    required String senha,
  }) async {
    try {
      final credencial = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: senha,
      );

      final user = credencial.user!;
      await user.updateDisplayName(nome.trim());

      final usuario = Usuario(
        uid: user.uid,
        nome: nome.trim(),
        email: email.trim(),
        telefone: telefone,
      );

      await _colecaoUsuarios.doc(user.uid).set({
        ...usuario.toMap(),
        'criadoEm': FieldValue.serverTimestamp(),
      });

      usuarioAtual.value = usuario;
      return usuario;
    } on FirebaseAuthException catch (e) {
      throw UsuarioAuthException(_traduzirErroAuth(e));
    } on FirebaseException {
      throw const UsuarioAuthException(
        'Não foi possível salvar os dados do usuário no Firestore.',
      );
    }
  }

  /// Autentica no Firebase Auth e carrega o perfil do Firestore.
  static Future<Usuario> autenticar(String email, String senha) async {
    try {
      final credencial = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: senha,
      );

      final user = credencial.user!;
      final doc = await _colecaoUsuarios.doc(user.uid).get();

      final usuario = (doc.exists && doc.data() != null)
          ? Usuario.fromMap(user.uid, doc.data()!)
          : Usuario(
              uid: user.uid,
              nome: user.displayName ?? 'Pessoa',
              email: user.email ?? email.trim(),
              telefone: '',
            );

      usuarioAtual.value = usuario;
      return usuario;
    } on FirebaseAuthException catch (e) {
      throw UsuarioAuthException(_traduzirErroAuth(e));
    } on FirebaseException {
      throw const UsuarioAuthException(
        'Erro ao carregar os dados do perfil. Tente novamente.',
      );
    }
  }

  /// Envia e-mail de redefinição de senha pelo Firebase Auth.
  static Future<void> recuperarSenha(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException catch (e) {
      throw UsuarioAuthException(_traduzirErroAuth(e));
    }
  }

  static Future<void> sair() async {
    await _auth.signOut();
    usuarioAtual.value = null;
  }

  /// Atualiza nome no Firestore/Auth e, opcionalmente, a senha no Firebase Auth.
  static Future<void> atualizarPerfil({
    required String nome,
    String? senhaAtual,
    String? novaSenha,
  }) async {
    final user = _auth.currentUser;
    final atual = usuarioAtual.value;
    if (user == null || atual == null) {
      throw const UsuarioAuthException('Nenhum usuário logado.');
    }

    try {
      if (novaSenha != null && senhaAtual != null) {
        final credencial = EmailAuthProvider.credential(
          email: user.email!,
          password: senhaAtual,
        );
        await user.reauthenticateWithCredential(credencial);
        await user.updatePassword(novaSenha);
      }

      final nomeLimpo = nome.trim();
      await user.updateDisplayName(nomeLimpo);
      await _colecaoUsuarios.doc(user.uid).update({'nome': nomeLimpo});

      usuarioAtual.value = atual.copyWith(nome: nomeLimpo);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password' || e.code == 'invalid-credential') {
        throw const UsuarioAuthException('A senha atual está incorreta.');
      }
      throw UsuarioAuthException(_traduzirErroAuth(e));
    } on FirebaseException {
      throw const UsuarioAuthException(
        'Erro ao atualizar as informações no banco de dados.',
      );
    }
  }
}
