import 'dart:collection';
import 'package:flutter/foundation.dart';
import '../models/esmalte.dart';

class CatalogoProvider extends ChangeNotifier {
  final List<Esmalte> _catalogo = [
    Esmalte(nome: 'Vermelho Paixão', marca: 'Risqué', preco: 5.99),
    Esmalte(nome: 'Nude Cremoso', marca: 'Colorama', preco: 4.50),
    Esmalte(nome: 'Rosa Chiclete', marca: 'Dailus', preco: 6.90),
    Esmalte(nome: 'Vinho Intenso', marca: 'Risqué', preco: 5.99),
    Esmalte(nome: 'Azul Noite', marca: 'Impala', preco: 7.50),
    Esmalte(nome: 'Branco Neve', marca: 'Colorama', preco: 4.50),
  ];

  UnmodifiableListView<Esmalte> get catalogo => UnmodifiableListView(_catalogo);

  void adicionarEsmalte(Esmalte esmalte) {
    _catalogo.add(esmalte);
    notifyListeners();
  }
}
