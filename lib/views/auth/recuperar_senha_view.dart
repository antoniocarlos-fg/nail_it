import 'package:flutter/material.dart';
import 'package:nail_it/repositories/usuario_repository.dart';

class RecuperarSenhaView extends StatefulWidget {
  const RecuperarSenhaView({super.key});

  @override
  State<RecuperarSenhaView> createState() => _RecuperarSenhaViewState();
}

class _RecuperarSenhaViewState extends State<RecuperarSenhaView> {
  final emailController = TextEditingController();
  final emailValido = RegExp(
    r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
  );

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  void _verificarConta() {
    final email = emailController.text.trim();
    String mensagem;

    if (email.isEmpty) {
      mensagem = 'Informe o e-mail cadastrado.';
    } else if (!emailValido.hasMatch(email)) {
      mensagem = 'Informe um e-mail válido.';
    } else if (!UsuarioRepository.emailExiste(email)) {
      mensagem = 'Não encontramos uma conta cadastrada com esse e-mail.';
    } else {
      mensagem = 'Conta encontrada, no entanto, a função ainda está em desenvolvimento.';
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensagem)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: [
            Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: SizedBox(
                      width: double.infinity,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
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
                          const SizedBox(height: 36),
                          Text(
                            'Recuperar senha',
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
                                      controller: emailController,
                                      keyboardType: TextInputType.emailAddress,
                                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                                      decoration: InputDecoration(
                                        labelText: 'Email da conta',
                                        prefixIcon: const Icon(Icons.email),
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
                              padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 20),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              textStyle: const TextStyle(fontSize: 32),
                            ),
                            onPressed: _verificarConta,
                            child: const Text('Solicitar\nrecuperação', textAlign: TextAlign.center),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            
            Positioned(
              top: 10,
              left: 10,
              child: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              )
            )
          ],
        ),
      ),
    );
  }
}
