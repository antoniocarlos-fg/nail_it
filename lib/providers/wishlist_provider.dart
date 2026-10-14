import 'dart:collection';
import 'package:flutter/foundation.dart';
import '../models/esmalte.dart';
import '../repositories/usuario_repository.dart';

class WishlistProvider extends ChangeNotifier {
  // Lista separada por usuário e mantida apenas durante a execução.
  final Map<String, List<Esmalte>> _wishlistsPorUsuario = {};

  WishlistProvider() {
    UsuarioRepository.usuarioAtual.addListener(_aoAlterarUsuario);
  }

  void _aoAlterarUsuario() => notifyListeners();

  List<Esmalte>? get _wishlistAtual {
    final email = UsuarioRepository.usuarioAtual.value?.email;
    if (email == null) return null;

    return _wishlistsPorUsuario.putIfAbsent(
      email.trim().toLowerCase(),
      () => <Esmalte>[],
    );
  }

  UnmodifiableListView<Esmalte> get wishlist =>
      UnmodifiableListView(_wishlistAtual ?? const <Esmalte>[]);

  bool possui(Esmalte esmalte) {
    return (_wishlistAtual ?? const <Esmalte>[]).any(
      (e) => e.nome == esmalte.nome && e.marca == esmalte.marca,
    );
  }

  bool adicionar(Esmalte esmalte) {
    final wishlist = _wishlistAtual;
    if (wishlist == null || possui(esmalte)) return false;

    wishlist.add(esmalte);
    notifyListeners();
    return true;
  }

  void remover(Esmalte esmalte) {
    final wishlist = _wishlistAtual;
    if (wishlist == null) return;

    wishlist.removeWhere(
      (e) => e.nome == esmalte.nome && e.marca == esmalte.marca,
    );
    notifyListeners();
  }

  @override
  void dispose() {
    UsuarioRepository.usuarioAtual.removeListener(_aoAlterarUsuario);
    super.dispose();
  }
}
