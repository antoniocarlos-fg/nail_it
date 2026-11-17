import 'package:flutter/material.dart';

/// Exibe a imagem do esmalte via URL ou o ícone padrão como fallback.
class EsmalteImagem extends StatelessWidget {
  final String? imagemUrl;
  final double iconSize;
  final BoxFit fit;

  const EsmalteImagem({
    super.key,
    required this.imagemUrl,
    this.iconSize = 48,
    this.fit = BoxFit.cover,
  });

  Widget _fallback() {
    return Center(
      child: Icon(
        Icons.brush,
        size: iconSize,
        color: Colors.red[900],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final url = imagemUrl?.trim();
    if (url == null || url.isEmpty) {
      return _fallback();
    }

    return Image.network(
      Uri.encodeFull(url),
      fit: fit,
      width: double.infinity,
      height: double.infinity,
      errorBuilder: (_, _, _) => _fallback(),
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Center(
          child: SizedBox(
            width: iconSize * 0.5,
            height: iconSize * 0.5,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Colors.red[900],
            ),
          ),
        );
      },
    );
  }
}
