import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class AddNewPlaceScreen extends StatefulWidget {
  const AddNewPlaceScreen({super.key});

  @override
  State<AddNewPlaceScreen> createState() => _AddNewPlaceScreenState();
}

class _AddNewPlaceScreenState extends State<AddNewPlaceScreen> {
  final RxList<XFile> selectedImages = <XFile>[].obs;
  final ImagePicker picker = ImagePicker();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController titleController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  Future<void> _dataPostRequest() async {
    if (selectedImages.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select images to upload")),
      );
      return;
    }

    var uri = Uri.parse("http://localhost:3000/add_new_place");
    var request = http.MultipartRequest("POST", uri);
    request.fields["placeTitle"] = "Beautiful Beach";
    request.fields["placeDes"] = "A wonderful place to visit";
    for (var image in selectedImages) {
      var file = await http.MultipartFile.fromPath("placeImage", image.path);
      request.files.add(file);
    }

    try {
      var response = await request.send();
      var responseBody = await response.stream.bytesToString();
      var jsonResponse = jsonDecode(responseBody);

      if (response.statusCode == 201) {
        Get.snackbar("INFO", "Images uploaded successfully! ✅");
        log("Response: $jsonResponse");
      } else {
        Get.snackbar("INFO", "Upload failed: ${jsonResponse['message']}");
      }
    } catch (error) {
      Get.snackbar("INFO", "An error occurred!");
      log("Error uploading images: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
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
                "Add New Place",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 24),
            _textInputWidget(
                controller: titleController, labelText: "Place Title"),
            const SizedBox(height: 16),
            _textInputWidget(
                controller: locationController, labelText: "Place Location"),
            const SizedBox(height: 16),
            _textInputWidget(
                controller: descriptionController,
                labelText: "Place Details",
                maxLine: 3),
            const SizedBox(height: 16),
            Obx(() => selectedImages.isEmpty
                ? const Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: Text("No images selected",
                        style: TextStyle(fontSize: 18)),
                  )
                : Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: selectedImages
                        .map((image) => ClipRRect(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(24.0)),
                            child: Image.network(image.path, height: 100)))
                        .toList(),
                  )),
            const SizedBox(height: 24),
            SizedBox(
              width: 300.0,
              child: ElevatedButton(
                onPressed: () async {
                  final pickedFiles = await picker.pickMultiImage();
                  if (pickedFiles.isNotEmpty) {
                    selectedImages.addAll(pickedFiles);
                  }
                },
                style: ButtonStyle(
                  foregroundColor:
                      WidgetStateProperty.all(const Color(0xFF144CA1)),
                  padding: WidgetStateProperty.all(const EdgeInsets.all(20)),
                  textStyle:
                      WidgetStateProperty.all(const TextStyle(fontSize: 16)),
                ),
                child: const Text(
                  "Select Images",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
              ),
            ),
            const SizedBox(height: 50.0),
            SizedBox(
              width: 400.0,
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _dataPostRequest();
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
      {TextEditingController? controller,
      String labelText = '',
      int maxLine = 1}) {
    return SizedBox(
      width: 600.0,
      child: TextFormField(
        controller: controller,
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
      ),
    );
  }
}
