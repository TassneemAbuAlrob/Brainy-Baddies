import 'package:alaa_admin/helpers/scheme.dart';
import 'package:alaa_admin/providers/create_quiz_provider.dart';
import 'package:alaa_admin/screens/chat_screen.dart';
import 'package:alaa_admin/screens/create_question.dart';
import 'package:alaa_admin/screens/question_boxes.dart';
import 'package:alaa_admin/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../widgets/custom_text_field.dart';

class CreateQuizScreen extends StatelessWidget {
  TextEditingController totalController = TextEditingController();

  CreateQuizScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: screenBackgroundColor,
      appBar: AppBar(
        backgroundColor: screenBackgroundColor,
      ),
      body: Container(
        padding: EdgeInsets.all(12.0),
        child: ListView(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Create Quizz Form',style: TextStyle(
                  fontSize: 18
                ),),

                ElevatedButton(
                  onPressed: () async{
                    try{
                      final provider = Provider.of<CreateQuizProvider>(context, listen: false);
                      await provider.createQuiz();
                      if(context.mounted) {
                        Navigator.pop(context);
                      }
                    }catch(e){
                      if(context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(e.toString()))
                        );
                      }
                    }

                  }, 
                  style: customButtonStyle,
                  child: Text('create',style: TextStyle(
                    color: Colors.white
                  ),)
                )
              ],
            ),
            SizedBox(height: 12,),
            NormalTemplateTextField(
              hintText: 'Name',
              onChanged: (val){
                Provider.of<CreateQuizProvider>(context, listen: false).updateName(val);
              },
            ),
            SizedBox(height: 12,),
            NormalTemplateTextField(
              hintText: 'Category',
              onChanged: (val){
                Provider.of<CreateQuizProvider>(context, listen: false).updateCategory(val);
              },
            ),

            SizedBox(height: 12,),
            Text('Quiz Questions',style: TextStyle(
              fontSize: 18
            ),),

            SizedBox(height: 12,),
            Row(
              children: [
                Expanded(
                  child: NormalTemplateTextField(
                    hintText: 'number of questions',
                    controller: totalController,
                  ),
                ),

                SizedBox(width: 12.0,),
                ElevatedButton(
                  onPressed: (){
                    Provider.of<CreateQuizProvider>(context,listen: false).generateQuestionsBoxes(
                      int.parse(totalController.text)
                    );

                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => QuestionBoxes())
                    );
                  }, 
                  style: customButtonStyle,
                  child: Text('Generate', style: TextStyle(
                    color: Colors.white
                  ),)
                )
              ],
            ),
            SizedBox(height: 12.0,),

            Consumer<CreateQuizProvider>(
              builder: (BuildContext context, CreateQuizProvider createQuizProvider, Widget? child) { 
                return ListView.separated(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: createQuizProvider.questions.length,
                  separatorBuilder: (context,index){
                    return SizedBox(height: 12,);
                  },
                  itemBuilder: (context,index){
                    return ListTile(
                      tileColor: Colors.black12,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0)
                      ),
                      title: Text(createQuizProvider.questions[index].title),
                    );
                  }
                );
              },
            )
          ],
        ),
      ),
    );
  }
}