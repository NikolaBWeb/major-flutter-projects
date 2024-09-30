import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neuroblast_dashboard/providers/content_provider.dart';

class HoverTextButton extends ConsumerStatefulWidget {
  const HoverTextButton({required this.text, required this.icon, super.key});
  final String text;
  final IconData icon;

  @override
  _HoverTextButtonState createState() => _HoverTextButtonState();
}

class _HoverTextButtonState extends ConsumerState<HoverTextButton> {
  Color textColor = Colors.black; // Default text color
  bool isActive = false; // To track if the button is in "active" state

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        ref.read(contentProvider.notifier).updateContent(widget.text);
        setState(() {
          isActive = !isActive; // Toggle active state on press
        });
      },
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(
          Colors.transparent,
        ), // Disable background color change
        overlayColor:
            WidgetStateProperty.all(Colors.transparent), // Remove ripple effect
        foregroundColor: WidgetStateProperty.resolveWith<Color>((states) {
          if (isActive) {
            return Colors.blue; // Text color stays red when active
          }
          if (states.contains(WidgetState.hovered)) {
            return Colors.blue; // Text color changes to blue on hover
          }
          return Colors.black; // Default text color
        }),
      ),
      child: Row(
        children: [
          Icon(
            widget.icon,
            color: Theme.of(context).colorScheme.secondary,
            size: 23,
          ),
          const SizedBox(width: 7),
          Text(
            widget.text,
            style: const TextStyle(fontSize: 17),
          ),
        ],
      ),
    );
  }
}
