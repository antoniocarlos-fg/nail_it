import 'package:device_preview_plus/device_preview_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:nail_it/firebase_options.dart';
import 'package:nail_it/providers/catalogo_provider.dart';
import 'package:nail_it/providers/esmaltes_provider.dart';
import 'package:nail_it/providers/wishlist_provider.dart';
import 'package:nail_it/repositories/usuario_repository.dart';
import 'package:nail_it/views/auth/cadastro_usuario_view.dart';
import 'package:nail_it/views/auth/login_view.dart';
import 'package:nail_it/views/auth/recuperar_senha_view.dart';
import 'package:nail_it/views/navegacao/menu_principal_view.dart';
import 'package:nail_it/views/perfil/alterar_informacoes_view.dart';
import 'package:nail_it/views/sobre/sobre_view.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await UsuarioRepository.carregarSessaoAtual();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => EsmaltesProvider()),
        ChangeNotifierProvider(create: (_) => WishlistProvider()),
        ChangeNotifierProvider(create: (_) => CatalogoProvider()),
      ],
      child: DevicePreview(
        enabled: !kReleaseMode,
        builder: (context) => const MainApp()
      ),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final logado = UsuarioRepository.usuarioAtual.value != null;

    return MaterialApp(
      title: 'Nail It!',
      initialRoute: logado ? 'menu_principal' : 'login',
      routes: {
        'login': (context) => const LoginView(),
        'cadastro_usuario': (context) => const CadastroUsuarioView(),
        'recuperar_senha': (context) => const RecuperarSenhaView(),
        'menu_principal': (context) => const MenuPrincipalView(),
        'alterar_informacoes': (context) => const AlterarInformacoesView(),
        'sobre': (context) => const SobreView(),
      },
      onUnknownRoute: (settings) {
        return MaterialPageRoute(builder: (context) => const LoginView());
      },
    );
  }
}
