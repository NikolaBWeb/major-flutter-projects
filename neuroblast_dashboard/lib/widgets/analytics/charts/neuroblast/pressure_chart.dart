import 'package:flutter/material.dart';

class PressureData {
  PressureData({
    required this.value,
    required this.color,
    required this.label,
  });
  final int value;
  final Color color;
  final String label;
}

class PressureChart extends StatelessWidget {
  const PressureChart({super.key});

  @override
  Widget build(BuildContext context) {
    final data = [
      PressureData(value: 40, color: Colors.blue, label: 'Front'),
      PressureData(value: 85, color: Colors.orange, label: 'Back'),
      PressureData(value: 69, color: Colors.red, label: 'Right'),
      PressureData(value: 33, color: Colors.indigo, label: 'Left'),
    ];

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          ...data.map(_buildBarRow),
        ],
      ),
    );
  }

  Widget _buildBarRow(PressureData item) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          // Percentage Label
          Container(
            width: 60,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.grey[800],
              borderRadius: BorderRadius.circular(4),
            ),
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
            child: Text(
              '${item.value} %',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Bar Chart
          Expanded(
            child: Stack(
              children: [
                Container(
                  height: 20,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                FractionallySizedBox(
                  widthFactor: item.value / 100,
                  child: Container(
                    height: 20,
                    decoration: BoxDecoration(
                      color: item.color,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // Label
          SizedBox(
            width: 80,
            child: Text(
              item.label,
              style: const TextStyle(
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
