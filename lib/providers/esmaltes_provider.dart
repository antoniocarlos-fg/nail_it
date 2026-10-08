import 'dart:collection';
import 'package:flutter/foundation.dart';
import '../models/esmalte.dart';

class EsmaltesProvider extends ChangeNotifier {
  final List<Esmalte> _esmaltes = [
    Esmalte(nome: 'Ruby', marca: 'Risqué', preco: 5.99, status: 'Novo'),
    Esmalte(nome: 'Nude', marca: 'Colorama', preco: 4.50, status: 'Usando'),
    Esmalte(nome: 'Pink', marca: 'Dailus', preco: 6.90, status: 'Acabando'),
    Esmalte(nome: 'Wine', marca: 'Impala', preco: 7.50, status: 'Novo'),
  ];

  // Leitura apenas: quem está fora não consegue alterar a lista direto,
  // só pelos métodos abaixo (que avisam as telas).
  UnmodifiableListView<Esmalte> get esmaltes =>
      UnmodifiableListView(_esmaltes);

  bool possui(Esmalte esmalte) {
    return _esmaltes.any(
      (e) => e.nome == esmalte.nome && e.marca == esmalte.marca,
    );
  }

  /// Retorna false se o esmalte já estiver no estoque.
  bool adicionar(Esmalte esmalte) {
    if (possui(esmalte)) return false;
    _esmaltes.add(esmalte);
    notifyListeners();
    return true;
  }

  void remover(Esmalte esmalte) {
    _esmaltes.remove(esmalte);
    notifyListeners();
  }

  void alterarStatus(Esmalte esmalte, String novoStatus) {
    esmalte.status = novoStatus;
    notifyListeners();
  }
}