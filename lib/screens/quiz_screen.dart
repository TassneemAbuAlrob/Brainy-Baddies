import 'package:alaa_admin/helpers/scheme.dart';
import 'package:alaa_admin/models/quiz.dart';
import 'package:alaa_admin/providers/quiz_provider.dart';
import 'package:alaa_admin/screens/create_quizz_screen.dart';
import 'package:alaa_admin/screens/questions_list.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {

  @override
  void initState() {
    super.initState();
    initializeQuizzes();
  }

  void initializeQuizzes() async{
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async{
      await Provider.of<QuizProvider>(context, listen: false).getAllQuizzes();
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: screenBackgroundColor,
      ),
      backgroundColor: screenBackgroundColor,
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => CreateQuizScreen())
          );
        },
        backgroundColor: buttonBackgroundColor,
        shape: CircleBorder(),
        child: Icon(Icons.add,size: 30,color: Colors.white,),
      ),
      body: Consumer<QuizProvider>(
        builder: (BuildContext context, QuizProvider quizProvider, Widget? child) { 
          if(quizProvider.loading){
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if(quizProvider.errorState){
            return Center(
              child: Text(quizProvider.errorMessage,style: TextStyle(
                fontSize: 18
              ),),
            );
          }

          if(quizProvider.quizzes.isEmpty){
            return Center(
              child: Text(
                'No Quizzes Available',
                style: TextStyle(
                  fontSize: 18
                ),
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(12.0),
            child: ListView.separated(
              itemCount: quizProvider.quizzes.length,
              separatorBuilder: (context,index){
                return SizedBox(height: 12.0,);
              },
              itemBuilder: (context,index){
                Quiz quiz = quizProvider.quizzes[index];

                return GestureDetector(
                  onTap: (){
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => QuestionsList(questions: quiz.questions))
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: lightGreen,
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(
                        color: Colors.black,
                        width: 2
                      )
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Quiz Name: ${quiz.name}',style: TextStyle(
                          fontSize: 18
                        ),),
                        SizedBox(height: 8.0),
                        Text('Questions number: ${quiz.questions.length}',style: TextStyle(
                          fontSize: 18
                        ),),
                        SizedBox(height:8.0),
                        Text('Category: ${quiz.category}',style: TextStyle(
                          fontSize: 18
                        ),),
                        if(quiz.image != null)
                        SizedBox(height: 8.0),
                        if(quiz.image != null)
                        CachedNetworkImage(imageUrl: quiz.image.toString())
                      ],
                    ),
                  ),
                );
              }
            ),
          );
        },
      ),
    );
  }
}