import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neuroblast_dashboard/screens/home/home_screen.dart';
import 'package:neuroblast_dashboard/providers/content_provider.dart';
import 'package:neuroblast_dashboard/widgets/analytics/analytics_grid.dart';

class AnalyticsScreen extends ConsumerWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Analytics',
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          onPressed: () {
            ref.read(contentProvider.notifier).updateContent('patients');
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: const Center(
        child: ChartsGrid(),
      ),
    );
  }
}
