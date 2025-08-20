import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:go_router/go_router.dart';
import 'package:nnf/provider/habit_provider.dart';
import 'dart:io';
import 'package:nnf/routes/route_names.dart';

class Register extends HookConsumerWidget {
  const Register({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usernameController = useTextEditingController();
    final userImage = useState<File?>(null);
    final successImage = useState<File?>(null);
    final failureImage = useState<File?>(null);
    final picker = ImagePicker();

    Future<File?> pickImage() async {
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      
      if (image != null) {
        return File(image.path);
      }
      return null;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Username field
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: usernameController,
                decoration: const InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            
            // User profile image
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Text('Profile Picture', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () async {
                      final image = await pickImage();
                      if (image != null) {
                        userImage.value = image;
                      }
                    },
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey),
                      ),
                      child: userImage.value != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.file(
                                userImage.value!,
                                fit: BoxFit.cover,
                              ),
                            )
                          : const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.add_a_photo, size: 40, color: Colors.grey),
                                Text('Tap to add photo'),
                              ],
                            ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Success motivational image
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Text('Success Motivation Photo', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const Text('(Shown when you stay clean)', style: TextStyle(fontSize: 12, color: Colors.grey)),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () async {
                      final image = await pickImage();
                      if (image != null) {
                        successImage.value = image;
                      }
                    },
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.green[100],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.green),
                      ),
                      child: successImage.value != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.file(
                                successImage.value!,
                                fit: BoxFit.cover,
                              ),
                            )
                          : const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.add_a_photo, size: 40, color: Colors.green),
                                Text('Success Photo', textAlign: TextAlign.center),
                              ],
                            ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Failure motivation image
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Text('Motivation Photo', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const Text('(Shown when you fail)', style: TextStyle(fontSize: 12, color: Colors.grey)),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () async {
                      final image = await pickImage();
                      if (image != null) {
                        failureImage.value = image;
                      }
                    },
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.red[100],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.red),
                      ),
                      child: failureImage.value != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.file(
                                failureImage.value!,
                                fit: BoxFit.cover,
                              ),
                            )
                          : const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.add_a_photo, size: 40, color: Colors.red),
                                Text('Motivation Photo', textAlign: TextAlign.center),
                              ],
                            ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Register button
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  // Validate inputs
                  if (usernameController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please enter a username')),
                    );
                    return;
                  }
                  
                  if (userImage.value == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please add your profile picture')),
                    );
                    return;
                  }
                  
                  if (successImage.value == null || failureImage.value == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please add both motivational photos')),
                    );
                    return;
                  }
                  
                  ref.read(habitProvider.notifier).registerUser(
                    username: usernameController.text,
                    userImagePath: userImage.value!.path,
                    successImagePath: successImage.value!.path,
                    failureImagePath: failureImage.value!.path,
                  );
                  context.goNamed(AppRouteNames.dashboard);
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(200, 50),
                ),
                child: const Text('Register', style: TextStyle(fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
