import 'package:device_preview_plus/device_preview_plus.dart';
import 'package:flutter/material.dart';
import 'package:nail_it/views/auth/cadastro_usuario_view.dart';
import 'package:nail_it/views/auth/login_view.dart';
import 'package:nail_it/views/navegacao/menu_principal_view.dart';
import 'package:nail_it/views/auth/recuperar_senha_view.dart';
import 'package:nail_it/views/sobre/sobre_view.dart';
import 'package:nail_it/views/perfil/alterar_informacoes_view.dart';
import 'package:provider/provider.dart';
import 'package:nail_it/providers/esmaltes_provider.dart';
import 'package:nail_it/providers/wishlist_provider.dart';
import 'package:nail_it/providers/catalogo_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => EsmaltesProvider()),
        ChangeNotifierProvider(create: (_) => WishlistProvider()),
        ChangeNotifierProvider(create: (_) => CatalogoProvider()),
      ],
      child: DevicePreview(builder: (context) => const MainApp()),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nail It!',

      initialRoute: 'login',
      routes: {
        'login': (context) => const LoginView(),
        'cadastro_usuario': (context) => const CadastroUsuarioView(),
        'recuperar_senha': (context) => const RecuperarSenhaView(),

        'menu_principal': (context) => MenuPrincipalView(),

        'alterar_informacoes': (context) => const AlterarInformacoesView(),
        'sobre': (context) => const SobreView(),
      },

      onUnknownRoute: (settings) {
        return MaterialPageRoute(builder: (context) => LoginView());
      },
    );
  }
}
