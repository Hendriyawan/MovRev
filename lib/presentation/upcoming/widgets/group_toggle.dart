import 'package:flutter/material.dart';
import 'package:movrev/core/utils/utils.dart';

class GroupToggle extends StatelessWidget {
  final GroupMode current;
  final ValueChanged<GroupMode> onChanged;
  const GroupToggle(this.current, this.onChanged, {super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(3),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Chip(
            label: 'Week',
            selected: current == GroupMode.week,
            onTap: () => onChanged(GroupMode.week),
          ),
          Chip(
            label: 'Month',
            selected: current == GroupMode.month,
            onTap: () => onChanged(GroupMode.month),
          ),
        ],
      ),
    );
  }
}

class Chip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const Chip({super.key, 
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? colorScheme.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(17),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected
                ? colorScheme.onPrimary
                : colorScheme.onSurfaceVariant,
            fontSize: 12,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
