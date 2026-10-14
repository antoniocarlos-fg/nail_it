import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:nail_it/models/esmalte.dart';
import 'package:nail_it/providers/esmaltes_provider.dart';
import 'package:nail_it/providers/wishlist_provider.dart';

class ProdutoView extends StatelessWidget {
  final Esmalte esmalte;

  const ProdutoView({super.key, required this.esmalte});

  void _avisar(BuildContext context, String mensagem, {bool erro = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensagem),
        backgroundColor: erro ? Colors.orange[800] : Colors.red[900],
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final taNaWishlist = context.watch<WishlistProvider>().possui(esmalte);

    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        backgroundColor: Colors.red[900],
        foregroundColor: Colors.white,
        title: const Text('Detalhes do esmalte'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(color: Colors.red[900]!, width: 2),
                ),
                child: SizedBox(
                  height: 200,
                  child: Center(
                    child: Icon(Icons.brush, size: 96, color: Colors.red[900]),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                esmalte.nome,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.red[900],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                esmalte.marca,
                style: TextStyle(fontSize: 16, color: Colors.grey[700]),
              ),
              const SizedBox(height: 12),
              Text(
                'R\$ ${esmalte.preco.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.red[900],
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                icon: const Icon(Icons.add),
                label: const Text('Adicionar ao estoque'),
                onPressed: () {
                  context.read<EsmaltesProvider>().adicionar(esmalte);
                  _avisar(context, '${esmalte.nome} adicionado ao estoque!');
                  Navigator.pop(context); 
                },
              ),
              const SizedBox(height: 12),
              
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: taNaWishlist ? Colors.grey[700] : Colors.red[900],
                  side: BorderSide(
                    color: taNaWishlist ? Colors.grey[700]! : Colors.red[900]!, 
                    width: 1.5
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                icon: Icon(taNaWishlist ? Icons.favorite : Icons.favorite_border),
                label: Text(taNaWishlist ? 'Remover da wishlist' : 'Adicionar à wishlist'),
                onPressed: () {
                  if (taNaWishlist) {
                    context.read<WishlistProvider>().remover(esmalte);
                    _avisar(context, '${esmalte.nome} removido da wishlist', erro: true);
                  } else {
                    context.read<WishlistProvider>().adicionar(esmalte);
                    _avisar(context, '${esmalte.nome} adicionado à wishlist!');
                  }
                },
              ),
              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }
}
