import 'package:flutter/foundation.dart';
import '../models/usuario.dart';

class UsuarioRepository {
  UsuarioRepository._();

  static const int nomeMinimoCaracteres = 3;

  static final Map<String, Usuario> _usuarios = {};

  /// Usuário autenticado; notifica telas quando o perfil ou a sessão muda.
  static final ValueNotifier<Usuario?> usuarioAtual = ValueNotifier(null);

  static String _chave(String email) => email.trim().toLowerCase();

  static bool emailExiste(String email) => _usuarios.containsKey(_chave(email));

  /// Cadastra e autentica o usuário; retorna false se o e-mail já existe.
  static bool cadastrar(Usuario usuario) {
    final chave = _chave(usuario.email);
    if (_usuarios.containsKey(chave)) return false;
    _usuarios[chave] = usuario;
    usuarioAtual.value = usuario;
    return true;
  }

  /// Autentica e retorna o usuário, ou null se as credenciais forem inválidas.
  static Usuario? autenticar(String email, String senha) {
    final usuario = _usuarios[_chave(email)];
    if (usuario != null && usuario.senha == senha) {
      usuarioAtual.value = usuario;
      return usuario;
    }
    return null;
  }

  static void sair() {
    usuarioAtual.value = null;
  }

  static bool senhaAtualConfere(String senha) {
    return usuarioAtual.value?.senha == senha;
  }

  /// Atualiza o perfil; retorna false se não houver sessão ativa.
  static bool atualizarPerfil({required String nome, String? novaSenha}) {
    final atual = usuarioAtual.value;
    if (atual == null) return false;

    final atualizado = atual.copyWith(nome: nome, senha: novaSenha);
    _usuarios[_chave(atual.email)] = atualizado;
    usuarioAtual.value = atualizado;
    return true;
  }
}
