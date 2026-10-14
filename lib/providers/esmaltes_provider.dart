import 'dart:collection';
import 'package:flutter/foundation.dart';
import '../models/esmalte.dart';
import '../repositories/usuario_repository.dart';

class EsmaltesProvider extends ChangeNotifier {
  // Estoques separados por usuário, mantidos apenas durante a execução.
  final Map<String, List<Esmalte>> _estoquesPorUsuario = {};

  EsmaltesProvider() {
    UsuarioRepository.usuarioAtual.addListener(_aoAlterarUsuario);
  }

  void _aoAlterarUsuario() => notifyListeners();

  List<Esmalte>? get _estoqueAtual {
    final email = UsuarioRepository.usuarioAtual.value?.email;
    if (email == null) return null;

    return _estoquesPorUsuario.putIfAbsent(
      email.trim().toLowerCase(),
      () => <Esmalte>[],
    );
  }

  // Exposição somente leitura; alterações passam pelos métodos abaixo.
  UnmodifiableListView<Esmalte> get esmaltes =>
      UnmodifiableListView(_estoqueAtual ?? const <Esmalte>[]);

  bool possui(Esmalte esmalte) {
    return (_estoqueAtual ?? const <Esmalte>[]).any(
      (e) => e.nome == esmalte.nome && e.marca == esmalte.marca,
    );
  }

  /// Cria uma cópia independente do item do catálogo para o estoque.
  void adicionar(Esmalte esmalte) {
    final estoque = _estoqueAtual;
    if (estoque == null) return;

    estoque.add(esmalte.copiar());
    notifyListeners();
  }

  void remover(Esmalte esmalte) {
    final estoque = _estoqueAtual;
    if (estoque == null) return;

    esmalte.status = "Novo";
    estoque.remove(esmalte);
    notifyListeners();
  }

  void alterarStatus(Esmalte esmalte, String novoStatus) {
    if (_estoqueAtual == null) return;

    esmalte.status = novoStatus;
    notifyListeners();
  }

  @override
  void dispose() {
    UsuarioRepository.usuarioAtual.removeListener(_aoAlterarUsuario);
    super.dispose();
  }
}
