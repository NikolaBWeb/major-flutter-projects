import 'package:flutter/material.dart';

class HoverTextButton extends StatelessWidget {
  const HoverTextButton({
    required this.text,
    required this.icon,
    required this.isActive,
    required this.onPressed,
    super.key,
  });

  final String text;
  final IconData icon;
  final bool isActive;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(Colors.transparent),
        overlayColor: WidgetStateProperty.all(Colors.transparent),
        foregroundColor: WidgetStateProperty.resolveWith<Color>((states) {
          if (isActive) {
            return Colors.blue;
          }
          if (states.contains(WidgetState.hovered)) {
            return Colors.blue;
          }
          return Theme.of(context).appBarTheme.titleTextStyle?.color ??
              Colors.black;
        }),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: Theme.of(context).colorScheme.secondary,
            size: 23,
          ),
          const SizedBox(width: 7),
          Text(
            text,
            style: const TextStyle(fontSize: 17),
          ),
        ],
      ),
    );
  }
}
