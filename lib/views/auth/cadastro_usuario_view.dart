import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nail_it/repositories/usuario_repository.dart';
import 'package:nail_it/models/usuario.dart';

/// Formata o telefone enquanto o usuário digita.
class TelefoneFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digitos = newValue.text.replaceAll(RegExp(r'\D'), '');
    final d = digitos.length > 11 ? digitos.substring(0, 11) : digitos;

    final buffer = StringBuffer();
    for (int i = 0; i < d.length; i++) {
      if (i == 0) buffer.write('(');
      if (i == 2) buffer.write(') ');
      if (i == 7 && d.length == 11) buffer.write('-');
      if (i == 6 && d.length < 11) buffer.write('-');
      buffer.write(d[i]);
    }

    final texto = buffer.toString();
    return TextEditingValue(
      text: texto,
      selection: TextSelection.collapsed(offset: texto.length),
    );
  }
}

class CadastroUsuarioView extends StatefulWidget {
  const CadastroUsuarioView({super.key});

  @override
  State<CadastroUsuarioView> createState() => _CadastroUsuarioViewState();
}

class _CadastroUsuarioViewState extends State<CadastroUsuarioView> {
  final userController = TextEditingController();
  final emailController = TextEditingController();
  final telefoneController = TextEditingController();
  final senhaController = TextEditingController();
  final confirmSenhaController = TextEditingController();

  final emailValido = RegExp(
    r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
  );

  @override
  void dispose() {
    userController.dispose();
    emailController.dispose();
    telefoneController.dispose();
    senhaController.dispose();
    confirmSenhaController.dispose();
    super.dispose();
  }

  void _mostrarErro(String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensagem)),
    );
  }

  void _cadastrar() {
    final nome = userController.text.trim();
    final email = emailController.text.trim();
    final telefone = telefoneController.text.replaceAll(RegExp(r'\D'), '');
    final senha = senhaController.text;

    if (nome.isEmpty ||
        email.isEmpty ||
        telefone.isEmpty ||
        senha.isEmpty) {
      _mostrarErro('É necessário preencher todos os campos para efetuar o cadastro.');
      return;
    }
    if (!emailValido.hasMatch(email)) {
      _mostrarErro('Email inválido.');
      return;
    }
    // Aceita telefone com DDD: 10 dígitos para fixo ou 11 para celular.
    if (telefone.length < 10 || telefone.length > 11) {
      _mostrarErro('Telefone inválido. Informe o DDD e o número.');
      return;
    }
    if (senha != confirmSenhaController.text) {
      _mostrarErro('As senhas não são iguais.');
      return;
    }

    final cadastrado = UsuarioRepository.cadastrar(
      Usuario(nome: nome, email: email, telefone: telefone, senha: senha),
    );

    if (!cadastrado) {
      _mostrarErro('Já existe uma conta com este email.');
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Cadastro feito com sucesso!'),
        backgroundColor: Colors.green[700],
        behavior: SnackBarBehavior.floating,
      ),
    );
    Navigator.pushReplacementNamed(context, 'menu_principal');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Card(
                    color: Colors.grey.shade200,
                    elevation: 6,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(color: Colors.red[900]!, width: 2),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 50),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/nailit_icon.png',
                            width: 160,
                            height: 160,
                            color: Colors.red[900],
                            fit: BoxFit.cover,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Nail It!',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 50,
                              fontWeight: FontWeight.bold,
                              color: Colors.red[900],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 483)
                ]
              )
            ),

            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Altura extra para acomodar o campo de telefone.
                  const SizedBox(height: 264),
                  Text(
                    'Criar conta',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.red[900],
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: 350,
                    child: Card(
                      color: Colors.grey.shade200,
                      elevation: 6,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(color: Colors.red[900]!, width: 2),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            TextField(
                              controller: userController,
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                              decoration: InputDecoration(
                                labelText: 'Nome de usuário',
                                prefixIcon: const Icon(Icons.person),
                                floatingLabelStyle: TextStyle(color: Colors.red[900]),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                            TextField(
                              controller: emailController,
                              keyboardType: TextInputType.emailAddress,
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                              decoration: InputDecoration(
                                labelText: 'Email',
                                prefixIcon: const Icon(Icons.email),
                                floatingLabelStyle: TextStyle(color: Colors.red[900]),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                            TextField(
                              controller: telefoneController,
                              keyboardType: TextInputType.phone,
                              inputFormatters: [TelefoneFormatter()],
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                              decoration: InputDecoration(
                                labelText: 'Telefone',
                                hintText: '(00) 00000-0000',
                                prefixIcon: const Icon(Icons.phone),
                                floatingLabelStyle: TextStyle(color: Colors.red[900]),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                            TextField(
                              controller: senhaController,
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                              obscureText: true,
                              decoration: InputDecoration(
                                labelText: 'Senha',
                                prefixIcon: const Icon(Icons.password),
                                floatingLabelStyle: TextStyle(color: Colors.red[900]),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                            TextField(
                              controller: confirmSenhaController,
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                              obscureText: true,
                              decoration: InputDecoration(
                                labelText: 'Confirmar senha',
                                prefixIcon: const Icon(Icons.password),
                                floatingLabelStyle: TextStyle(color: Colors.red[900]),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[900],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      textStyle: const TextStyle(fontSize: 32),
                    ),
                    onPressed: _cadastrar,
                    child: const Text('Efetuar cadastro'),
                  ),
                ],
              )
            ),

            Positioned(
              top: 10,
              left: 10,
              child: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () { Navigator.pushNamed(context, 'login'); },
              )
            )
          ],
        )
      )
    );
  }
}
