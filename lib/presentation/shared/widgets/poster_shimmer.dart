import 'package:flutter/material.dart';

class PosterShimmer extends StatelessWidget {
  const PosterShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context).colorScheme;
    return Container(
      color: theme.surfaceContainerHighest,
      child: Center(
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: theme.primary,
          ),
        ),
      ),
    );
  }
}
