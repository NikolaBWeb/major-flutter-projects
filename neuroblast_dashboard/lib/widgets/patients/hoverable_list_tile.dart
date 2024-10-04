import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HoverableListTile extends StatefulWidget {
  const HoverableListTile({
    required this.note,
    required this.createdAt,
    required this.onDelete,
    super.key,
  });
  final String note;
  final Timestamp createdAt;
  final VoidCallback onDelete;

  @override
  State<HoverableListTile> createState() => _HoverableListTileState();
}

class _HoverableListTileState extends State<HoverableListTile> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: ListTile(
          title: Row(
            children: [
              Icon(
                Icons.circle,
                color: Theme.of(context).colorScheme.secondary,
                size: 7,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  widget.note,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const Spacer(), // Add spacer to push delete icon to the end
              if (_isHovered) // Show delete icon on hover
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: widget.onDelete,
                  tooltip: 'Delete note',
                  color: Colors.red,
                  constraints: const BoxConstraints(
                    minWidth: 20,
                    minHeight: 20,
                  ), // Minimize button size
                  padding: EdgeInsets.zero, // Remove padding
                ),
            ],
          ),
          subtitle: Text(
            widget.createdAt.toDate().toString().substring(0, 19),
            style: const TextStyle(fontSize: 12),
          ),
        ),
      ),
    );
  }
}
