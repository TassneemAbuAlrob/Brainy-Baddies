import 'dart:math';

import 'package:alaa_admin/helpers/scheme.dart';
import 'package:alaa_admin/models/answer.dart';
import 'package:alaa_admin/models/question.dart';
import 'package:alaa_admin/providers/create_quiz_provider.dart';
import 'package:alaa_admin/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/custom_text_field.dart';

class CreateQuestion extends StatelessWidget {
  CreateQuestion({super.key});

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController correctController = TextEditingController();

  final TextEditingController answer1Controller = TextEditingController();
  final TextEditingController answer2Controller = TextEditingController();
  final TextEditingController answer3Controller = TextEditingController();
  final TextEditingController answer4Controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 24,),
              NormalTemplateTextField(
                hintText: 'Title',
                controller: titleController,
              ),
              SizedBox(height: 12.0,),
              NormalTemplateTextField(
                hintText: 'Description',
                controller: descriptionController,
              ),
              SizedBox(height: 12.0,),
              Text('Answers',style: TextStyle(
                fontSize: 18
              ),),
              SizedBox(height: 12.0,),
              Row(
                children: [
                  Expanded(
                    child: NormalTemplateTextField(hintText: 'Answer 1',controller: answer1Controller,),
                  ),
                  SizedBox(
                    width: 12.0,
                  ),
                  Expanded(
                    child: NormalTemplateTextField(hintText: 'Answer 2',controller: answer2Controller,),
                  ),
                ],
              ),
        
              SizedBox(height: 12.0,),
        
              Row(
                children: [
                  Expanded(
                    child: NormalTemplateTextField(hintText: 'Answer 3',controller: answer3Controller,),
                  ),
                  SizedBox(
                    width: 12.0,
                  ),
                  Expanded(
                    child: NormalTemplateTextField(hintText: 'Answer 4', controller: answer4Controller,),
                  ),
                ],
              ),
              SizedBox(height: 12,),
              Text('Choose Correct Answer Number',style: TextStyle(
                fontSize: 18
              ),),
              SizedBox(height: 12,),
              NormalTemplateTextField(hintText: 'Correct Answer Number',controller: correctController,),
        
              SizedBox(height: 24.0,),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () async{
                    List<Answer> answers = [
                      Answer(title: answer1Controller.text),
                      Answer(title: answer2Controller.text),
                      Answer(title: answer3Controller.text),
                      Answer(title: answer4Controller.text),
                    ];
        
                    Question question = Question(
                      title: titleController.text,
                      answers: answers,
                      correctAnswerIndex: int.parse(correctController.text) - 1
                    );
        
                    Provider.of<CreateQuizProvider>(context, listen: false).insertQuestion(question);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.secondaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0)
                    )
                  ),
                  child: Text('Create',style: TextStyle(
                    color: Colors.white
                  ),),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}