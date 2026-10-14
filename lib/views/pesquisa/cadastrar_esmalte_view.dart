import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nail_it/models/esmalte.dart';

class CadastrarEsmalteView extends StatefulWidget {
  const CadastrarEsmalteView({super.key});

  @override
  State<CadastrarEsmalteView> createState() => _CadastrarEsmalteViewState();
}

class _CadastrarEsmalteViewState extends State<CadastrarEsmalteView> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _marcaController = TextEditingController();
  final _precoController = TextEditingController();

  @override
  void dispose() {
    _nomeController.dispose();
    _marcaController.dispose();
    _precoController.dispose();
    super.dispose();
  }

  void _salvar() {
    if (!_formKey.currentState!.validate()) return;

    final preco = double.parse(_precoController.text.trim().replaceAll(',', '.'));
    Navigator.pop(
      context,
      Esmalte(
        nome: _nomeController.text.trim(),
        marca: _marcaController.text.trim(),
        preco: preco,
      ),
    );
  }

  String? _validarTexto(String? valor, String campo) {
    if (valor == null || valor.trim().isEmpty) {
      return 'Informe $campo.';
    }
    return null;
  }

  String? _validarPreco(String? valor) {
    if (valor == null || valor.trim().isEmpty) {
      return 'Informe o preço.';
    }

    final preco = double.tryParse(valor.trim().replaceAll(',', '.'));
    if (preco == null || preco < 0) {
      return 'Informe um preço válido.';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        title: const Text('Cadastrar esmalte'),
        backgroundColor: Colors.red[900],
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Adicione um esmalte ao catálogo local.',
                  style: TextStyle(fontSize: 18, color: Colors.grey[800]),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _nomeController,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(labelText: 'Nome do esmalte'),
                  validator: (valor) => _validarTexto(valor, 'o nome'),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _marcaController,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(labelText: 'Marca'),
                  validator: (valor) => _validarTexto(valor, 'a marca'),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _precoController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9,.]')),
                  ],
                  decoration: const InputDecoration(
                    labelText: 'Preço',
                    prefixText: 'R\$ ',
                  ),
                  validator: _validarPreco,
                ),
                const SizedBox(height: 28),
                FilledButton.icon(
                  onPressed: _salvar,
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.red[900],
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  icon: const Icon(Icons.save),
                  label: const Text('Salvar esmalte'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
