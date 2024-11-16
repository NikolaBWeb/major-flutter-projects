import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neuroblast_dashboard/providers/content_provider.dart';
import 'package:neuroblast_dashboard/screens/analytics/analytics_screen.dart';
import 'package:neuroblast_dashboard/screens/patients/add_patients.dart';
import 'package:neuroblast_dashboard/screens/patients/patients.dart';
import 'package:neuroblast_dashboard/screens/settings/settings.dart';
import 'package:neuroblast_dashboard/widgets/button/text_button_hover.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  // bool _isDropdownVisible = false; // Track dropdown visibility

  // Future<void> _reloadUser() async {
  //   try {
  //     await FirebaseAuth.instance.currentUser?.reload();
  //   } catch (e) {
  //     debugPrint('Error reloading user: $e');
  //   }
  // }

  // void _toggleDropdown() {
  //   setState(() {
  //     _isDropdownVisible = !_isDropdownVisible;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    // Future.microtask(_reloadUser);

    final content = ref.watch(contentProvider).content;

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 600) {
          // Mobile layout
          return Scaffold(
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(kToolbarHeight + 2),
              child: Column(
                children: [
                  AppBar(
                    backgroundColor:
                        Theme.of(context).appBarTheme.backgroundColor,
                    automaticallyImplyLeading: false,
                    title: Row(
                      children: [
                        Image.asset(
                          'assets/logo/NeuroBLAST - Symbol (Black).png',
                          height: 25,
                          color: Theme.of(context)
                              .appBarTheme
                              .titleTextStyle
                              ?.color,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'Dashboard',
                          style: TextStyle(
                            color: Theme.of(context)
                                .appBarTheme
                                .titleTextStyle
                                ?.color,
                            fontWeight: FontWeight.w500,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 1,
                    color: Colors.grey[300], // Adjust color as needed
                  ),
                ],
              ),
            ),
            endDrawer: Drawer(
              child: ListView(
                children: [
                  UserAccountsDrawerHeader(
                    accountName: Text(
                      FirebaseAuth.instance.currentUser?.displayName ?? 'User',
                    ),
                    accountEmail:
                        Text(FirebaseAuth.instance.currentUser?.email ?? ''),
                  ),
                  ListTile(
                    leading: const Icon(Icons.person),
                    title: const Text('Profile'),
                    onTap: () {
                      // Handle profile tap
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.settings),
                    title: const Text('Settings'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SettingsScreen(),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.logout),
                    title: const Text('Logout'),
                    onTap: () async {
                      await FirebaseAuth.instance.signOut();
                    },
                  ),
                ],
              ),
            ),
            body: Center(
              child: _buildContent(content),
            ),
            bottomNavigationBar: BottomNavigationBar(
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.people),
                  label: 'Patients',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.analytics),
                  label: 'Analytics',
                ),
              ],
              currentIndex:
                  (content == 'Patients' || content == 'Add Patients') ? 0 : 1,
              onTap: (index) {
                if (index == 0) {
                  ref.read(contentProvider.notifier).updateContent('Patients');
                } else {
                  ref.read(contentProvider.notifier).updateContent('Analytics');
                }
              },
            ),
          );
        } else {
          // Desktop layout
          return Scaffold(
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(kToolbarHeight + 2),
              child: Column(
                children: [
                  AppBar(
                    backgroundColor:
                        Theme.of(context).appBarTheme.backgroundColor,
                    automaticallyImplyLeading: false,
                    title: Row(
                      children: [
                        Image.asset(
                          'assets/logo/NeuroBLAST - Symbol (Black).png',
                          height: 25,
                          color: Theme.of(context)
                              .appBarTheme
                              .titleTextStyle
                              ?.color,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'Dashboard',
                          style: TextStyle(
                            color: Theme.of(context)
                                .appBarTheme
                                .titleTextStyle
                                ?.color,
                            fontWeight: FontWeight.w500,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 1,
                    color: Colors.grey[300], // Adjust color as needed
                  ),
                ],
              ),
            ),
            endDrawer: Drawer(
              child: ListView(
                children: [
                  UserAccountsDrawerHeader(
                    accountName: Text(
                      FirebaseAuth.instance.currentUser?.displayName ?? 'User',
                    ),
                    accountEmail:
                        Text(FirebaseAuth.instance.currentUser?.email ?? ''),
                  ),
                  ListTile(
                    leading: const Icon(Icons.person),
                    title: const Text('Profile'),
                    onTap: () {
                      // Handle profile tap
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.settings),
                    title: const Text('Settings'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SettingsScreen(),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.logout),
                    title: const Text('Logout'),
                    onTap: () async {
                      await FirebaseAuth.instance.signOut();
                    },
                  ),
                ],
              ),
            ),
            body: Stack(
              children: [
                Row(
                  children: [
                    Container(
                      width: 200,
                      color: Theme.of(context).colorScheme.surface,
                      child: Column(
                        children: [
                          const SizedBox(height: 20),
                          _buildNavButton(
                            ref,
                            'Patients',
                            Icons.people,
                            content,
                          ),
                          _buildNavButton(
                            ref,
                            'Analytics',
                            Icons.analytics,
                            content,
                          ),
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
          );
        }
      },
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
