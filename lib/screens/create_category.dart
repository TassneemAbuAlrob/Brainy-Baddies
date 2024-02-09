import 'package:alaa_admin/helpers/scheme.dart';
import 'package:alaa_admin/models/category.dart';
import 'package:alaa_admin/providers/category_provider.dart';
import 'package:alaa_admin/screens/chat_screen.dart';
import 'package:alaa_admin/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/custom_text_field.dart';

class CreateCategory extends StatelessWidget {
  CreateCategory({super.key});
  TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: screenBackgroundColor,
      appBar: AppBar(
        backgroundColor: screenBackgroundColor,
      ),
      body: Padding(
        padding: EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            NormalTemplateTextField(
              hintText: 'Name',
              controller: nameController,
            ),
            SizedBox(height: 12.0,),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () async{
                  try{
                    if(nameController.text.isEmpty){
                      return;
                    }

                    Category category = Category(name: nameController.text);
                    await Provider.of<CategoryProvider>(context, listen: false).createCategory(category);
                    Navigator.pop(context);
                  }catch(e){

                  }
                },
                style: customButtonStyle,
                child: Text('CREATE', style: customTextStyle,),  
              ),
            )
          ],
        ),
      ),
    );
  }
}