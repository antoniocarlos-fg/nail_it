import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:nail_it/models/esmalte.dart';
import 'package:nail_it/providers/esmaltes_provider.dart';

class EstoqueDetalheView extends StatefulWidget {
  final Esmalte esmalte;

  const EstoqueDetalheView({super.key, required this.esmalte});

  @override
  State<EstoqueDetalheView> createState() => _EstoqueDetalheViewState();
}

class _EstoqueDetalheViewState extends State<EstoqueDetalheView> {
  late String _statusAtual;

  @override
  void initState() {
    super.initState();
    _statusAtual = widget.esmalte.status;
  }

  void _mostrarConfirmacaoRemocao(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: const Text('Remover esmalte'),
          content: Text('Tem a certeza que deseja remover ${widget.esmalte.nome} do seu estoque?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text('Cancelar', style: TextStyle(color: Colors.grey[700])),
            ),
            TextButton(
              onPressed: () {
                context.read<EsmaltesProvider>().remover(widget.esmalte);
                Navigator.pop(ctx); 
                Navigator.pop(context); 
                
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${widget.esmalte.nome} removido do estoque.'),
                    backgroundColor: Colors.red[900],
                  ),
                );
              },
              child: const Text('Remover', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        backgroundColor: Colors.red[900],
        foregroundColor: Colors.white,
        title: const Text('Meu Esmalte'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () => _mostrarConfirmacaoRemocao(context),
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
              
              const SizedBox(height: 32),
              
              const Text(
                'Estado de utilização:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.red[900]!, width: 1.5),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _statusAtual,
                    isExpanded: true,
                    icon: Icon(Icons.arrow_drop_down, color: Colors.red[900]),
                    items: <String>['Novo', 'Usando', 'Acabando'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? novoValor) {
                      if (novoValor != null) {
                        setState(() {
                          _statusAtual = novoValor;
                        });
                        context.read<EsmaltesProvider>().alterarStatus(widget.esmalte, novoValor);
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
