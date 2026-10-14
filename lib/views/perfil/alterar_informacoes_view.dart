import 'package:flutter/material.dart';
import 'package:nail_it/repositories/usuario_repository.dart';

class AlterarInformacoesView extends StatefulWidget {
  const AlterarInformacoesView({super.key});

  @override
  State<AlterarInformacoesView> createState() => _AlterarInformacoesViewState();
}

class _AlterarInformacoesViewState extends State<AlterarInformacoesView> {
  final nomeController = TextEditingController(
    text: UsuarioRepository.usuarioAtual.value?.nome ?? '',
  );
  final senhaAtualController = TextEditingController();
  final novaSenhaController = TextEditingController();
  final confirmNovaSenhaController = TextEditingController();

  @override
  void dispose() {
    nomeController.dispose();
    senhaAtualController.dispose();
    novaSenhaController.dispose();
    confirmNovaSenhaController.dispose();
    super.dispose();
  }

  void _mostrarErro(String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensagem)),
    );
  }

  Widget _campo({
    required TextEditingController controller,
    required String label,
    required IconData icone,
    bool senha = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: senha,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icone),
        floatingLabelStyle: TextStyle(color: Colors.red[900]),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  void _salvar() {
    final nome = nomeController.text.trim();
    final senhaAtual = senhaAtualController.text;
    final novaSenha = novaSenhaController.text;
    final confirmNovaSenha = confirmNovaSenhaController.text;

    if (UsuarioRepository.usuarioAtual.value == null) {
      _mostrarErro('Nenhum usuário logado.');
      return;
    }

    if (nome.isEmpty) {
      _mostrarErro('O campo Nome é obrigatório.');
      return;
    }
    if (nome.length < UsuarioRepository.nomeMinimoCaracteres) {
      _mostrarErro(
        'O nome deve ter pelo menos ${UsuarioRepository.nomeMinimoCaracteres} caracteres.',
      );
      return;
    }

    // Troca de senha é opcional: só valida se algum campo de senha foi preenchido
    final querTrocarSenha =
        senhaAtual.isNotEmpty || novaSenha.isNotEmpty || confirmNovaSenha.isNotEmpty;

    if (querTrocarSenha) {
      if (senhaAtual.isEmpty || novaSenha.isEmpty || confirmNovaSenha.isEmpty) {
        _mostrarErro('Para alterar a senha, preencha os três campos de senha.');
        return;
      }
      if (!UsuarioRepository.senhaAtualConfere(senhaAtual)) {
        _mostrarErro('A senha atual está incorreta.');
        return;
      }
      if (novaSenha != confirmNovaSenha) {
        _mostrarErro('A nova senha e a confirmação não são iguais.');
        return;
      }
    }

    UsuarioRepository.atualizarPerfil(
      nome: nome,
      novaSenha: querTrocarSenha ? novaSenha : null,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Informações atualizadas com sucesso!'),
        backgroundColor: Colors.green[700],
        behavior: SnackBarBehavior.floating,
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: SizedBox(
                width: double.infinity,
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 380),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 56, 16, 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'Alterar informações',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              color: Colors.red[900],
                            ),
                          ),
                          const SizedBox(height: 12),

                          Card(
                            color: Colors.grey.shade200,
                            elevation: 6,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                              side: BorderSide(color: Colors.red[900]!, width: 2),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: _campo(
                                controller: nomeController,
                                label: 'Nome de usuário',
                                icone: Icons.person,
                              ),
                            ),
                          ),

                          const SizedBox(height: 24),
                          Text(
                            'Alterar senha (opcional)',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.red[900],
                            ),
                          ),
                          const SizedBox(height: 12),

                          Card(
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
                                children: [
                                  _campo(
                                    controller: senhaAtualController,
                                    label: 'Senha atual',
                                    icone: Icons.lock,
                                    senha: true,
                                  ),
                                  _campo(
                                    controller: novaSenhaController,
                                    label: 'Nova senha',
                                    icone: Icons.password,
                                    senha: true,
                                  ),
                                  _campo(
                                    controller: confirmNovaSenhaController,
                                    label: 'Confirmar nova senha',
                                    icone: Icons.password,
                                    senha: true,
                                  ),
                                ],
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
                              textStyle: const TextStyle(fontSize: 28),
                            ),
                            onPressed: _salvar,
                            child: const Text('Salvar alterações'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

            Positioned(
              top: 10,
              left: 10,
              child: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () { Navigator.pop(context); },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
