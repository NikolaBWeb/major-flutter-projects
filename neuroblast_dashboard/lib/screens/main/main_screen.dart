import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neuroblast_dashboard/providers/content_provider.dart';
import 'package:neuroblast_dashboard/screens/analytics/analytics_screen.dart';
import 'package:neuroblast_dashboard/screens/patients/add_patients.dart';
import 'package:neuroblast_dashboard/screens/patients/patients.dart';
import 'package:neuroblast_dashboard/widgets/button/text_button_hover.dart';

class MainScreen extends ConsumerWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final content = ref.watch(contentProvider).content;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(
          kToolbarHeight + 2, // Increased height to align with the row
        ),
        child: Stack(
          children: [
            AppBar(
              automaticallyImplyLeading: false,
              title: Row(
                children: [
                  Image.asset(
                    'assets/logo/NeuroBLAST - Symbol (Black).png',
                    height: 25,
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'Dashboard',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    style: ButtonStyle(
                      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: const BorderSide(color: Colors.black26),
                        ),
                      ),
                    ),
                    onPressed: () {},
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Row(
                        children: [
                          Text(
                            (FirebaseAuth.instance.currentUser?.displayName ??
                                    'User')
                                .split(' ')
                                .map(
                                  (word) => word.isNotEmpty
                                      ? word[0].toUpperCase()
                                      : '',
                                )
                                .join(),
                            style: const TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Icon(
                            Icons.arrow_drop_down_outlined,
                            color: Colors.black,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              /* actions: [
                IconButton(
                  onPressed: () async {
                    try {
                      await FirebaseAuth.instance.signOut();
                      // Remove the manual navigation
                      // The StreamBuilder in main.dart will handle the navigation
                    } catch (e) {
                      print('Error signing out: $e');
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content:
                                Text('Failed to sign out. Please try again.'),
                          ),
                        );
                      }
                    }
                  },
                  icon: const Icon(Icons.logout_rounded),
                ),
              ], */
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                height: 1,
                color: Colors.grey[300],
              ),
            ),
          ],
        ),
      ),
      body: Row(
        children: [
          Container(
            width: 200,
            color: Colors.white,
            child: Column(
              children: [
                const SizedBox(height: 20),
                _buildNavButton(ref, 'Patients', Icons.people, content),
                _buildNavButton(ref, 'Analytics', Icons.analytics, content),
                // Add more navigation items as needed
              ],
            ),
          ),
          Container(
            width: 1,
            color: Colors.grey[200],
          ),
          Expanded(
            child: Center(
              child: _buildContent(content),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavButton(
    WidgetRef ref,
    String text,
    IconData icon,
    String currentContent,
  ) {
    return HoverTextButton(
      text: text,
      icon: icon,
      isActive: currentContent == text,
      onPressed: () => ref.read(contentProvider.notifier).updateContent(text),
    );
  }

  Widget _buildContent(String content) {
    switch (content) {
      case 'Patients':
        return const PatientsScreen();
      case 'Analytics':
        return const AnalyticsScreen();
      case 'Add Patients':
        return const AddPatients();
      default:
        return const SizedBox.shrink();
    }
  }
}
