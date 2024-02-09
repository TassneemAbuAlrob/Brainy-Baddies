import 'package:alaa_admin/helpers/scheme.dart';
import 'package:alaa_admin/models/answer.dart';
import 'package:alaa_admin/models/question.dart';
import 'package:alaa_admin/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/create_quiz_provider.dart';

class QuestionBoxes extends StatelessWidget {
  QuestionBoxes({super.key});

  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: screenBackgroundColor,
      ),
      backgroundColor: screenBackgroundColor,
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          if(_key.currentState != null && _key.currentState!.validate()){
            List<QuestionBox> boxes = Provider.of<CreateQuizProvider>(context,listen: false).boxes;
            for(int i = 0; i < boxes.length; i++) {
              Question question = Question(
                title: boxes[i].title.text,
                answers: boxes[i].answers.map((e){
                  return Answer(title: e.text);
                }).toList(),
                correctAnswerIndex: int.parse(boxes[i].correctAnswerIndex.text)
              );
              Provider.of<CreateQuizProvider>(context,listen: false).insertQuestion(question);
              Navigator.pop(context);
            }
          }else{
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Fill Form First'))
            );
          }
        },
        shape: CircleBorder(),
        backgroundColor: heavyGreen,
        child: Icon(Icons.done, color: Colors.white,size: 30,),
      ),
      body: Consumer<CreateQuizProvider>(
                builder: (BuildContext context, CreateQuizProvider createQuizProvider, Widget? child) { 
                  return Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Form(
                      key: _key,
                      child: ListView.separated(
                        itemCount: createQuizProvider.boxes.length,
                        separatorBuilder: ((context, index) {
                          return SizedBox(height: 12.0,);
                        }),
                        itemBuilder: (context,index){
                          QuestionBox questionBox = createQuizProvider.boxes[index];
                        
                          return Container(
                            padding: EdgeInsets.all(12.0),
                            decoration: BoxDecoration(
                              color: lightGreen,
                              border: Border.all(
                                color: Colors.black,
                                width: 2
                              ),
                              borderRadius: BorderRadius.circular(8.0)
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                NormalTemplateTextField(
                                  hintText: 'Question Text',
                                  backgroundColor: Colors.white,
                                  validator: (val){
                                    if(val != null){
                                      if(val.isEmpty){
                                        return "Enter a question";
                                      }
                    
                                      return null;
                                    }
                    
                                    return null;
                                  },
                                  controller: questionBox.title,
                                  lines: 4,
                                ),
                                SizedBox(height: 8.0,),
                        
                                Row(
                                  children: [
                                    ...questionBox.answers.map((e){
                                      return Expanded(
                                        child: Container(
                                          margin: EdgeInsets.only(
                                            right: 4.0
                                          ),
                                          child: NormalTemplateTextField(
                                            hintText: 'answer',
                                            backgroundColor: Colors.white,
                                            validator: (val){
                                              if(val != null){
                                                if(val.isEmpty){
                                                  return "Fill";
                                                }
                                                                    
                                                return null;
                                              }
                                                                    
                                              return null;
                                            },
                                            controller: e,
                                          ),
                                        ),
                                      );
                                    })
                                  ],
                                ),
                        
                                SizedBox(height: 12,),
                                Text('Choose Correct Answer Index', style: TextStyle(
                                  fontSize: 16
                                ),),
                        
                                NormalTemplateTextField(
                                  hintText: 'Correct Answer Index',
                                  backgroundColor: Colors.white,
                                  validator: (val){
                                    if(val != null){
                                      if(val.isEmpty){
                                        return "Fill";
                                      }
                    
                                      return null;
                                    }
                    
                                    return null;
                                  },
                                  controller: questionBox.correctAnswerIndex,
                                )
                              ],
                            ),
                          );
                        }
                      ),
                    ),
                  );
                },
              ),
    );
  }
}