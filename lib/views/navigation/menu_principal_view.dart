import 'package:flutter/material.dart';

import 'inicio_view.dart';
import 'pesquisa_view.dart';
import 'wishlist_view.dart';
import 'perfil_view.dart';

class MenuPrincipalView extends StatefulWidget {
  const MenuPrincipalView({super.key});

  @override
  State<MenuPrincipalView> createState() => _MenuPrincipalViewState();
}

class _MenuPrincipalViewState extends State<MenuPrincipalView> {
  int _indiceAtual = 0;

  final List<Widget> _telas = [
    const InicioView(),
    const PesquisaView(),
    const WishlistView(),
    const PerfilView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _indiceAtual,
        children: _telas,
      ),

      bottomNavigationBar: NavigationBar(
        labelTextStyle: WidgetStateProperty.all(
          const TextStyle(
            fontSize: 12,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.red[900],
        indicatorColor: Colors.red[600],
        selectedIndex: _indiceAtual,

        onDestinationSelected: (i) {
          setState(() {
            _indiceAtual = i;
          });
        },

        destinations: [
          NavigationDestination(
            icon: const Icon(
              Icons.home,
              color: Colors.white70,
            ),
            selectedIcon: const Icon(
              Icons.home,
              color: Colors.white,
            ),
            label: 'Início',
          ),

          NavigationDestination(
            icon: const Icon(
              Icons.search,
              color: Colors.white70,
            ),
            selectedIcon: const Icon(
              Icons.search,
              color: Colors.white,
            ),
            label: 'Pesquisar',
          ),

          NavigationDestination(
            icon: const Icon(
              Icons.favorite,
              color: Colors.white70,
            ),
            selectedIcon: const Icon(
              Icons.favorite,
              color: Colors.white,
            ),
            label: 'Wishlist',
          ),

          NavigationDestination(
            icon: const Icon(
              Icons.person,
              color: Colors.white70,
            ),
            selectedIcon: const Icon(
              Icons.person,
              color: Colors.white,
            ),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}