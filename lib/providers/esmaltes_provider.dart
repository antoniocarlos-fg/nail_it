import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/esmalte.dart';
import '../repositories/usuario_repository.dart';

class EsmaltesProvider extends ChangeNotifier {
  final CollectionReference<Map<String, dynamic>> _colecaoEstoque =
      FirebaseFirestore.instance.collection('estoque');

  String? get _uidAtual => UsuarioRepository.usuarioAtual.value?.uid;

  /// Stream em tempo real dos esmaltes do usuário logado para uso com StreamBuilder.
  Stream<QuerySnapshot<Map<String, dynamic>>>? streamDoUsuario() {
    final uid = _uidAtual;
    if (uid == null) return null;

    return _colecaoEstoque.where('uid', isEqualTo: uid).snapshots();
  }

  /// Adiciona uma nova instância do esmalte ao estoque do usuário no Firestore.
  /// Permite múltiplas instâncias do mesmo esmalte (ex.: frascos reserva).
  Future<void> adicionar(Esmalte esmalte) async {
    final uid = _uidAtual;
    if (uid == null) {
      throw Exception('Usuário não autenticado.');
    }

    final copia = esmalte.copiar();
    await _colecaoEstoque.add(copia.toMapEstoque(uid));
  }

  Future<void> remover(Esmalte esmalte) async {
    if (esmalte.id == null) {
      throw Exception('Identificador do esmalte não encontrado.');
    }

    await _colecaoEstoque.doc(esmalte.id).delete();
  }

  Future<void> alterarStatus(Esmalte esmalte, String novoStatus) async {
    if (esmalte.id == null) {
      throw Exception('Identificador do esmalte não encontrado.');
    }

    await _colecaoEstoque.doc(esmalte.id).update({'status': novoStatus});
    esmalte.status = novoStatus;
    notifyListeners();
  }
}
