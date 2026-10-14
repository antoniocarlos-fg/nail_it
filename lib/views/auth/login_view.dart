import 'package:flutter/material.dart';
import 'package:nail_it/repositories/usuario_repository.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final emailController = TextEditingController();
  final senhaController = TextEditingController();
  final emailValido = RegExp(
    r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
  );

  @override
  void dispose() {
    emailController.dispose();
    senhaController.dispose();
    super.dispose();
  }

  void _mostrarErro(String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensagem)),
    );
  }

  void _entrar() {
    final email = emailController.text.trim();
    final senha = senhaController.text;

    if (email.isEmpty || senha.isEmpty) {
      _mostrarErro('É necessário preencher todos os campos para efetuar o login.');
      return;
    }
    if (!emailValido.hasMatch(email)) {
      _mostrarErro('Email inválido.');
      return;
    }

    final usuario = UsuarioRepository.autenticar(email, senha);

    if (usuario == null) {
      // Evita revelar qual credencial está incorreta.
      _mostrarErro('Email ou senha incorretos.');
      return;
    }

    Navigator.pushReplacementNamed(context, 'menu_principal');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: SafeArea(
        child: Column(
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
                        'Login',
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
                                  controller: senhaController,
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                                  obscureText: true,
                                  onSubmitted: (_) => _entrar(),
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
                              ],
                            ),
                          ),
                        ),
                      ),

                      SizedBox(
                        width: 350,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, 'recuperar_senha');
                            },
                            child: Text(
                              'Esqueceu sua senha?',
                              style: TextStyle(fontSize: 14, color: Colors.red[900]),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red[900],
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 63, vertical: 20),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          textStyle: const TextStyle(fontSize: 32),
                        ),
                        onPressed: _entrar,
                        child: const Text('Entrar'),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Não tem uma conta?', style: TextStyle(fontSize: 16)),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, 'cadastro_usuario');
                    },
                    child: Text(
                      'Cadastre-se',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.red[900]),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
