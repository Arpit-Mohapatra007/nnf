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
    final phoneNumberController = useTextEditingController();
    final userImage = useState<File?>(null);
    final successImage = useState<File?>(null);
    final failureImage = useState<File?>(null);
    final isLoading = useState(false);
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

    Future<void> handleRegistration() async {
      // Validate inputs
      if (usernameController.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter a username')),
        );
        return;
      }
      
      if (phoneNumberController.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter a phone number')),
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

      isLoading.value = true;
      
      try {
        // Register the user
        ref.read(habitProvider.notifier).registerUser(
          username: usernameController.text.trim(),
          phoneNumber: phoneNumberController.text.trim(),
          userImagePath: userImage.value!.path,
          successImagePath: successImage.value!.path,
          failureImagePath: failureImage.value!.path,
        );
        
        // Show success message
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Welcome, ${usernameController.text.trim()}! Messages will be sent to ${phoneNumberController.text.trim()}.'),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 4),
            ),
          );
          
          // Navigate to welcome page
          context.goNamed(AppRouteNames.welcome);
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Registration failed: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        isLoading.value = false;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome! Let\'s Get Started'),
        centerTitle: true,
        automaticallyImplyLeading: false, // Remove back button
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Welcome message
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.waving_hand,
                        size: 50,
                        color: Colors.orange,
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Welcome to Your Journey!',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Let\'s set up your profile to personalize your experience',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              
              // Username field
              TextField(
                controller: usernameController,
                decoration: const InputDecoration(
                  labelText: 'Your Name',
                  hintText: 'Enter your name',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
                textCapitalization: TextCapitalization.words,
              ),
              const SizedBox(height: 20),

              // Phone number field
              TextField(
                controller: phoneNumberController,
                decoration: const InputDecoration(
                  labelText: 'Accountability Partner\'s Phone',
                  hintText: 'Enter phone number (with country code)',
                  helperText: 'WhatsApp messages will be sent to this number',
                  prefixIcon: Icon(Icons.phone),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 20),
              
              // User profile image
              _buildImagePicker(
                title: 'Profile Picture',
                subtitle: 'This will be shown on your dashboard',
                image: userImage.value,
                onTap: () async {
                  final image = await pickImage();
                  if (image != null) {
                    userImage.value = image;
                  }
                },
                color: Colors.blue,
                icon: Icons.account_circle,
              ),
              const SizedBox(height: 20),
              
              // Success motivational image
              _buildImagePicker(
                title: 'Success Motivation Photo',
                subtitle: 'Shown when you stay clean (optional but recommended)',
                image: successImage.value,
                onTap: () async {
                  final image = await pickImage();
                  if (image != null) {
                    successImage.value = image;
                  }
                },
                color: Colors.green,
                icon: Icons.celebration,
              ),
              const SizedBox(height: 20),
              
              // Failure motivation image
              _buildImagePicker(
                title: 'Motivation Photo',
                subtitle: 'Shown when you fail - helps you stay motivated',
                image: failureImage.value,
                onTap: () async {
                  final image = await pickImage();
                  if (image != null) {
                    failureImage.value = image;
                  }
                },
                color: Colors.red,
                icon: Icons.psychology,
              ),
              const SizedBox(height: 30),
              
              // Register button
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton.icon(
                  onPressed: isLoading.value ? null : handleRegistration,
                  icon: isLoading.value 
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.rocket_launch),
                  label: Text(
                    isLoading.value ? 'Setting up...' : 'Start My Journey!',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImagePicker({
    required String title,
    required String subtitle,
    required File? image,
    required VoidCallback onTap,
    required Color color,
    required IconData icon,
  }) {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 12),
            Center(
              child: GestureDetector(
                onTap: onTap,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: color, width: 2),
                  ),
                  child: image != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.file(
                            image,
                            fit: BoxFit.cover,
                          ),
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(icon, size: 40, color: color),
                            const SizedBox(height: 8),
                            Text(
                              'Tap to add photo',
                              style: TextStyle(
                                color: color,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
