import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../../data/entities/story_data.dart';
import '../../data/models/age.dart';
import '../../data/models/category.dart';
import '../../data/services/age_service.dart';
import '../../data/services/category_service.dart';
import '../../data/services/story_service.dart';

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

  void _submitForm() async{
    try{
          if (_formKey.currentState!.validate()) {
      String title = _titleController.text;
      String content = _contentController.text;
      File? image = _selectedImage;

      StoryData story = StoryData(
        pdf: file!.path!,
          title: title,
          image: image!.path,
      );


      await StoryService.createStory(story);
      Navigator.pop(context);
    }
    }catch(error){
              ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error.toString()))
        ); 
    }
  }



  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor, // Deep blue app bar
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
                    width: media.width * 0.7, // Adjust the width and height as needed
                    height: 140,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0)
                    ),
                    child: Center(
                      child: _selectedImage != null
                          ? Image.file(
                        _selectedImage!,
                      
                        fit: BoxFit.cover, // Display the image cover the container
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
                    fillColor: Colors.white,
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                ),
                SizedBox(height:20),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async{
                          FilePicker filePicker = FilePicker.platform;
                          FilePickerResult? result = await filePicker.pickFiles(type: FileType.custom, allowedExtensions: ['.pdf', 'pdf']);
                          if(result != null){
                            setState(() {
                              file = result.files.first;
                            });
                          }
                        }, 
                        child: Text('Upload Story'),
                      ),
                    ),
                    SizedBox(width: 12.0,),
                    Expanded(
                      child: ElevatedButton(
                    onPressed: _submitForm,
                    child: Text('Create Story'),
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
