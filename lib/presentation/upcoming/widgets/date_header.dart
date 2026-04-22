import 'package:flutter/material.dart';
import 'package:movrev/core/utils/utils.dart';

class DateHeader extends StatelessWidget {
  final String label;
  final String groupKey;
  final GroupMode mode;
  const DateHeader({
    super.key,
    required this.label,
    required this.groupKey,
    required this.mode,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    //Upcoming = key is in the future
    final isUpcoming =
        groupKey != 'Unknown' &&
        MovieGroupingUtils.isGroupInFuture(groupKey, DateTime.now());
    return Padding(padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isUpcoming ? colorScheme.primary : colorScheme.outline,
            ),
          ),
          const SizedBox(width: 10),
          Flexible(
            child: Text(
              label,
              style: theme.textTheme.labelLarge?.copyWith(
                color: isUpcoming
                    ? colorScheme.primary
                    : colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.4,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Divider(color: colorScheme.outlineVariant, thickness: 1),
          ),
      ],
    ),
    );
  }
}
