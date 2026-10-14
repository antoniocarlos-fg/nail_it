class Usuario {
  final String nome;
  final String email;
  final String telefone; // apenas dígitos, ex: 16999998888
  final String senha;

  const Usuario({
    required this.nome,
    required this.email,
    required this.telefone,
    required this.senha,
  });

  /// Copia o usuário alterando nome ou senha.
  Usuario copyWith({String? nome, String? senha}) {
    return Usuario(
      nome: nome ?? this.nome,
      email: email,
      telefone: telefone,
      senha: senha ?? this.senha,
    );
  }
}
