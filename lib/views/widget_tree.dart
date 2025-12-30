import 'package:application/data/notifiers.dart';
import 'package:application/views/pages/home_page.dart';
import 'package:application/views/pages/favorited_page.dart';
import 'package:application/views/pages/settings_page.dart';
import 'package:flutter/material.dart';
import 'widgets/navbar_widget.dart';

List<Widget> pages = [HomePage(), FavoritedPage()];

class WidgetTree extends StatelessWidget {
  const WidgetTree({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: Text("Unova Pokedex"),
        toolbarHeight: 70,
        title: isDarkModeNotifier.value
            ? Image.asset(
                'assets/images/white_logo.webp',
                fit: BoxFit.cover,
                height: 60.0,
              )
            : Image.asset(
                'assets/images/black_logo.webp',
                fit: BoxFit.cover,
                height: 60.0,
              ),
        actions: [
          IconButton(
            onPressed: () {
              isDarkModeNotifier.value = !isDarkModeNotifier.value;
              saveDarkModeToStorage();
            },
            icon: ValueListenableBuilder(
              valueListenable: isDarkModeNotifier,
              builder: (context, isDarkMode, child) {
                return Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode);
              },
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return SettingsPage();
                  },
                ),
              );
            },
            icon: Icon(Icons.settings),
          ),
        ],
        // centerTitle: true,
      ),
      body: ValueListenableBuilder(
        valueListenable: selectedPageNotifier,
        builder: (context, selectedPage, child) {
          return pages.elementAt(selectedPage);
        },
      ),
      bottomNavigationBar: NavbarWidget(),
    );
  }
}
