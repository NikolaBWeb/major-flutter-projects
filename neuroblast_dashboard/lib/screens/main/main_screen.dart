import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:neuroblast_dashboard/providers/content_provider.dart';
import 'package:neuroblast_dashboard/screens/analytics/analytics_screen.dart';
import 'package:neuroblast_dashboard/screens/patients/add_patients.dart';
import 'package:neuroblast_dashboard/screens/patients/patients.dart';
import 'package:neuroblast_dashboard/screens/settings/settings.dart';
import 'package:neuroblast_dashboard/widgets/button/text_button_hover.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:neuroblast_dashboard/widgets/patients/patient_search_bar.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  bool _isDropdownVisible = false;
  bool _isDarkMode = false; // Track dark mode state

  Future<void> _reloadUser() async {
    try {
      await FirebaseAuth.instance.currentUser?.reload();
    } catch (e) {
      debugPrint('Error reloading user: $e');
    }
  }

  void _toggleDropdown() {
    setState(() {
      _isDropdownVisible = !_isDropdownVisible;
    });
  }

  // Toggle dark mode state
  void _toggleDarkMode(bool value) {
    setState(() {
      _isDarkMode = value; // Use the provided value instead of toggling
    });
  }

  @override
  Widget build(BuildContext context) {
    Future.microtask(_reloadUser);

    final content = ref.watch(contentProvider).content;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight + 2),
        child: AppBar(
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          automaticallyImplyLeading: false,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1),
            child: Container(
              color: Colors.grey[300],
              height: 1,
            ),
          ),
          title: Row(
            children: [
              Image.asset(
                'assets/logo/NeuroBLAST - Symbol (Black).png',
                height: 25,
                color: Theme.of(context).appBarTheme.titleTextStyle?.color,
              ),
              const SizedBox(width: 10),
              Text(
                'Dashboard',
                style: TextStyle(
                  color: Theme.of(context).appBarTheme.titleTextStyle?.color,
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: _toggleDropdown,
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    children: [
                      FutureBuilder(
                        future: _reloadUser(),
                        builder: (context, snapshot) {
                          return Text(
                            FirebaseAuth.instance.currentUser?.displayName ??
                                'User',
                            style: TextStyle(
                              fontSize: 20,
                              color: Theme.of(context)
                                  .appBarTheme
                                  .titleTextStyle
                                  ?.color,
                              fontWeight: FontWeight.normal,
                            ),
                          );
                        },
                      ),
                      const SizedBox(width: 10),
                      Icon(
                        Icons.arrow_drop_down_outlined,
                        color:
                            Theme.of(context).appBarTheme.titleTextStyle?.color,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
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
          if (_isDropdownVisible)
            Positioned(
              top: 0,
              right: 30,
              child: Material(
                elevation: 4,
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Theme.of(context).colorScheme.surface,
                  ),
                  width: 150,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextButton(
                        onPressed: _toggleDropdown,
                        child: Row(
                          children: [
                            Icon(
                              Icons.person,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              'Profile',
                              style: TextStyle(
                                color: Theme.of(context)
                                    .appBarTheme
                                    .titleTextStyle
                                    ?.color,
                              ),
                            ),
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: _toggleDropdown,
                        child: Row(
                          children: [
                            Icon(
                              Icons.settings,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                            TextButton(
                              onPressed: () {
                                /* showDialog<dynamic>(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return SafeArea(
                                      child: Container(
                                        padding: EdgeInsets.zero,
                                        child: Dialog(
                                          shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(10),
                                            ),
                                          ),
                                          child: Container(
                                            padding: const EdgeInsets.all(15),
                                            child: const SizedBox(
                                              width: 300,
                                              height: 400,
                                              child: SettingsScreen(),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ); */
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const SettingsScreen(),
                                  ),
                                );
                              },
                              child: Text(
                                'Settings',
                                style: TextStyle(
                                  color: Theme.of(context)
                                      .appBarTheme
                                      .titleTextStyle
                                      ?.color,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: () async {
                          await FirebaseAuth.instance.signOut();
                        },
                        child: Row(
                          children: [
                            Icon(
                              Icons.logout,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              'Logout',
                              style: TextStyle(
                                color: Theme.of(context)
                                    .appBarTheme
                                    .titleTextStyle
                                    ?.color,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
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
