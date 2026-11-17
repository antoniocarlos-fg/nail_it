import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:nail_it/models/esmalte.dart';
import 'package:nail_it/providers/catalogo_provider.dart';
import 'package:nail_it/providers/esmaltes_provider.dart';
import 'package:nail_it/providers/wishlist_provider.dart';
import 'package:nail_it/widgets/esmalte_imagem.dart';

class ProdutoView extends StatefulWidget {
  final Esmalte esmalte;
  final bool ehCatalogoPessoal;

  const ProdutoView({
    super.key,
    required this.esmalte,
    this.ehCatalogoPessoal = false,
  });

  @override
  State<ProdutoView> createState() => _ProdutoViewState();
}

class _ProdutoViewState extends State<ProdutoView> {
  bool _salvando = false;

  void _avisar(String mensagem, {bool erro = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensagem),
        backgroundColor: erro ? Colors.orange[800] : Colors.red[900],
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _adicionarAoEstoque() async {
    if (_salvando) return;
    setState(() => _salvando = true);

    final esmaltesProvider = context.read<EsmaltesProvider>();
    final wishlistProvider = context.read<WishlistProvider>();

    try {
      await esmaltesProvider.adicionar(widget.esmalte);
      if (!mounted) return;

      _avisar('${widget.esmalte.nome} adicionado ao estoque!');

      if (wishlistProvider.possui(widget.esmalte)) {
        final desejaRemover = await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Remover da wishlist?'),
            content: const Text(
              'Também deseja remover o esmalte da sua lista de desejos?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: Text('Não', style: TextStyle(color: Colors.grey[700])),
              ),
              TextButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: Text(
                  'Sim, remover',
                  style: TextStyle(color: Colors.red[900]),
                ),
              ),
            ],
          ),
        );

        if (desejaRemover == true) {
          await wishlistProvider.remover(widget.esmalte);
          if (mounted) {
            _avisar('${widget.esmalte.nome} removido da wishlist.', erro: true);
          }
        }
      }

      if (mounted) Navigator.pop(context);
    } catch (_) {
      if (mounted) {
        _avisar('Não foi possível adicionar ao estoque.', erro: true);
      }
    } finally {
      if (mounted) setState(() => _salvando = false);
    }
  }

  Future<void> _alternarWishlist(bool taNaWishlist) async {
    if (_salvando) return;
    setState(() => _salvando = true);

    final wishlistProvider = context.read<WishlistProvider>();

    try {
      if (taNaWishlist) {
        await wishlistProvider.remover(widget.esmalte);
        if (mounted) {
          _avisar('${widget.esmalte.nome} removido da wishlist', erro: true);
        }
      } else {
        final adicionou = await wishlistProvider.adicionar(widget.esmalte);
        if (mounted) {
          if (adicionou) {
            _avisar('${widget.esmalte.nome} adicionado à wishlist!');
          } else {
            _avisar('Este esmalte já está na sua wishlist.', erro: true);
          }
        }
      }
    } catch (_) {
      if (mounted) {
        _avisar('Erro ao atualizar sua wishlist.', erro: true);
      }
    } finally {
      if (mounted) setState(() => _salvando = false);
    }
  }

  Future<void> _excluirDoCatalogoPessoal() async {
    if (_salvando) return;

    final confirmar = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Excluir esmalte'),
        content: Text(
          'Deseja excluir "${widget.esmalte.nome}" do seu catálogo pessoal?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text('Cancelar', style: TextStyle(color: Colors.grey[700])),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Excluir', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmar != true || !mounted) return;
    setState(() => _salvando = true);

    try {
      await context.read<CatalogoProvider>().removerEsmaltePessoal(widget.esmalte);
      if (!mounted) return;
      _avisar('${widget.esmalte.nome} excluído do catálogo pessoal.');
      Navigator.pop(context);
    } catch (_) {
      if (mounted) {
        _avisar('Erro ao excluir do catálogo pessoal.', erro: true);
      }
    } finally {
      if (mounted) setState(() => _salvando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final taNaWishlist = context.watch<WishlistProvider>().possui(widget.esmalte);

    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        backgroundColor: Colors.red[900],
        foregroundColor: Colors.white,
        title: const Text('Detalhes do esmalte'),
        actions: [
          if (widget.ehCatalogoPessoal)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              tooltip: 'Excluir do catálogo pessoal',
              onPressed: _salvando ? null : _excluirDoCatalogoPessoal,
            ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                elevation: 2,
                color: Colors.white,
                clipBehavior: Clip.antiAlias,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(color: Colors.red[900]!, width: 2),
                ),
                child: SizedBox(
                  height: 200,
                  child: EsmalteImagem(
                    imagemUrl: widget.esmalte.imagemUrl,
                    iconSize: 96,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                widget.esmalte.nome,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.red[900],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                widget.esmalte.marca,
                style: TextStyle(fontSize: 16, color: Colors.grey[700]),
              ),
              const SizedBox(height: 12),
              Text(
                'Preço estimado: R\$ ${widget.esmalte.preco.toStringAsFixed(2)}',
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
                icon: _salvando
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Icon(Icons.add),
                label: const Text('Adicionar ao estoque'),
                onPressed: _salvando ? null : _adicionarAoEstoque,
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor:
                      taNaWishlist ? Colors.grey[700] : Colors.red[900],
                  side: BorderSide(
                    color: taNaWishlist ? Colors.grey[700]! : Colors.red[900]!,
                    width: 1.5,
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                icon: Icon(
                  taNaWishlist ? Icons.favorite : Icons.favorite_border,
                ),
                label: Text(
                  taNaWishlist
                      ? 'Remover da wishlist'
                      : 'Adicionar à wishlist',
                ),
                onPressed:
                    _salvando ? null : () => _alternarWishlist(taNaWishlist),
              ),
              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }
}
