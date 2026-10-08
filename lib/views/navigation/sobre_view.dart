import 'package:flutter/material.dart';

class SobreView extends StatefulWidget {
  const SobreView({super.key});

  @override
  State<SobreView> createState() => _SobreViewState();
}

class _SobreViewState extends State<SobreView> {

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
                          
                          Text(
                            'Sobre o app',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              color: Colors.red[900],
                            ),
                          ),

                          SizedBox(
                            width: 370,
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
                                    
                                    Text(
                                      'O Nail It! foi criado para facilitar a vida de quem ama esmaltes e quer ter a coleção sempre à mão.\n\n'
                                      'Com ele, você organiza todos os seus esmaltes em um só lugar, acompanha o estado de uso de cada um '
                                      'e descobre novas cores por meio da pesquisa. O que ainda não está na sua coleção? '
                                      'Salve na lista de desejos e planeje as próximas compras.\n\n'
                                      'Este aplicativo foi desenvolvido como projeto prático avaliativo da disciplina de '
                                      'Programação para Dispositivos Móveis, do curso de Tecnologia em Análise e Desenvolvimento '
                                      'de Sistemas da Fatec Ribeirão Preto.\n\n'
                                      'Professor: Rodrigo Plotze\n'
                                      'Desenvolvido por: Antonio Carlos',
                                      textAlign: TextAlign.left,
                                      style: TextStyle(fontSize: 20),
                                      
                                    )

                                  ],
                                ),
                              ),
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
                onPressed: () {Navigator.pop(context);},
              )
            )

          ],
        ),
      ),
    );
  }
}