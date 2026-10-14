import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:nail_it/providers/esmaltes_provider.dart';
import 'package:nail_it/repositories/usuario_repository.dart';
import 'package:nail_it/views/estoque/estoque_detalhe_view.dart';

class InicioView extends StatefulWidget {
  const InicioView({super.key});

  @override
  State<InicioView> createState() => _InicioViewState();
}

class _InicioViewState extends State<InicioView> {
  String _termoBusca = '';
  final TextEditingController _buscaController = TextEditingController();

  @override
  void dispose() {
    _buscaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<EsmaltesProvider>();
    final meusEsmaltes = provider.esmaltes;

    final resultadosFiltrados = meusEsmaltes.where((esmalte) {
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
                              ? 'Seu estoque está vazio.\nAdicione esmaltes através da aba Pesquisar!'
                              : 'Nenhum esmalte encontrado no seu estoque.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                    )
                  : GridView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 180, 16, 110), 
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 0.8,
                      ),
                      itemCount: resultadosFiltrados.length,
                      itemBuilder: (context, index) {
                        final esmalte = resultadosFiltrados[index];

                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => EstoqueDetalheView(esmalte: esmalte),
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
                                esmalte.nome,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                esmalte.status,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[700],
                                ),
                              ),
                            ],
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
                    ValueListenableBuilder(
                      valueListenable: UsuarioRepository.usuarioAtual,
                      builder: (context, usuario, _) => Text(
                        'Olá, ${usuario?.nome ?? 'Pessoa'}! 👋',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.red[900],
                        ),
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
      ),
    );
  }
}
