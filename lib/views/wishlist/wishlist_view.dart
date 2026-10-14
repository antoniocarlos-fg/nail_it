import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:nail_it/providers/wishlist_provider.dart';
import 'package:nail_it/views/produto/produto_view.dart';

class WishlistView extends StatefulWidget {
  const WishlistView({super.key});

  @override
  State<WishlistView> createState() => _WishlistViewState();
}

class _WishlistViewState extends State<WishlistView> {
  String _termoBusca = '';
  final TextEditingController _buscaController = TextEditingController();

  @override
  void dispose() {
    _buscaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const double alturaCabecalho = 180;

    final provider = context.watch<WishlistProvider>();
    final minhaWishlist = provider.wishlist;

    final resultadosFiltrados = minhaWishlist.where((esmalte) {
      final nome = esmalte.nome.toLowerCase();
      final marca = esmalte.marca.toLowerCase();
      final busca = _termoBusca.toLowerCase();

      return nome.contains(busca) || marca.contains(busca);
    }).toList();

    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            Positioned.fill(
              child: resultadosFiltrados.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.only(top: 180),
                      child: Center(
                        child: Text(
                          _termoBusca.isEmpty
                              ? 'Sua lista de desejos está vazia.\nAdicione esmaltes através da aba Pesquisar!'
                              : 'Nenhum esmalte encontrado na sua wishlist.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(
                        16,
                        alturaCabecalho,
                        16,
                        110,
                      ),
                      itemCount: resultadosFiltrados.length,
                      itemBuilder: (context, index) {
                        final esmalte = resultadosFiltrados[index];

                        return Card(
                          elevation: 2,
                          margin: const EdgeInsets.only(bottom: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                            side: BorderSide(
                              color: Colors.red[900]!,
                              width: 1.5,
                            ),
                          ),
                          child: ListTile(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ProdutoView(esmalte: esmalte),
                                ),
                              );
                            },
                            leading: Icon(
                              Icons.brush,
                              color: Colors.red[900],
                              size: 36,
                            ),
                            title: Text(
                              esmalte.nome,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              '${esmalte.marca} • R\$ ${esmalte.preco.toStringAsFixed(2)}',
                            ),
                            trailing: IconButton(
                              icon: const Icon(
                                Icons.remove_circle_outline,
                                color: Colors.red,
                              ),
                              onPressed: () {
                                context.read<WishlistProvider>().remover(
                                  esmalte,
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      '${esmalte.nome} removido da wishlist.',
                                    ),
                                    backgroundColor: Colors.red[900],
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      },
                    ),
            ),

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
                      'Lista de Desejos',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.red[900],
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _buscaController,
                      onChanged: (valorDigitado) {
                        setState(() {
                          _termoBusca = valorDigitado;
                        });
                      },
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.search),
                        hintText: 'Pesquisar na wishlist...',
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
                      'Meus desejos',
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
      ),
    );
  }
}
