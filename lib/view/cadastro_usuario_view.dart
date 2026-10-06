import 'package:flutter/material.dart';

class CadastroUsuarioView extends StatefulWidget {
  const CadastroUsuarioView({super.key});

  @override
  State<CadastroUsuarioView> createState() => _CadastroUsuarioViewState();
}

class _CadastroUsuarioViewState extends State<CadastroUsuarioView> {

  final userController = TextEditingController();
  final emailController = TextEditingController();
  final senhaController = TextEditingController();
  final confirmSenhaController = TextEditingController();
  final emailValido = RegExp(
    r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
  );

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

                      SizedBox(height: 483)
                ]
              )
            ),

            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  
                  SizedBox(height: 200,),

                  Text(
                    'Criar conta',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.red[900],
                    ),
                  ),

                  SizedBox(height: 12),

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
                                  controller: userController,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  decoration: InputDecoration(
                                    labelText: 'Nome de usuário',
                                    prefixIcon: Icon(Icons.person),
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

                                TextField(
                                  controller: confirmSenhaController,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  obscureText: true,
                                  decoration: InputDecoration(
                                    labelText: 'Confirmar senha',
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

                      SizedBox(height: 24),

                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red[900],
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                            horizontal: 40,
                            vertical: 20,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          textStyle: TextStyle(fontSize: 32),
                        ),
                        onPressed: () {
                          if (emailController.text.isEmpty || senhaController.text.isEmpty || userController.text.isEmpty){
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('É necessário preencher todos os campos para efetuar o cadastro.'),
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
                          }else if(senhaController.text!=confirmSenhaController.text){
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('As senhas não são iguais.'),
                              ),
                            );
                            return;
                          }else{Navigator.pushNamed(context, 'perfil');}
                        },
                        child: Text('Efetuar cadastro'),
                      ),
                ],
              )
            ),

            Positioned(
              top: 10,
              left: 10,
              child: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {Navigator.pushNamed(context, 'login');},
              )
            )

          ],
        )
      )
    );
  }
}