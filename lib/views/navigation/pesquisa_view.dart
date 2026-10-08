import 'package:flutter/material.dart';
import '../../models/esmalte.dart';
import 'produto_view.dart';

class PesquisaView extends StatelessWidget {
  const PesquisaView({super.key});

  static final List<Esmalte> _resultados = [
    Esmalte(nome: 'Vermelho Paixão', marca: 'Risqué', preco: 5.99),
    Esmalte(nome: 'Nude Cremoso', marca: 'Colorama', preco: 4.50),
    Esmalte(nome: 'Rosa Chiclete', marca: 'Dailus', preco: 6.90),
    Esmalte(nome: 'Vinho Intenso', marca: 'Risqué', preco: 5.99),
    Esmalte(nome: 'Azul Noite', marca: 'Impala', preco: 7.50),
    Esmalte(nome: 'Branco Neve', marca: 'Colorama', preco: 4.50),
  ];

  @override
  Widget build(BuildContext context) {
    const double alturaCabecalho = 180;

    return SafeArea(
      bottom: false,
      child: Stack(
        children: [
          // Camada de baixo: grade de resultados rolável
          Positioned.fill(
            child: GridView.builder(
              padding: const EdgeInsets.fromLTRB(16, alturaCabecalho, 16, 110),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.8,
              ),
              itemCount: _resultados.length,
              itemBuilder: (context, index) {
                final item = _resultados[index];

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ProdutoView(esmalte: item),
                      ),
                    );
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: Card(
                          elevation: 2,
                          clipBehavior: Clip.antiAlias,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide(color: Colors.red[900]!, width: 2),
                          ),
                          child: Center(
                            child: Icon(
                              Icons.brush,
                              size: 48,
                              color: Colors.red[900],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        item.nome,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        item.marca,
                        style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // Camada de cima: cabeçalho fixo e semitransparente
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              color: Colors.grey.shade200.withValues(alpha: 0.9),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Descobrir esmaltes',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.red[900],
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search),
                      hintText: 'Buscar por nome ou marca...',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide:
                            BorderSide(color: Colors.red[900]!, width: 1.5),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide:
                            BorderSide(color: Colors.red[900]!, width: 1.5),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide:
                            BorderSide(color: Colors.red[900]!, width: 2.5),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Resultados',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.red[900],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}