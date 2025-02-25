import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

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
  _AdminPanelState createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  String selectedMenu = 'Profile Update';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: LayoutBuilder(
        builder: (context, constraints) {
          return constraints.maxWidth < 800
              ? Drawer(
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
                        title: Text("Add New Place",
                            style: TextStyle(
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.color)),
                        onTap: () =>
                            setState(() => selectedMenu = 'Add New Place'),
                      ),
                      ListTile(
                        title: Text("Settings",
                            style: TextStyle(
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.color)),
                        onTap: () => setState(() => selectedMenu = 'Settings'),
                      ),
                    ],
                  ),
                )
              : const SizedBox();
        },
      ),
      appBar: AppBar(title: const Text("Admin Panel")),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Row(
            children: [
              if (constraints.maxWidth > 800)
                SizedBox(
                  width: 350,
                  child: ListView(
                    children: [
                      ListTile(
                        title: const Text(
                          "Profile Update",
                          style: TextStyle(fontSize: 20),
                        ),
                        onTap: () =>
                            setState(() => selectedMenu = 'Profile Update'),
                      ),
                      ListTile(
                        title: const Text(
                          "Add New Place",
                          style: TextStyle(fontSize: 20),
                        ),
                        onTap: () =>
                            setState(() => selectedMenu = 'Add New Place'),
                      ),
                      ListTile(
                        title: const Text(
                          "Settings",
                          style: TextStyle(fontSize: 20),
                        ),
                        onTap: () => setState(() => selectedMenu = 'Settings'),
                      ),
                    ],
                  ),
                ),
              Expanded(
                  child: selectedMenu == 'Profile Update'
                      ? ProfileUpdateScreen()
                      : selectedMenu == 'Add New Place'
                          ? AddNewPlaceScreen()
                          : SettingsScreen(isDarkMode: widget.isDarkMode)),
            ],
          );
        },
      ),
    );
  }
}

class ProfileUpdateScreen extends StatelessWidget {
  final ImagePicker picker = ImagePicker();
  final Rxn<XFile> profileImage = Rxn<XFile>();

  ProfileUpdateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Profile Update",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const TextField(decoration: InputDecoration(labelText: "First Name")),
          const TextField(decoration: InputDecoration(labelText: "Last Name")),
          const TextField(
              decoration: InputDecoration(labelText: "Phone Number")),
          const TextField(decoration: InputDecoration(labelText: "Email")),
          DropdownButtonFormField(
            items: ["USA", "India", "UK", "Canada"]
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
            onChanged: (value) {},
            decoration: const InputDecoration(labelText: "Nationality"),
          ),
          const SizedBox(height: 10),
          Obx(() => profileImage.value == null
              ? const Text("No Image Selected")
              : Image.network(profileImage.value!.path, height: 100)),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                final pickedFile =
                    await picker.pickImage(source: ImageSource.gallery);
                if (pickedFile != null) {
                  profileImage.value = pickedFile;
                }
              },
              style: ButtonStyle(
                  foregroundColor:
                      WidgetStateProperty.all(const Color(0xFFFFFFFF)),
                  backgroundColor:
                      WidgetStateProperty.all(const Color(0xFF144CA1)),
                  padding: WidgetStateProperty.all(const EdgeInsets.all(20)),
                  textStyle:
                      WidgetStateProperty.all(const TextStyle(fontSize: 20))),
              child: const Text("Select Profile Image"),
            ),
          ),
        ],
      ),
    );
  }
}

class AddNewPlaceScreen extends StatelessWidget {
  final RxList<XFile> selectedImages = <XFile>[].obs;
  final ImagePicker picker = ImagePicker();

  AddNewPlaceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Add New Place",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const TextField(
              decoration: InputDecoration(labelText: "Place Title")),
          const TextField(
              decoration: InputDecoration(labelText: "Place Location")),
          const TextField(
              decoration: InputDecoration(labelText: "Place Details"),
              maxLines: 3),
          const SizedBox(height: 10),
          Obx(() => Wrap(
                spacing: 8,
                runSpacing: 8,
                children: selectedImages
                    .map((image) => Image.network(image.path, height: 100))
                    .toList(),
              )),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                final pickedFiles = await picker.pickMultiImage();
                if (pickedFiles.isNotEmpty) selectedImages.addAll(pickedFiles);
              },
              style: ButtonStyle(
                  foregroundColor:
                      WidgetStateProperty.all(const Color(0xFFFFFFFF)),
                  backgroundColor:
                      WidgetStateProperty.all(const Color(0xFF144CA1)),
                  padding: WidgetStateProperty.all(const EdgeInsets.all(20)),
                  textStyle:
                      WidgetStateProperty.all(const TextStyle(fontSize: 20))),
              child: const Text("Select Images"),
            ),
          ),
        ],
      ),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  final RxBool isDarkMode;
  const SettingsScreen({super.key, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Settings",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          SwitchListTile(
            title: const Text("Enable Notifications"),
            value: true,
            onChanged: (value) {},
          ),
          SwitchListTile(
            title: const Text("Dark Mode"),
            value: isDarkMode.value,
            onChanged: (value) => isDarkMode.value = value,
          ),
        ],
      ),
    );
  }
}
