import 'package:device_preview_plus/device_preview_plus.dart';
import 'package:flutter/material.dart';
import 'package:nail_it/view/cadastro_usuario_view.dart';
import 'package:nail_it/view/login_view.dart';
import 'package:nail_it/view/menu_principal_view.dart';
import 'package:nail_it/view/perfil_view.dart';
import 'package:nail_it/view/recuperar_senha_view.dart';
import 'package:nail_it/view/sobre_view.dart';

void main() {
  runApp(
    DevicePreview(
      builder: (context) => const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nail It!',
      home: null,

      initialRoute: 'login',
      routes: {
        'login':(context) => const LoginView(),
        'cadastro_usuario':(context) => const CadastroUsuarioView(),
        'recuperar_senha':(context) => const RecuperarSenhaView(),
        'sobre':(context) => const SobreView(),
        'perfil':(context) => const PerfilView(),
        'menu_principal':(context) => MenuPrincipalView(),
      },

      onUnknownRoute: (settings){
        return MaterialPageRoute(
          builder: (context) => LoginView(),
        );
      },
    );
  }
}