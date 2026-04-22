import 'package:flutter/material.dart';
import 'package:movrev/domain/entities/movie.dart';

class RatingBadge extends StatelessWidget {
  final Movie movie;
  final bool isTopRatedd;
  const RatingBadge(this.movie, {super.key, this.isTopRatedd = false});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: theme.surface,
        borderRadius: BorderRadius.circular(8),
      ),
      child: !isTopRatedd ?Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.star_rounded, size: 14, color: theme.secondary),
          const SizedBox(width: 2),
          Text(
            movie.voteAverage!.toStringAsFixed(1),
            style: TextStyle(
              color: theme.secondary,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ) : Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.star_rounded, size: 14, color: theme.secondary),
          const SizedBox(width: 2),
          Text(
            movie.voteAverage!.toStringAsFixed(1),
            style: TextStyle(
              color: theme.secondary,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
