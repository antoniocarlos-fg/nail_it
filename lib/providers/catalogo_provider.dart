import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/esmalte.dart';
import '../repositories/usuario_repository.dart';

class CatalogoProvider extends ChangeNotifier {
  static const String _workerBaseUrl =
      'https://nail-it-vtex.antoniocfariasgouveia.workers.dev/';
  static const String _vtexDiretaUrl =
      'https://www.ikesaki.com.br/api/catalog_system/pub/products/search';

  final CollectionReference<Map<String, dynamic>> _colecaoPessoal =
      FirebaseFirestore.instance.collection('catalogo_pessoal');

  List<Esmalte> _resultadosVtex = [];
  List<Esmalte> _catalogoPessoal = [];
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _assinaturaPessoal;

  bool _carregando = false;
  String? _erro;
  String _ultimaBusca = '';

  CatalogoProvider() {
    UsuarioRepository.usuarioAtual.addListener(_aoAlterarUsuario);
    _aoAlterarUsuario();
  }

  bool get carregando => _carregando;
  String? get erro => _erro;

  String? get _uidAtual => UsuarioRepository.usuarioAtual.value?.uid;

  void _aoAlterarUsuario() {
    _assinaturaPessoal?.cancel();
    final uid = _uidAtual;

    if (uid == null) {
      _catalogoPessoal = [];
      notifyListeners();
      return;
    }

    _assinaturaPessoal = _colecaoPessoal
        .where('uid', isEqualTo: uid)
        .snapshots()
        .listen((snapshot) {
      _catalogoPessoal = snapshot.docs
          .map((doc) => Esmalte.fromMap(doc.id, doc.data()))
          .toList();
      notifyListeners();
    });
  }

  /// Combina os esmaltes cadastrados pelo próprio usuário com os da VTEX.
  List<Esmalte> resultadosPara(String termoBusca) {
    final busca = termoBusca.trim().toLowerCase();
    final pessoaisFiltrados = _catalogoPessoal.where((esmalte) {
      if (busca.isEmpty) return true;
      return esmalte.nome.toLowerCase().contains(busca) ||
          esmalte.marca.toLowerCase().contains(busca);
    });

    return [...pessoaisFiltrados, ..._resultadosVtex];
  }

  /// Consulta esmaltes na API da VTEX (Ikesaki) via Worker na Web ou direto no mobile.
  Future<void> buscar([String termoBusca = '']) async {
    final termo = termoBusca.trim();
    _ultimaBusca = termo;

    final query = termo.isEmpty
        ? 'esmalte'
        : (termo.toLowerCase().contains('esmalte') ? termo : 'esmalte $termo');

    _carregando = true;
    _erro = null;
    notifyListeners();

    try {
      final base = kIsWeb ? _workerBaseUrl : _vtexDiretaUrl;
      final uri = Uri.parse(base).replace(
        queryParameters: {
          'ft': query,
          '_from': '0',
          '_to': '19',
        },
      );

      final resposta = await http.get(uri).timeout(const Duration(seconds: 12));

      if (resposta.statusCode != 200 && resposta.statusCode != 206) {
        throw Exception('HTTP ${resposta.statusCode}');
      }

      final lista = jsonDecode(resposta.body) as List<dynamic>;
      _resultadosVtex = lista.map((raw) {
        final produto = raw as Map<String, dynamic>;
        final nome = (produto['productName'] ?? 'Esmalte') as String;
        final marca = (produto['brand'] ?? 'Sem marca') as String;

        double preco = 0.0;
        String? imagemUrl;

        final items = produto['items'] as List<dynamic>?;
        if (items != null && items.isNotEmpty) {
          final primeiroItem = items.first as Map<String, dynamic>;

          final imagens = primeiroItem['images'] as List<dynamic>?;
          if (imagens != null && imagens.isNotEmpty) {
            final primeiraImg = imagens.first as Map<String, dynamic>;
            imagemUrl = primeiraImg['imageUrl'] as String?;
          }

          final sellers = primeiroItem['sellers'] as List<dynamic>?;
          if (sellers != null && sellers.isNotEmpty) {
            final oferta =
                (sellers.first as Map<String, dynamic>)['commertialOffer']
                    as Map<String, dynamic>?;
            preco = (oferta?['Price'] as num?)?.toDouble() ?? 0.0;
          }
        }

        return Esmalte(
          nome: nome,
          marca: marca,
          preco: preco,
          imagemUrl: imagemUrl,
        );
      }).toList();
    } catch (_) {
      _erro = 'Não foi possível carregar os esmaltes da loja.';
    } finally {
      _carregando = false;
      notifyListeners();
    }
  }

  Future<void> tentarNovamente() => buscar(_ultimaBusca);

  /// Salva um esmalte cadastrado manualmente no catálogo pessoal do usuário.
  Future<void> adicionarEsmalte(Esmalte esmalte) async {
    final uid = _uidAtual;
    if (uid == null) {
      throw Exception('Usuário não autenticado.');
    }

    await _colecaoPessoal.add(esmalte.toMapCatalogoPessoal(uid));
  }

  /// Remove um esmalte do catálogo pessoal do usuário no Firestore.
  Future<void> removerEsmaltePessoal(Esmalte esmalte) async {
    if (esmalte.id == null) {
      throw Exception('Identificador do esmalte não encontrado.');
    }

    await _colecaoPessoal.doc(esmalte.id).delete();
  }

  @override
  void dispose() {
    _assinaturaPessoal?.cancel();
    UsuarioRepository.usuarioAtual.removeListener(_aoAlterarUsuario);
    super.dispose();
  }
}
