import 'package:flutter/material.dart';

class PerfilView extends StatefulWidget {
  const PerfilView({super.key});

  @override
  State<PerfilView> createState() => _PerfilViewState();
}

class _PerfilViewState extends State<PerfilView> {
  // Botão reutilizável para não repetir estilo
  Widget _opcao({
    required IconData icone,
    required String texto,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(icone, size: 28),
        label: Align(
          alignment: Alignment.centerLeft,
          child: Text(texto, style: const TextStyle(fontSize: 20)),
        ),
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.red[900],
          side: BorderSide(color: Colors.red[900]!, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

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
                  child: Center(
                    child: ConstrainedBox(
                      // largura máxima compartilhada pelos dois cards
                      constraints: const BoxConstraints(maxWidth: 380),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // CARD DO PERFIL
                            Card(
                              color: Colors.grey.shade200,
                              elevation: 6,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                                side: BorderSide(
                                  color: Colors.red[900]!,
                                  width: 2,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                  horizontal: 16,
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.account_circle,
                                      size: 128,
                                      color: Colors.red[900],
                                    ),
                                    Text(
                                      'Pessoa',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 40,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red[900],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            const SizedBox(height: 16),

                            // CARD DAS OPÇÕES
                            Card(
                              color: Colors.grey.shade200,
                              elevation: 6,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                                side: BorderSide(
                                  color: Colors.red[900]!,
                                  width: 2,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    _opcao(
                                      icone: Icons.edit,
                                      texto: 'Editar perfil',
                                      onPressed: () {},
                                    ),
                                    const SizedBox(height: 12),
                                    _opcao(
                                      icone: Icons.lock,
                                      texto: 'Alterar senha',
                                      onPressed: () {},
                                    ),
                                    const SizedBox(height: 12),
                                    _opcao(
                                      icone: Icons.info_outline,
                                      texto: 'Sobre o Nail It!',
                                      onPressed: () {Navigator.pushNamed(context, 'sobre');},
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}