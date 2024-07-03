import 'package:flutter/material.dart';
import 'package:vulpes/screens/frens/frens_screen.dart';
import 'package:flutter_telegram_web_app/flutter_telegram_web_app.dart' as tg;
import 'package:flutter_telegram_web_app/flutter_telegram_web_app.dart';
import 'package:vulpes/screens/login/login.dart';
import 'package:vulpes/screens/tasks/tasks_screen.dart';
import 'package:vulpes/screens/users/user_screen.dart';
import 'package:vulpes/util/user_operations.dart';

final WebAppInitData webAppInitData = tg.initDataUnsafe;

final HttpService httpService = HttpService();

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  void initState() {
    super.initState();
    tg.expand();
    fetchEmail();
  }

  bool _isLoading = false, isRegistered = false;
  int _selectedIndex = 0;
  int id = webAppInitData.user?.id as int;

  // Метод для обновления выбранного индекса
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  static const List<Widget> _screens = <Widget>[
    UserScreen(),
    TasksScreen(),
    FrensScreen(),
  ];

  fetchEmail() async {
    setState(() {
      _isLoading = true;
    });

    // id = 784937345;

    // print(id);

    if (!mounted) return;

    bool getIsRegistered = await httpService.getUserInfo(id);
    if (getIsRegistered) {
      setState(() {
        isRegistered = true;
        _isLoading = false;
      });
    } else {
      setState(() {
        isRegistered = false;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : isRegistered
            ? Scaffold(
                body: IndexedStack(
                  index: _selectedIndex,
                  children: _screens,
                ),
                bottomNavigationBar: BottomNavigationBar(
                  items: const [
                    BottomNavigationBarItem(
                      icon: Icon(Icons.home),
                      label: 'Home',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.task),
                      label: 'Tasks',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.people),
                      label: 'Frens',
                    ),
                  ],
                  currentIndex: _selectedIndex,
                  onTap: _onItemTapped,
                ),
              )
            : const LoginScreen();
  }
}
