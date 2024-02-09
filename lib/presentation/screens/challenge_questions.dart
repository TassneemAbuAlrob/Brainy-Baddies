import 'package:flutter/material.dart';
import 'package:log/data/models/challenge.dart';
import 'package:log/presentation/screens/challenge_started_screen.dart';

import '../../data/models/question.dart';

class ChallengeQuestions extends StatelessWidget {
  final Challenge challenge;
  const ChallengeQuestions({super.key, required this.challenge});

  Widget QuestionChoice(String name){
    return Container(
      margin: EdgeInsets.only(bottom: 8.0),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0)
      ),
      child: Text(name,style: TextStyle(
        fontSize: 20
      ),),
    );
  }

  @override
  Widget build(BuildContext context) {
        return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.separated(
                itemBuilder: (context,index){
                  Question question = challenge.questions[index];
                  
                  return Container(
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Colors.black38,
                      borderRadius: BorderRadius.circular(8.0)
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Q: ${question.title}',style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white
                                ),),
                
                                SizedBox(height: 8.0,),
                        Text('Choices',style: TextStyle(
                          color: Colors.white
                        ),),
                        SizedBox(height: 8.0,),
                        ...question.answers.map((e){
                          return QuestionChoice(e.title);
                        }),
            
                      ],
                    ),
                  );
                }, 
                separatorBuilder: (context,index){
                  return SizedBox(height: 8.0,);
                }, 
                itemCount: challenge.questions.length
              ),
            ),

            GestureDetector(
              onTap: (){
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => ChallengeStartedScreen(questions: challenge.questions))
                );
              },
              child: Container(
                height: 50,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(8.0)
                ),
                child: Text('START',style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold
                ),),
              ),
            )
          ],
        ),
      ),
    );
  }
}