class Esmalte {
  final String nome;
  final String marca;
  final double preco;
  String status;

  Esmalte({
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
}
