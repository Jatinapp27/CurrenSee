import 'package:currensee_pkr/features/converter/screens/converter_screen.dart';
import 'package:currensee_pkr/features/history/screens/history_screen.dart';
import 'package:currensee_pkr/features/settings/screens/market_news_screen.dart';
import 'package:currensee_pkr/features/settings/screens/settings_screen.dart'; // keep if using SettingsScreen/ProfileScreen
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  // Remove 'const' because the widgets are not all const
  final List<Widget> _widgetOptions = [
    ConverterScreen(),
    HistoryScreen(),
    MarketNewsScreen(),
    SettingsScreen(), // or ProfileScreen() if you renamed it
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        // Keeps state of each tab
        index: _selectedIndex,
        children: _widgetOptions,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.compare_arrows_outlined),
            activeIcon: Icon(Icons.compare_arrows),
            label: 'Converter',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history_outlined),
            activeIcon: Icon(Icons.history),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.article_outlined),
            activeIcon: Icon(Icons.article),
            label: 'Market News',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outlined),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
