import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:log/data/models/question.dart';

class ChallengeStartedScreen extends StatefulWidget {
  final List<Question> questions;
  const ChallengeStartedScreen({super.key, required this.questions});

  @override
  State<ChallengeStartedScreen> createState() => _ChallengeStartedScreenState();
}

class _ChallengeStartedScreenState extends State<ChallengeStartedScreen> {
  int score = 0;
  int currentIndex = 0;

  updateCurrentIndex(int _currentIndex){
    setState(() {
      currentIndex = _currentIndex;
    });
  }

  updateScore(){
    setState(() {
      score += 1;
    });
  }

    int? selectedBox;
    bool isFinished = false;


    Widget QuestionChoice(String name, int index){
    return GestureDetector(
      onTap: (){
        setState(() {
          selectedBox = index;
        });
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 8.0),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selectedBox != null && selectedBox == index ? Colors.green : Colors.white,
          borderRadius: BorderRadius.circular(8.0)
        ),
        child: Text(name,style: TextStyle(
          fontSize: 20,
          color: selectedBox != null && selectedBox == index ? Colors.white : Colors.black
        ),),
      ),
    );
  }

    Widget QuestionTile(Question question) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: 200
      ),
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
                          return QuestionChoice(e.title,question.answers.indexOf(e));
                        }),
            
                      ],
                    ),
                  );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: isFinished ? Container(
          padding: EdgeInsets.all(12.0),
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Your Score is', style: TextStyle(fontSize: 32,color: Colors.white, fontWeight: FontWeight.bold),),
              SizedBox(height: 12.0,),
              Text(score.toString(), style: TextStyle(fontSize: 32,color: Colors.white, fontWeight: FontWeight.bold)),
              SizedBox(height: 12,),
              GestureDetector(
                onTap: (){
                  Navigator.pop(context);
                },
                child: Container(
              height: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(8.0)
              ),
              child: Text('GO BACK',style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold
              ),),
              ),
              )
            ],
          ),
        ) : Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              QuestionTile(
                widget.questions[currentIndex],
              ),
              SizedBox(height: 12.0,),
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
              onTap: (){
                print(widget.questions[currentIndex].correctAnswerIndex.toString());
                if(widget.questions.length - 1 == currentIndex){
                  print('done');
                  setState(() {
                    isFinished = true;
                  });
                }else{
                  if(selectedBox != null){
                  if(selectedBox == widget.questions[currentIndex].correctAnswerIndex - 1){
                    updateScore();
                  }
                  updateCurrentIndex(currentIndex + 1);

                  print(score);
                }else{
                  AwesomeDialog(
                    context: context,
                    dialogType: DialogType.info,
                    title: 'No Choice',
                    desc: 'Select answer first'
                  )..show();
                }
                }
              },
              child: Container(
              height: 40,
              width: 90,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(8.0)
              ),
              child: Text(currentIndex == widget.questions.length - 1 ? 'FINISH' : 'NEXT',style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold
              ),),
              ),
            ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

