import 'package:flutter/material.dart';

class EmptyMessage extends StatelessWidget {
  final String message;
  const EmptyMessage(this.message, {super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.movie_filter_outlined,
            size: 64,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 16),
          Text(message, style: Theme.of(context).textTheme.titleMedium),
        ],
      ),
    );
  }
}
