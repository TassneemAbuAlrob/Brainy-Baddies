import 'package:alaa_admin/helpers/scheme.dart';
import 'package:alaa_admin/models/age.dart';
import 'package:alaa_admin/models/category.dart';
import 'package:alaa_admin/providers/age_provider.dart';
import 'package:alaa_admin/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/custom_text_field.dart';

class CreateAge extends StatelessWidget {
  CreateAge({super.key});
  TextEditingController nameController = TextEditingController();
  TextEditingController fromController = TextEditingController();
  TextEditingController toController = TextEditingController();

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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: NormalTemplateTextField(
                    hintText: 'From',
                    controller: fromController,
                  ),
                ),
                SizedBox(width: 12.0,),
                Expanded(
                  child: NormalTemplateTextField(
                    hintText: 'To',
                    controller: toController,
                  ),
                )
              ],
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

                    Age age = Age(
                      name: nameController.text, 
                      from: int.parse(fromController.text), 
                      to: int.parse(toController.text)
                    );
                    await Provider.of<AgeProvider>(context, listen: false).createAge(age);
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