import 'package:errandor/presentation/widgets/label.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../../controllers/create_errand_controller.dart';

class CreateErrand extends StatelessWidget {
  const CreateErrand({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CreateErrandController());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Post An Errand',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Obx(() => Stack(
            children: [
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: controller.formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        label('Errand Name'),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: controller.errandNameController,
                          decoration:
                              _inputDecoration(hintText: 'Enter errand name'),
                          validator: (value) => value?.isEmpty ?? true
                              ? 'Please enter errand name'
                              : null,
                        ),
                        const SizedBox(height: 24),
                        label('Image'),
                        const SizedBox(height: 8),
                        Obx(() => GestureDetector(
                              onTap: () =>
                                  controller.pickImage(ImageSource.gallery),
                              child: Container(
                                height: 200,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Colors.grey[300]!),
                                ),
                                child: controller.imageBytes.value != null
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: Image.memory(
                                          controller.imageBytes.value!,
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                    : Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.add_photo_alternate,
                                              size: 40,
                                              color: Colors.grey[400]),
                                          const SizedBox(height: 8),
                                          Text(
                                            'Choose An Image',
                                            style: TextStyle(
                                              color: Colors.grey[600],
                                              fontSize: 16,
                                            ),
                                          ),
                                        ],
                                      ),
                              ),
                            )),
                        const SizedBox(height: 24),
                        label('Description'),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: controller.descriptionController,
                          maxLines: 4,
                          decoration: _inputDecoration(
                            hintText: 'Enter errand description',
                          ),
                          validator: (value) => value?.isEmpty ?? true
                              ? 'Please enter description'
                              : null,
                        ),
                        const SizedBox(height: 24),
                        label('Location'),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: controller.countyController,
                          decoration: _inputDecoration(
                            hintText: 'County',
                            prefixIcon: const Icon(Icons.location_on_outlined),
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: controller.subCountyController,
                          decoration: _inputDecoration(
                            hintText: 'Sub-county',
                            prefixIcon:
                                const Icon(Icons.location_city_outlined),
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: controller.placeController,
                          decoration: _inputDecoration(
                            hintText: 'Place',
                            prefixIcon: const Icon(Icons.place_outlined),
                          ),
                        ),
                        const SizedBox(height: 24),
                        label('Date and time'),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: controller.dateTimeController,
                          readOnly: true,
                          decoration: _inputDecoration(
                            hintText: 'Select date and time',
                            prefixIcon: const Icon(Icons.calendar_today),
                          ),
                          onTap: () async {
                            final DateTime? date = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime(2025),
                            );
                            if (date != null) {
                              final TimeOfDay? time = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                              );
                              if (time != null) {
                                controller.dateTimeController.text =
                                    DateFormat('yyyy-MM-dd HH:mm')
                                        .format(DateTime(
                                  date.year,
                                  date.month,
                                  date.day,
                                  time.hour,
                                  time.minute,
                                ));
                              }
                            }
                          },
                        ),
                        const SizedBox(height: 24),
                        label('Completion date and time'),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: controller.completionTimeController,
                          readOnly: true,
                          decoration: _inputDecoration(
                            hintText: 'Select date and time',
                            prefixIcon: const Icon(Icons.calendar_today),
                          ),
                          onTap: () async {
                            final DateTime? date = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime(2025),
                            );
                            if (date != null) {
                              final TimeOfDay? time = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                              );
                              if (time != null) {
                                controller.completionTimeController.text =
                                    DateFormat('yyyy-MM-dd HH:mm')
                                        .format(DateTime(
                                  date.year,
                                  date.month,
                                  date.day,
                                  time.hour,
                                  time.minute,
                                ));
                              }
                            }
                          },
                        ),
                        const SizedBox(height: 24),
                        label('Payment'),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: controller.paymentController,
                          keyboardType: TextInputType.number,
                          decoration: _inputDecoration(
                            hintText: 'Enter amount in KES',
                            prefixIcon: const Icon(Icons.payments_outlined),
                          ),
                        ),
                        const SizedBox(height: 24),
                        label('Instructions'),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: controller.instructionsController,
                          maxLines: 4,
                          decoration: _inputDecoration(
                            hintText: 'Enter instructions for the errand',
                          ),
                        ),
                        const SizedBox(height: 32),
                        label('Urgency'),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<String>(
                          value: controller.urgencyController.text.isEmpty
                              ? 'Low'
                              : controller.urgencyController.text,
                          decoration:
                              _inputDecoration(hintText: 'Select urgency'),
                          items: ['Low', 'Medium', 'High'].map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (value) {
                            controller.urgencyController.text = value ?? 'Low';
                          },
                        ),
                        const SizedBox(height: 32),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: controller.isLoading.value
                                ? null
                                : controller.submitForm,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF4CAF50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: controller.isLoading.value
                                ? const CircularProgressIndicator(
                                    color: Colors.white)
                                : const Text(
                                    'Submit',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ),
              if (controller.isLoading.value)
                Container(
                  color: Colors.black.withOpacity(0.3),
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
            ],
          )),
    );
  }

 

  InputDecoration _inputDecoration({
    required String hintText,
    Widget? prefixIcon,
  }) {
    return InputDecoration(
      hintText: hintText,
      prefixIcon: prefixIcon,
      filled: true,
      fillColor: Colors.grey[100],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      contentPadding: const EdgeInsets.all(16),
    );
  }
}
