import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

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
                          ? AddNewPlaceScreen()
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

class ProfileUpdateScreen extends StatelessWidget {
  final ImagePicker picker = ImagePicker();
  final Rxn<XFile> profileImage = Rxn<XFile>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController phoneNameController = TextEditingController();
  TextEditingController emailNameController = TextEditingController();

  ProfileUpdateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 60.0,
              width: double.infinity,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                  color: Color(0xFF144CA1),
                  borderRadius: BorderRadius.all(Radius.circular(30.0))),
              child: const Text(
                "Profile",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 24),
            _textInputWidget(
                conntroller: firstNameController, labelText: "First Name"),
            const SizedBox(height: 16),
            _textInputWidget(
                conntroller: lastNameController, labelText: "Last Name"),
            const SizedBox(height: 16),
            _textInputWidget(
                conntroller: phoneNameController, labelText: "Phone"),
            const SizedBox(height: 16),
            _textInputWidget(
                conntroller: emailNameController, labelText: "Email"),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              items: ["Bangladesh", "Saudi Arabia", "Pakistan", "Palestine"]
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (value) {},
              decoration: InputDecoration(
                labelText: "Nationality",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(color: Colors.blue, width: 2),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(color: Colors.red),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(color: Colors.red, width: 2),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              ),
            ),
            const SizedBox(height: 10),
            Obx(() => profileImage.value == null
                ? const Text("No Image Selected")
                : Image.network(profileImage.value!.path, height: 100)),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () async {
                final pickedFile =
                    await picker.pickImage(source: ImageSource.gallery);
                if (pickedFile != null) {
                  profileImage.value = pickedFile;
                }
              },
              style: ButtonStyle(
                  foregroundColor:
                      WidgetStateProperty.all(const Color(0xFF144CA1)),
                  padding: WidgetStateProperty.all(const EdgeInsets.all(20)),
                  textStyle:
                      WidgetStateProperty.all(const TextStyle(fontSize: 16))),
              child: const Text("Select Profile Image"),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Get.snackbar("Success", "Profile updated successfully!");
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
                child: const Text("Submit"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _textInputWidget(
      {TextEditingController? conntroller, String labelText = ''}) {
    return TextFormField(
      controller: conntroller,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: Colors.blue, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Field can't be empty";
        }

        return null;
      },
    );
  }
}

class AddNewPlaceScreen extends StatelessWidget {
  final RxList<XFile> selectedImages = <XFile>[].obs;
  final ImagePicker picker = ImagePicker();

  AddNewPlaceScreen({super.key});

  TextEditingController titleController = TextEditingController();

  TextEditingController locationController = TextEditingController();

  TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 60.0,
            width: double.infinity,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
                color: Color(0xFF144CA1),
                borderRadius: BorderRadius.all(Radius.circular(30.0))),
            child: const Text(
              "Add New Place",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 24),
          _textInputWidget(
              conntroller: titleController, labelText: "Place Title"),
          const SizedBox(height: 16),
          _textInputWidget(
              conntroller: locationController, labelText: "Place Location"),
          const SizedBox(height: 16),
          _textInputWidget(
              conntroller: descriptionController,
              labelText: "Place Details",
              maxLine: 3),
          const SizedBox(height: 16),
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

  _textInputWidget(
      {TextEditingController? conntroller,
      String labelText = '',
      int maxLine = 1}) {
    return TextFormField(
      controller: conntroller,
      keyboardType: TextInputType.text,
      maxLines: maxLine,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: Colors.blue, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Field can't be empty";
        }

        return null;
      },
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
          Container(
            height: 60.0,
            width: double.infinity,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
                color: Color(0xFF144CA1),
                borderRadius: BorderRadius.all(Radius.circular(30.0))),
            child: const Text(
              "Settings",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 24),
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
