import 'package:flutter/material.dart';

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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: SafeArea(
        child: Column(
          children: [
            // CONTEÚDO (rola se precisar)
            Expanded(
              child: SingleChildScrollView(
                child: SizedBox(
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // CARD DA LOGO (topo)
                      Card(
                        color: Colors.grey.shade200,
                        elevation: 6,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(
                            color: Colors.red[900]!,
                            width: 2,
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 16,
                            horizontal: 50,
                          ),
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
                              SizedBox(height: 8),
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

                      SizedBox(height: 36),

                      Text(
                        'Login',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Colors.red[900],
                        ),
                      ),

                      SizedBox(height: 12),

                      // CARD DOS CAMPOS
                      SizedBox(
                        width: 350,
                        child: Card(
                          color: Colors.grey.shade200,
                          elevation: 6,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide(
                              color: Colors.red[900]!,
                              width: 2,
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(8),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                TextField(
                                  controller: emailController,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  decoration: InputDecoration(
                                    labelText: 'Email',
                                    prefixIcon: Icon(Icons.email),
                                    floatingLabelStyle: TextStyle(
                                      color: Colors.red[900],
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                ),
                                TextField(
                                  controller: senhaController,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  obscureText: true,
                                  decoration: InputDecoration(
                                    labelText: 'Senha',
                                    prefixIcon: Icon(Icons.password),
                                    floatingLabelStyle: TextStyle(
                                      color: Colors.red[900],
                                    ),
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

                      // ESQUECEU A SENHA
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
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.red[900],
                              ),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 24),

                      // BOTÃO ENTRAR
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red[900],
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                            horizontal: 63,
                            vertical: 20,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          textStyle: TextStyle(fontSize: 32),
                        ),
                        onPressed: () {
                          if (emailController.text.isEmpty || senhaController.text.isEmpty){
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('É necessário preencher todos os campos para efetuar o login.'),
                              ),
                            );
                            return;
                          }else if(!emailValido.hasMatch(emailController.text)){
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Email inválido.'),
                              ),
                            );
                            return;
                          }else{Navigator.pushNamed(context, 'menu_principal');}
                        },
                        child: Text('Entrar'),
                      ),

                      SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),

            // FIXO NO RODAPÉ
            Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Não tem uma conta?',
                    style: TextStyle(fontSize: 16),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, 'cadastro_usuario');
                    },
                    child: Text(
                      'Cadastre-se',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.red[900],
                      ),
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