import 'package:flutter/material.dart';

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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: [
            Column(
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
                            'Recupera senha',
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
                                        labelText: 'Email da conta',
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
                                  ],
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
                                horizontal: 35,
                                vertical: 20,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              textStyle: TextStyle(fontSize: 32),
                            ),
                            onPressed: () {
                              if (emailController.text.isEmpty){
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('É necessário preencher o campo de email para recuperar sua conta.'),
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
                              }
                            },
                            child: Text(
                              'Solicitar\nrecuperação',
                              textAlign: TextAlign.center
                            ),
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
                icon: Icon(Icons.arrow_back),
                onPressed: () {Navigator.pushNamed(context, 'login');},
              )
            )

          ],
        ),
      ),
    );
  }
}