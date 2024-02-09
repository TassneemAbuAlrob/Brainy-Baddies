import 'package:flutter/material.dart';
import 'package:log/data/models/challenge.dart';
import 'package:log/presentation/providers/challenge_provider.dart';
import 'package:log/presentation/screens/challenge_questions.dart';
import 'package:provider/provider.dart';

class ChallengesList extends StatefulWidget {
  const ChallengesList({super.key});

  @override
  State<ChallengesList> createState() => _ChallengesListState();
}

class _ChallengesListState extends State<ChallengesList> {
  @override
  void initState() {
    super.initState();
    initializeChallenges();
  }

  void initializeChallenges() async {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await Provider.of<ChallengePorvider>(context, listen: false)
          .getAllChallenges();
    });
  }

  Widget itemDashboard(
      {required IconData iconData,
      required Color background,
      required Challenge challenge}) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ChallengeQuestions(
                  challenge: challenge,
                )));
      },
      child: Container(
        padding: EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, 5),
              color: Theme.of(context).primaryColor.withOpacity(.2),
              spreadRadius: 2,
              blurRadius: 5,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: background,
                  shape: BoxShape.circle,
                ),
                child: Icon(iconData, color: Colors.white)),
            const SizedBox(height: 8),
            Text(challenge.name.toUpperCase(),
                style: Theme.of(context).textTheme.titleMedium),
            SizedBox(
              height: 8.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Questions:  ${challenge.questions.length}'),
                Text('Category:  ${challenge.category}'),
              ],
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Challenges'),
      ),
      backgroundColor: Theme.of(context).primaryColor,
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Expanded(
              child: Consumer<ChallengePorvider>(
                builder: (BuildContext context,
                    ChallengePorvider challengePorvider, Widget? child) {
                  if (challengePorvider.errorState &&
                      challengePorvider.errorType ==
                          ChallengeProviderErrorType.errorGettingChallenges) {
                    return Center(
                      child: Text(challengePorvider.errorMessage),
                    );
                  }

                  if (challengePorvider.challenges.isEmpty) {
                    return Center(
                      child: Text('No Challenges Yet'),
                    );
                  }
                  List<Challenge> challenges = challengePorvider.challenges;
                  return ListView.separated(
                      itemBuilder: (context, index) {
                        Challenge challenge = challenges[index];
                        return itemDashboard(
                            iconData: Icons.question_answer,
                            background: Colors.teal,
                            challenge: challenge);
                      },
                      separatorBuilder: (context, index) {
                        return SizedBox(
                          height: 12,
                        );
                      },
                      itemCount: challenges.length);
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
