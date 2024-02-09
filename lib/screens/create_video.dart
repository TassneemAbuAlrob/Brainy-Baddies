import 'dart:io';
import 'package:alaa_admin/data%20classes/video_data.dart';
import 'package:alaa_admin/helpers/scheme.dart';
import 'package:alaa_admin/services/video_service.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../models/age.dart';
import '../models/category.dart';
import '../services/age_service.dart';
import '../services/category_service.dart';

class CreateVideoScreen extends StatefulWidget {
  @override
  _CreateVideoScreenState createState() => _CreateVideoScreenState();
}

class _CreateVideoScreenState extends State<CreateVideoScreen> {
  File? _selectedVideo;
  String? _thumbnailPath;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

    List<Category> categories = [];
  List<Age> ages = [];

  void initializeCategories() async{
    categories = await CategoryService.getAllCategories();
    setState(() {
      
    });
  }

  void initializeAges() async{
    ages = await AgeService.getAllAges();
    setState(() {
      
    });
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
        title: Text('Create Video'),
        backgroundColor: screenBackgroundColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _selectedVideo != null
                    ? Container(
                  width: media.width * 0.8,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black12,width: 2),
                      borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Image.file(
                    File(_thumbnailPath!),
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                )
                    : Container(
                  height: 200,
                  width: media.width * 0.8, 
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black12,
                      width: 2
                    ),
                    
                    borderRadius: BorderRadius.circular(8.0)
                  ),
                  child: Icon(Icons.camera,size: 100,color: Colors.black12,),
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: 'Title',
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black,
                        width: 2
                      )
                    ),
                    filled: true,
                    fillColor: lightGreen,
                    hintText: 'Enter the video title',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20,),
                DropdownButtonFormField(
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black,
                        width: 2
                      )
                    ),
                    filled: true,
                    fillColor: lightGreen,
                    hintText: 'Select Category',
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.primaryColor)
                    )
                  ),
                  items: categories.map((e){
                    return DropdownMenuItem(
                      child: Text(e.name),
                      value: e.id,
                    );
                  }).toList(), 
                  onChanged: (item){
                    categoryController.text = item!;
                  }
                ),
                SizedBox(height:20),
                DropdownButtonFormField(
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black,
                        width: 2
                      )
                    ),
                    hintText: 'Select Age',
                    filled: true,
                    fillColor: lightGreen,
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.primaryColor)
                    )
                  ),
                  items: ages.map((e){
                    return DropdownMenuItem(
                      child: Text(
                        '${e.name}  ${e.from} - ${e.to}'
                      ),
                      value: e.id,
                    );
                  }).toList(), 
                  onChanged: (item){
                    ageController.text = item!;
                  }
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _descriptionController,
                  maxLines: 6,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    
                    filled: true,
                    fillColor: lightGreen,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black,
                        width: 2
                      )
                    ),
                    hintText: 'Enter video description (optional)',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () async {
                        FilePickerResult? result =
                        await FilePicker.platform.pickFiles(
                          type: FileType.video,
                        );
                        if (result != null) {
                          _selectedVideo = File(result.files.single.path!);
                          _thumbnailPath =
                          await VideoThumbnail.thumbnailFile(
                            video: _selectedVideo!.path,
                            thumbnailPath: (await getTemporaryDirectory()).path,
                            imageFormat: ImageFormat.JPEG,
                          );
                          setState(() {});
                        }
                      },
                      style: customButtonStyle,
                      label: Text('Select video', style: customTextStyle,),
                      icon: Icon(Icons.cloud_upload,size: 30,color: Colors.white,),
                    ),
                    SizedBox(width: 8.0,),
                    ElevatedButton(
                      onPressed: () async{
                        if (_formKey.currentState!.validate() && _selectedVideo != null) {
                          try{
                            VideoData videoData = VideoData(
                                description: _descriptionController.text,
                                title: _titleController.text,
                                video: _selectedVideo!.path,
                                age: ageController.text,
                                category: categoryController.text
                            );
                            await VideoService.createVideo(videoData, _thumbnailPath);

                            Navigator.pop(context);
                          }catch(error){
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(error.toString()))
                            );
                          }
                        }
                      },
                      style: customButtonStyle,
                      child: Text('Upload Video',style: customTextStyle),
                    ),
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
