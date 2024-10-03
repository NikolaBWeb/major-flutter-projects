import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neuroblast_dashboard/providers/content_provider.dart';
import 'package:neuroblast_dashboard/screens/analytics/analytics_screen.dart';
import 'package:neuroblast_dashboard/screens/home/home_screen.dart';
import 'package:neuroblast_dashboard/screens/patients/add_patients.dart';
import 'package:neuroblast_dashboard/screens/patients/patients.dart';
import 'package:neuroblast_dashboard/widgets/button/text_button_hover.dart';
import 'package:neuroblast_dashboard/widgets/patients/patient_details.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  @override
  Widget build(BuildContext context) {
    final content = ref.watch(contentProvider).content;
    print(content);

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
                  const Padding(
                    padding: EdgeInsets.all(8),
                    child: Text(
                      'Dr. John Doe',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              actions: [
                IconButton(
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) => const HomeScreen(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.logout_rounded),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Row(
        children: [
          // Vertical Navigation Bar
          Container(
            width: 200,
            color: Colors.grey[200],
            child: const Column(
              children: [
                SizedBox(height: 20), // Spacer
                HoverTextButton(text: 'Patients', icon: Icons.people),
                HoverTextButton(text: 'Analytics', icon: Icons.analytics),
                // Add more navigation items here as needed
              ],
            ),
          ),
          // Main Content Area
          Expanded(
            child: Center(
              child: content == 'Analytics'
                  ? const AnalyticsScreen()
                  : content == 'Add Patients'
                      ? const AddPatients()
                      : const PatientsScreen(),
            ),
          ),
        ],
      ),
    );
  }
}
