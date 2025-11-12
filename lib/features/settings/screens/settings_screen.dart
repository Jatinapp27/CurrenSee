import 'package:currensee_pkr/data/services/auth_service.dart';
import 'package:currensee_pkr/data/services/firestore_service.dart';
import 'package:currensee_pkr/features/currency_list/screens/currency_list_screen.dart';
import 'package:currensee_pkr/features/settings/screens/help_support_screen.dart';
import 'package:currensee_pkr/features/settings/screens/feedback_screen.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthService authService = AuthService();
    final FirestoreService firestoreService = FirestoreService();
    final theme = Theme.of(context);

    final user = authService.currentUser;

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')), // Profile header
      body: StreamBuilder(
        stream: firestoreService.getUserPreferences(),
        builder: (context, snapshot) {
          String defaultCurrency = 'Loading...';
          if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.hasData && snapshot.data!.exists) {
              final data = snapshot.data!.data() as Map<String, dynamic>;
              defaultCurrency = data['defaultBaseCurrency'] ?? 'USD';
            } else {
              defaultCurrency = 'USD';
            }
          }

          return ListView(
            padding: const EdgeInsets.symmetric(vertical: 8),
            children: [
              ListTile(
                leading: const Icon(Icons.person_outline),
                title: Text(user?.displayName ?? 'Login With Email'), // Username
                subtitle: Text(user?.email ?? ''), // Email
              ),
              ListTile(
                leading: const Icon(Icons.attach_money_outlined),
                title: const Text('Default Base Currency'),
                subtitle: Text(defaultCurrency),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CurrencyListScreen(
                        onCurrencySelected: (currencyCode) {
                          firestoreService.setDefaultBaseCurrency(currencyCode);
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  );
                },
              ),
              const Divider(),

              // Other pages
              ListTile(
                leading: const Icon(Icons.help_outline),
                title: const Text('Help & Support'),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const HelpSupportScreen()),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.feedback_outlined),
                title: const Text('Send Feedback'),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const FeedbackScreen()),
                ),
              ),
              const Divider(),

              // Sign Out
              ListTile(
                leading: Icon(Icons.logout, color: theme.colorScheme.error),
                title: Text(
                  'Sign Out',
                  style: TextStyle(color: theme.colorScheme.error),
                ),
                onTap: () async {
                  await authService.signOut();
                  // Optionally, navigate to login screen
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      '/login', (Route<dynamic> route) => false);
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
