import 'package:alaa_admin/data%20classes/story_data.dart';
import 'package:alaa_admin/helpers/scheme.dart';
import 'package:alaa_admin/models/age.dart';
import 'package:alaa_admin/models/category.dart';
import 'package:alaa_admin/models/story.dart';
import 'package:alaa_admin/providers/home_provider.dart';
import 'package:alaa_admin/services/age_service.dart';
import 'package:alaa_admin/services/category_service.dart';
import 'package:alaa_admin/services/story_service.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:provider/provider.dart';

class CreateStoryScreen extends StatefulWidget {
  @override
  _CreateStoryScreenState createState() => _CreateStoryScreenState();
}

class _CreateStoryScreenState extends State<CreateStoryScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  File? _selectedImage;

  PlatformFile? file;

  void _pickImage() async {
    final imagePicker = ImagePicker();
    final image = await imagePicker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  void _submitForm() async {
    try {
      if (_formKey.currentState!.validate()) {
        String title = _titleController.text;
        String content = _contentController.text;
        File? image = _selectedImage;

        String category = categoryController.text;
        String age = ageController.text;

        print(category);
        print(age);

        StoryData story = StoryData(
            pdf: file!.path!,
            title: title,
            image: image!.path,
            category: category,
            age: age);

        await StoryService.createStory(story);
        await context.read<HomeProvider>().initializeCounts();
        Navigator.pop(context);
      }
    } catch (error) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error.toString())));
    }
  }

  List<Category> categories = [];
  List<Age> ages = [];

  void initializeCategories() async {
    categories = await CategoryService.getAllCategories();
    setState(() {});
  }

  void initializeAges() async {
    ages = await AgeService.getAllAges();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    initializeCategories();
    initializeAges();
  }

  TextEditingController categoryController = TextEditingController();
  TextEditingController ageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: screenBackgroundColor,
      appBar: AppBar(
        backgroundColor: screenBackgroundColor, // Deep blue app bar
        title: Text('Create Story'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Image container
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    width: media.width *
                        0.7, // Adjust the width and height as needed
                    height: 140,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.0)),
                    child: Center(
                      child: _selectedImage != null
                          ? Image.file(
                              _selectedImage!,

                              fit: BoxFit
                                  .cover, // Display the image cover the container
                            )
                          : Icon(
                              Icons.add_a_photo,
                              size: 100,
                              color: Colors.grey, // Icon color
                            ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: 'Title',
                    filled: true,
                    fillColor: lightGreen,
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                DropdownButtonFormField(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Select Category',
                        filled: true,
                        fillColor: lightGreen,
                        focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: AppColors.primaryColor))),
                    items: categories.map((e) {
                      return DropdownMenuItem(
                        child: Text(e.name),
                        value: e.id,
                      );
                    }).toList(),
                    onChanged: (item) {
                      categoryController.text = item!;
                    }),
                SizedBox(height: 20),
                DropdownButtonFormField(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Select Age',
                        filled: true,
                        fillColor: lightGreen,
                        focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: AppColors.primaryColor))),
                    items: ages.map((e) {
                      return DropdownMenuItem(
                        child: Text('${e.name}  ${e.from} - ${e.to}'),
                        value: e.id,
                      );
                    }).toList(),
                    onChanged: (item) {
                      ageController.text = item!;
                    }),
                SizedBox(height: 20),
                Text('${file?.name.toString()}'),
                SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          FilePicker filePicker = FilePicker.platform;
                          FilePickerResult? result = await filePicker.pickFiles(
                              type: FileType.custom,
                              allowedExtensions: ['.pdf', 'pdf']);
                          if (result != null) {
                            setState(() {
                              file = result.files.first;
                            });
                          }
                        },
                        label: Text('Upload Story', style: customTextStyle),
                        icon: Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                        style: customButtonStyle,
                      ),
                    ),
                    SizedBox(
                      width: 12.0,
                    ),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _submitForm,
                        style: customButtonStyle,
                        child: Text('Create Story', style: customTextStyle),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
