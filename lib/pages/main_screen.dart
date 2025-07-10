import 'package:expenseapp/methods/expenses_data.dart';
import 'package:expenseapp/pages/home_page.dart';
import 'package:expenseapp/pages/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  // List of screens to display
  final List<Widget> _screens = [
      //HomePage
      HomePage(),
      //SettingsPage
      SettingsPage()

  ];

  @override
  void initState() {
    super.initState();

    // Load expenses for the logged-in user
    Future.microtask(() {
      final provider = Provider.of<ExpensesData>(context, listen: false);
      provider.prepare();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Theme.of(context).colorScheme.primary,
          unselectedItemColor: const Color.fromARGB(224, 103, 112, 115),
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
              
            ),
          ],
        ),
    );
  }
}