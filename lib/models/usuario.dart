class Usuario {
  final String uid;
  final String nome;
  final String email;
  final String telefone; // apenas dígitos, ex: 16999998888

  const Usuario({
    required this.uid,
    required this.nome,
    required this.email,
    required this.telefone,
  });

  /// Copia o usuário alterando nome ou telefone.
  Usuario copyWith({String? nome, String? telefone}) {
    return Usuario(
      uid: uid,
      nome: nome ?? this.nome,
      email: email,
      telefone: telefone ?? this.telefone,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'nome': nome,
      'email': email,
      'telefone': telefone,
    };
  }

  factory Usuario.fromMap(String uid, Map<String, dynamic> map) {
    return Usuario(
      uid: uid,
      nome: (map['nome'] ?? '') as String,
      email: (map['email'] ?? '') as String,
      telefone: (map['telefone'] ?? '') as String,
    );
  }
}
