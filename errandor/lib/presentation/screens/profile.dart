import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/profile_controller.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => _showEditDialog(context, controller),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final user = controller.user.value;
        if (user == null) {
          return const Center(child: Text('No user data found'));
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Profile Image with Edit Button
              Stack(
                children: [
                  GestureDetector(
                    onTap: controller.updateProfileImage,
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.grey[200],
                      backgroundImage: user.profileImage != null
                          ? NetworkImage('http://localhost:3000${user.profileImage}')
                          : null,
                      child: user.profileImage == null
                          ? Text(
                              user.firstName[0],
                              style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                              ),
                            )
                          : null,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // User Info
              Text(
                user.fullName,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                user.email,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),

              // Stats Cards
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildStatItem('Created', controller.totalCreated.toString()),
                  _buildStatItem('Claimed', controller.totalClaimed.toString()),
                  _buildStatItem('Completed', controller.totalCompleted.toString()),
                ],
              ),

              // Earnings/Spent Cards
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: _buildMoneyCard(
                      'Total Earnings',
                      'KSH ${controller.totalEarnings.value}',
                      Colors.green,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildMoneyCard(
                      'Total Spent',
                      'KSH ${controller.totalSpent.value}',
                      Colors.orange,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildMoneyCard(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context, ProfileController controller) {
    final nameController = TextEditingController(
      text: controller.user.value?.firstName ?? '',
    );
    final lastNameController = TextEditingController(
      text: controller.user.value?.lastName ?? '',
    );
    final emailController = TextEditingController(
      text: controller.user.value?.email ?? '',
    );

    Get.dialog(
      AlertDialog(
        title: const Text('Edit Profile'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'First Name'),
            ),
            TextField(
              controller: lastNameController,
              decoration: const InputDecoration(labelText: 'Last Name'),
            ),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              controller.updateProfile(
                firstName: nameController.text,
                lastName: lastNameController.text,
                email: emailController.text,
              );
              Get.back();
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}