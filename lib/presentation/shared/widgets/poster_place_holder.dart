import 'package:flutter/material.dart';

class PosterPlaceHolder extends StatelessWidget {
  const PosterPlaceHolder({super.key});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context).colorScheme;
    return Container(
      color: theme.surfaceContainerHighest,
      child: Center(
        child: Icon(
          Icons.movie_outlined,
          color: theme.onSurfaceVariant.withValues(alpha: 0.4),
          size: 48,
        ),
      ),
    );
  }
}
