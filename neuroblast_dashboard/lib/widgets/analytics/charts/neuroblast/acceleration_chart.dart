import 'package:flutter/material.dart';

class AccelerationData {
  AccelerationData({
    required this.value,
    required this.color,
    required this.label,
  });
  final int value;
  final Color color;
  final String label;
}

class AccelerationChart extends StatelessWidget {
  const AccelerationChart({super.key});

  @override
  Widget build(BuildContext context) {
    final data = [
      AccelerationData(value: 30, color: Colors.blue, label: 'Right leg'),
      AccelerationData(value: 75, color: Colors.orange, label: 'Left leg'),
      AccelerationData(value: 90, color: Colors.red, label: 'Right hand'),
      AccelerationData(value: 25, color: Colors.indigo, label: 'Left hand'),
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

  Widget _buildBarRow(AccelerationData item) {
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
