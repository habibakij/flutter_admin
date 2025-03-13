import 'package:flutter/material.dart';
import 'package:flutter_admin_app/ui/new_place.dart';
import 'package:flutter_admin_app/ui/profile.dart';
import 'package:flutter_admin_app/ui/settings.dart';
import 'package:get/get.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final RxBool isDarkMode = false.obs;

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => GetMaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          themeMode: isDarkMode.value ? ThemeMode.dark : ThemeMode.light,
          home: AdminPanel(isDarkMode: isDarkMode),
        ));
  }
}

class AdminPanel extends StatefulWidget {
  final RxBool isDarkMode;
  const AdminPanel({super.key, required this.isDarkMode});

  @override
  // ignore: library_private_types_in_public_api
  _AdminPanelState createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  String selectedMenu = 'Profile Update';

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          appBar: AppBar(
            toolbarHeight: 70,
            backgroundColor: const Color(0xFF144CA1),
            title: const Text(
              "Travel Guide Admin Panel",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
          ),
          drawer: constraints.maxWidth > 800
              ? null
              : Drawer(
                  child: ListView(
                    children: [
                      DrawerHeader(
                        child: Center(
                          child: Text(
                            "Admin Panel",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color:
                                  Theme.of(context).textTheme.bodyLarge?.color,
                            ),
                          ),
                        ),
                      ),
                      ListTile(
                        title: Text(
                          "Profile Update",
                          style: TextStyle(
                            color: Theme.of(context).textTheme.bodyLarge?.color,
                          ),
                        ),
                        onTap: () =>
                            setState(() => selectedMenu = 'Profile Update'),
                      ),
                      ListTile(
                        title: Text(
                          "Add New Place",
                          style: TextStyle(
                            color: Theme.of(context).textTheme.bodyLarge?.color,
                          ),
                        ),
                        onTap: () =>
                            setState(() => selectedMenu = 'Add New Place'),
                      ),
                      ListTile(
                        title: Text(
                          "Settings",
                          style: TextStyle(
                            color: Theme.of(context).textTheme.bodyLarge?.color,
                          ),
                        ),
                        onTap: () => setState(() => selectedMenu = 'Settings'),
                      ),
                    ],
                  ),
                ),
          body: Padding(
            padding: const EdgeInsets.only(top: 30.0, left: 12.0, right: 12.0),
            child: Row(
              children: [
                if (constraints.maxWidth > 800)
                  Padding(
                    padding: const EdgeInsets.only(right: 12.0),
                    child: SizedBox(
                      width: 500,
                      child: ListView(
                        children: [
                          _buildDrawerItem("Profile Update"),
                          const SizedBox(height: 12.0),
                          _buildDrawerItem("Add New Place"),
                          const SizedBox(height: 12.0),
                          _buildDrawerItem("Settings"),
                        ],
                      ),
                    ),
                  ),
                Expanded(
                  child: selectedMenu == 'Profile Update'
                      ? ProfileUpdateScreen()
                      : selectedMenu == 'Add New Place'
                          ? const AddNewPlaceScreen()
                          : SettingsScreen(isDarkMode: widget.isDarkMode),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDrawerItem(String title) {
    return InkWell(
      borderRadius: const BorderRadius.all(Radius.circular(30.0)),
      child: AnimatedContainer(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        duration: const Duration(milliseconds: 500),
        height: 60.0,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selectedMenu == title ? const Color(0xFF144CA1) : Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(30.0)),
        ),
        padding: const EdgeInsets.only(left: 24.0, right: 24.0),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                    fontSize: 20.0,
                    color: selectedMenu == title ? Colors.white : Colors.black,
                    fontWeight: selectedMenu == title
                        ? FontWeight.bold
                        : FontWeight.normal),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 24,
              color: selectedMenu == title
                  ? Colors.white
                  : const Color(0xFF144CA1),
            ),
          ],
        ),
      ),
      onTap: () => setState(() => selectedMenu = title),
    );
  }
}
