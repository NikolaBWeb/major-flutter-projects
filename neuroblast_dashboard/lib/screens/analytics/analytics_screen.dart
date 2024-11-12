import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:neuroblast_dashboard/widgets/analytics/analytics_grid.dart';

class AnalyticsScreen extends ConsumerWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Icon(
              Icons.analytics_outlined,
              color: Theme.of(context).colorScheme.secondary,
              size: 30,
            ),
            const SizedBox(width: 10),
            Text(
              'ANALYTICS',
              style: TextStyle(
                color: Theme.of(context).appBarTheme.titleTextStyle?.color,
              ),
            ),
          ],
        ),
      ),
      body: const Center(
        child: ChartsGrid(),
      ),
    );
  }
}
