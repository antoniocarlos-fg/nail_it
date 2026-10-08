class Esmalte{
  final String nome;
  final String marca;
  final double preco;
  String status;

  Esmalte({
    required this.nome,
    required this.marca,
    required this.preco,
    this.status = 'Novo'
  });
}