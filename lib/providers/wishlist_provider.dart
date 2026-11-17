import 'dart:async';
import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/esmalte.dart';
import '../repositories/usuario_repository.dart';

class WishlistProvider extends ChangeNotifier {
  final CollectionReference<Map<String, dynamic>> _colecaoWishlist =
      FirebaseFirestore.instance.collection('wishlist');

  List<Esmalte> _itens = [];
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _assinatura;

  WishlistProvider() {
    UsuarioRepository.usuarioAtual.addListener(_aoAlterarUsuario);
    _aoAlterarUsuario();
  }

  String? get _uidAtual => UsuarioRepository.usuarioAtual.value?.uid;

  void _aoAlterarUsuario() {
    _assinatura?.cancel();
    final uid = _uidAtual;

    if (uid == null) {
      _itens = [];
      notifyListeners();
      return;
    }

    _assinatura = _colecaoWishlist
        .where('uid', isEqualTo: uid)
        .snapshots()
        .listen((snapshot) {
      _itens = snapshot.docs
          .map((doc) => Esmalte.fromMap(doc.id, doc.data()))
          .toList();
      notifyListeners();
    });
  }

  /// Stream em tempo real da wishlist do usuário logado para uso com StreamBuilder.
  Stream<QuerySnapshot<Map<String, dynamic>>>? streamDoUsuario() {
    final uid = _uidAtual;
    if (uid == null) return null;

    return _colecaoWishlist.where('uid', isEqualTo: uid).snapshots();
  }

  UnmodifiableListView<Esmalte> get wishlist => UnmodifiableListView(_itens);

  bool possui(Esmalte esmalte) {
    return _itens.any(
      (e) => e.nome == esmalte.nome && e.marca == esmalte.marca,
    );
  }

  Future<bool> adicionar(Esmalte esmalte) async {
    final uid = _uidAtual;
    if (uid == null) {
      throw Exception('Usuário não autenticado.');
    }

    if (possui(esmalte)) return false;

    await _colecaoWishlist.add(esmalte.toMapWishlist(uid));
    return true;
  }

  Future<void> remover(Esmalte esmalte) async {
    final uid = _uidAtual;
    if (uid == null) {
      throw Exception('Usuário não autenticado.');
    }

    if (esmalte.id != null) {
      await _colecaoWishlist.doc(esmalte.id).delete();
      return;
    }

    final snapshot = await _colecaoWishlist
        .where('uid', isEqualTo: uid)
        .where('nome', isEqualTo: esmalte.nome)
        .where('marca', isEqualTo: esmalte.marca)
        .get();

    for (final doc in snapshot.docs) {
      await doc.reference.delete();
    }
  }

  @override
  void dispose() {
    _assinatura?.cancel();
    UsuarioRepository.usuarioAtual.removeListener(_aoAlterarUsuario);
    super.dispose();
  }
}
