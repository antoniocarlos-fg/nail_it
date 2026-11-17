import 'package:cloud_firestore/cloud_firestore.dart';

class Esmalte {
  final String? id;
  final String nome;
  final String marca;
  final double preco;
  String status;

  Esmalte({
    this.id,
    required this.nome,
    required this.marca,
    required this.preco,
    this.status = 'Novo',
  });

  Esmalte copiar() {
    return Esmalte(
      nome: nome,
      marca: marca,
      preco: preco,
      status: status,
    );
  }

  /// Serialização para a coleção `estoque` (6 campos tipados).
  Map<String, dynamic> toMapEstoque(String uid) {
    return {
      'uid': uid,
      'nome': nome,
      'marca': marca,
      'preco': preco,
      'status': status,
      'criadoEm': FieldValue.serverTimestamp(),
    };
  }

  /// Serialização para a coleção `wishlist` (5 campos tipados).
  Map<String, dynamic> toMapWishlist(String uid) {
    return {
      'uid': uid,
      'nome': nome,
      'marca': marca,
      'preco': preco,
      'criadoEm': FieldValue.serverTimestamp(),
    };
  }

  factory Esmalte.fromMap(String id, Map<String, dynamic> map) {
    return Esmalte(
      id: id,
      nome: (map['nome'] ?? '') as String,
      marca: (map['marca'] ?? '') as String,
      preco: (map['preco'] as num?)?.toDouble() ?? 0.0,
      status: (map['status'] ?? 'Novo') as String,
    );
  }
}
