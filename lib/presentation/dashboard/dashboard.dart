import 'package:bloc_quiz/presentation/dashboard/result/results_screen.dart';
import 'package:bloc_quiz/presentation/library/library_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/auth/auth_bloc.dart';
import '../Profile/profile.dart';
import '../auth/sign_in/sign_in.dart';
import '../settings/settings_screen.dart';
import 'categories/categories_screen.dart';

import '../questions/questions_screen.dart';


class Dashboard extends StatefulWidget {
  final User currentUser;
  const Dashboard(this.currentUser);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _currentIndex = 0; // Индекс текущего выбранного элемента в `BottomNavigationBar`

  @override
  Widget build(BuildContext context) {
    // Создаем список виджетов для переключения
    final List<Widget> _screens = [
      const Categories(),
      Results(),
      QuestionsScreen(),
      LibraryScreen()
    ];

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Тренажер',
          style: TextStyle(
            fontSize: 24,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Здесь добавьте навигацию к экрану настроек
              // Например:
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => SettingsScreen()));
            },
          ),
          IconButton(
            icon: const Icon(Icons.account_circle_rounded),
            onPressed: () {
              // Здесь добавьте навигацию к экрану настроек
              // Например:
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => Profile()));
            },
          ),
        ],
      ),

      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(color: Colors.black),
              accountName: Text(
                '${widget.currentUser.displayName}',
                style: const TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                ),
              ),
              accountEmail: Text(
                '${widget.currentUser.email}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              currentAccountPicture: widget.currentUser.photoURL != null
                  ? Image.network("${widget.currentUser.photoURL}")
                  : const FlutterLogo(),
            ),
            ListTile(
              leading: const Icon(
                Icons.contact_page,
              ),
              title: const Text(
                'Мой профиль',
                style: TextStyle(fontSize: 20),
              ),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => Profile(),
                  ),
                );
              },
            ),
            const AboutListTile(
              icon: Icon(Icons.info),
              child: Text(
                'О приложении',
                style: TextStyle(fontSize: 20),
              ),
              applicationIcon: Icon(Icons.task_alt),
              applicationName: 'BLoC Quiz',
              applicationVersion: '1.0.0',
              applicationLegalese: 'verge',
              aboutBoxChildren: [],
            ),
            ListTile(
              leading: const Icon(Icons.logout_rounded),
              title: const Text(
                'Выйти из аккаунта',
                style: TextStyle(fontSize: 20),
              ),
              onTap: () {
                context.read<AuthBloc>().add(SignOutRequested());
              },
            ),
          ],
        ),
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is UnAuthenticated) {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => SignIn()),
                  (route) => false,
            );
          }
        },
        child: _screens[_currentIndex], // Показываем текущий выбранный экран
      ),

      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          HapticFeedback.selectionClick(); // Добавляем хаптик отклик
          setState(() {
            _currentIndex = index;
          });
        },
        indicatorColor: Theme.of(context).colorScheme.onPrimary,
        selectedIndex: _currentIndex,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: 'Главная',
          ),
          NavigationDestination(
            icon: Icon(Icons.stacked_line_chart),
            label: 'Статистика',
          ),
          NavigationDestination(
            icon: Icon(Icons.list_alt_outlined),
            label: 'Вопросы',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.local_library),
            icon: Icon(Icons.local_library_outlined),
            label: 'Библиотека',
          ),
        ],
      ),




    );
  }
}
