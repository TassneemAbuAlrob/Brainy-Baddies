import 'package:alaa_admin/helpers/scheme.dart';
import 'package:alaa_admin/models/question.dart';
import 'package:flutter/material.dart';

class QuestionsList extends StatelessWidget {
  final List<Question> questions;
  const QuestionsList({super.key, required this.questions});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: screenBackgroundColor,
      appBar: AppBar(
        backgroundColor: screenBackgroundColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView.separated(
          itemBuilder: (context,index){
            Question question = questions[index];
      
            return Container(
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: lightGreen,
                borderRadius: BorderRadius.circular(8.0)
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Q: ${question.title}',style: TextStyle(
                            fontSize: 18
                          ),),
    
                          SizedBox(height: 8.0,),
                  Text('Choices'),
                  SizedBox(height: 8.0,),
                  ...question.answers.map((e){
                    return Text(e.title);
                  }),
                  SizedBox(height: 8.0,),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text('correct answer ${question.answers[question.correctAnswerIndex].title}'),
                  )
                ],
              ),
            );
          }, 
          separatorBuilder: (context,index){
            return SizedBox(height: 8.0,);
          }, 
          itemCount: questions.length
        ),
      ),
    );
  }
}