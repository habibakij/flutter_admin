import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';

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
    return SingleChildScrollView(
      child: Padding(
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
                  borderRadius: BorderRadius.all(Radius.circular(4.0)),
                ),
                child: const Text(
                  "Profile",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 24),
              _textInputWidget(
                  controller: firstNameController, labelText: "First Name"),
              const SizedBox(height: 24),
              _textInputWidget(
                  controller: lastNameController, labelText: "Last Name"),
              const SizedBox(height: 24),
              _textInputWidget(
                  controller: phoneNameController, labelText: "Phone"),
              const SizedBox(height: 24),
              _textInputWidget(
                  controller: emailNameController, labelText: "Email"),
              const SizedBox(height: 24),
              SizedBox(
                width: 600.0,
                child: DropdownButtonFormField<String>(
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
                      borderSide:
                          const BorderSide(color: Colors.blue, width: 2),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: const BorderSide(color: Colors.red),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: const BorderSide(color: Colors.red, width: 2),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 16),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(() => profileImage.value == null
                      ? Image.asset(
                          "assets/images/person_placeholder.png",
                          height: 200.0,
                          width: 200.0,
                          fit: BoxFit.contain,
                        )
                      : Image.network(
                          profileImage.value!.path,
                          height: 200.0,
                          width: 200.0,
                          fit: BoxFit.contain,
                        )),
                  const SizedBox(width: 40.0),
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
                      padding:
                          WidgetStateProperty.all(const EdgeInsets.all(20)),
                      textStyle: WidgetStateProperty.all(
                          const TextStyle(fontSize: 16)),
                    ),
                    child: const Text("Select Profile Image"),
                  ),
                ],
              ),
              const SizedBox(height: 50.0),
              SizedBox(
                width: 400.0,
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
                      padding:
                          WidgetStateProperty.all(const EdgeInsets.all(20)),
                      textStyle: WidgetStateProperty.all(
                          const TextStyle(fontSize: 20))),
                  child: const Text("Submit"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _textInputWidget({TextEditingController? controller, String labelText = ''}) {
    return SizedBox(
      width: 600.0,
      child: TextFormField(
        controller: controller,
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
          if (value == null || value.trim().isEmpty) {
            return "Field can't be empty";
          }
          return null;
        },
      ),
    );
  }
}
