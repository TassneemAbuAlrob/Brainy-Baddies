import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:log/presentation/providers/auth_provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../../core/constants/scheme.dart';
import '../../data/entities/video_data.dart';
import '../../data/models/age.dart';
import '../../data/models/category.dart';
import '../../data/services/age_service.dart';
import '../../data/services/category_service.dart';
import '../../data/services/video_service.dart';

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
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        title: Text('Create Video'),
        backgroundColor: Theme.of(context).primaryColor,
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
                    fillColor: Colors.white,
                    hintText: 'Enter the video title',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                ),
               
                SizedBox(height: 20),
                TextFormField(
                  controller: _descriptionController,
                  maxLines: 6,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    
                    filled: true,
                    fillColor: Colors.white,
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
                    ElevatedButton(
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
                      child: Text('Select video'),
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
                                age: null,
                                category: null,
                                poster: _thumbnailPath ?? ''
                            );
                            await VideoService.createVideo(videoData, context.read<AuthProvider>().user.id);

                            Navigator.pop(context);
                          }catch(error){
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(error.toString()))
                            );
                          }
                        }
                      },
                      // style: customButtonStyle,
                      child: Text('Upload Video'),
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
