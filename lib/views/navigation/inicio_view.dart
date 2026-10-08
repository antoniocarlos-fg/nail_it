import 'package:flutter/material.dart';

class InicioView extends StatefulWidget {
  const InicioView({super.key});

  @override
  State<InicioView> createState() => _InicioViewState();
}

class _InicioViewState extends State<InicioView> {
  final List<({String nome, String status})> _esmaltes = [
    (nome: 'Ruby', status: 'Novo'),
    (nome: 'Nude', status: 'Usando'),
    (nome: 'Pink', status: 'Acabando'),
    (nome: 'Wine', status: 'Novo'),
  ];

  @override
  Widget build(BuildContext context) {
    const double alturaCabecalho = 180;

    return SafeArea(
      bottom: false,
      child: Stack(
        children: [
          // Camada de baixo: grade de itens rolável
          Positioned.fill(
            child: GridView.builder(
              padding: EdgeInsets.fromLTRB(
                16,
                alturaCabecalho,
                16,
                110,
              ),
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.8,
              ),
              itemCount: _esmaltes.length,
              itemBuilder: (context, index) {
                final item = _esmaltes[index];

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: Card(
                        elevation: 2,
                        clipBehavior: Clip.antiAlias,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(
                            color: Colors.red[900]!,
                            width: 2,
                          ),
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
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    Text(
                      item.status,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
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
                    'Olá, Pessoa! 👋',
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
                      hintText: 'Pesquisar esmaltes...',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(
                          color: Colors.red[900]!,
                          width: 1.5,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(
                          color: Colors.red[900]!,
                          width: 1.5,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(
                          color: Colors.red[900]!,
                          width: 2.5,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  Text(
                    'Meus esmaltes',
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