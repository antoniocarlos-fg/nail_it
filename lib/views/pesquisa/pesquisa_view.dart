import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:nail_it/models/esmalte.dart';
import 'package:nail_it/providers/catalogo_provider.dart';
import 'package:nail_it/views/pesquisa/cadastrar_esmalte_view.dart';
import 'package:nail_it/views/produto/produto_view.dart';
import 'package:nail_it/widgets/esmalte_imagem.dart';

class PesquisaView extends StatefulWidget {
  const PesquisaView({super.key});

  @override
  State<PesquisaView> createState() => _PesquisaViewState();
}

class _PesquisaViewState extends State<PesquisaView> {
  String _termoBusca = '';
  final TextEditingController _buscaController = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<CatalogoProvider>().buscar();
      }
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _buscaController.dispose();
    super.dispose();
  }

  void _aoDigitarBusca(String valor) {
    setState(() => _termoBusca = valor);
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 450), () {
      if (mounted) {
        context.read<CatalogoProvider>().buscar(valor);
      }
    });
  }

  Future<void> _abrirCadastroEsmalte() async {
    final novoEsmalte = await Navigator.push<Esmalte>(
      context,
      MaterialPageRoute(builder: (_) => const CadastrarEsmalteView()),
    );

    if (!mounted || novoEsmalte == null) return;

    try {
      await context.read<CatalogoProvider>().adicionarEsmalte(novoEsmalte);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${novoEsmalte.nome} adicionado ao seu catálogo!'),
          backgroundColor: Colors.red[900],
        ),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erro ao salvar o esmalte no seu catálogo.'),
        ),
      );
    }
  }

  Widget _construirCorpo(CatalogoProvider catalogoProvider, double alturaCabecalho) {
    final resultados = catalogoProvider.resultadosPara(_termoBusca);

    if (catalogoProvider.carregando && resultados.isEmpty) {
      return const Padding(
        padding: EdgeInsets.only(top: 180),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (catalogoProvider.erro != null && resultados.isEmpty) {
      return Padding(
        padding: const EdgeInsets.only(top: 180),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                catalogoProvider.erro!,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[700], fontSize: 16),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[900],
                  foregroundColor: Colors.white,
                ),
                onPressed: () => catalogoProvider.tentarNovamente(),
                child: const Text('Tentar novamente'),
              ),
            ],
          ),
        ),
      );
    }

    if (resultados.isEmpty) {
      return Padding(
        padding: const EdgeInsets.only(top: 180),
        child: Center(
          child: Text(
            'Nenhum esmalte encontrado.',
            style: TextStyle(color: Colors.grey[600], fontSize: 16),
          ),
        ),
      );
    }

    return GridView.builder(
      padding: EdgeInsets.fromLTRB(16, alturaCabecalho, 16, 110),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.78,
      ),
      itemCount: resultados.length,
      itemBuilder: (context, index) {
        final item = resultados[index];
        final ehPessoal = item.id != null;

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ProdutoView(
                  esmalte: item,
                  ehCatalogoPessoal: ehPessoal,
                ),
              ),
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Card(
                  elevation: 2,
                  color: Colors.white,
                  clipBehavior: Clip.antiAlias,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(color: Colors.red[900]!, width: 2),
                  ),
                  child: EsmalteImagem(imagemUrl: item.imagemUrl),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                item.nome,
                style: const TextStyle(fontWeight: FontWeight.bold),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                '${item.marca} • R\$ ${item.preco.toStringAsFixed(2)}',
                style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    const double alturaCabecalho = 180;
    final catalogoProvider = context.watch<CatalogoProvider>();

    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            Positioned.fill(
              child: _construirCorpo(catalogoProvider, alturaCabecalho),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Descobrir esmaltes',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.red[900],
                          ),
                        ),
                        if (catalogoProvider.carregando)
                          SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.red[900],
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _buscaController,
                      onChanged: _aoDigitarBusca,
                      onSubmitted: (valor) {
                        _debounce?.cancel();
                        context.read<CatalogoProvider>().buscar(valor);
                      },
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: _termoBusca.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () {
                                  _buscaController.clear();
                                  _aoDigitarBusca('');
                                },
                              )
                            : null,
                        hintText: 'Buscar por nome ou marca...',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(color: Colors.red[900]!, width: 1.5),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(color: Colors.red[900]!, width: 1.5),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(color: Colors.red[900]!, width: 2.5),
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
      ),

      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: FloatingActionButton(
          backgroundColor: Colors.red[900],
          foregroundColor: Colors.white,
          onPressed: _abrirCadastroEsmalte,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
