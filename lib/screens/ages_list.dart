import 'package:alaa_admin/providers/age_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../helpers/scheme.dart';
import 'create_age.dart';

class AgesList extends StatefulWidget {
  const AgesList({super.key});

  @override
  State<AgesList> createState() => _AgesListState();
}

class _AgesListState extends State<AgesList> {

  @override
  void initState() {
    super.initState();
    initializeAges();
  }

  void initializeAges() async{
    await Provider.of<AgeProvider>(context, listen: false).fetchAges();
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
            MaterialPageRoute(builder: (context) => CreateAge())
          );
        },
        shape: CircleBorder(),
        elevation: 0,
        backgroundColor: heavyGreen,
        child: Icon(Icons.add, size: 30, color: Colors.white,)  ,
      ),
      body: Consumer<AgeProvider>(
        builder: (BuildContext context, AgeProvider value, Widget? child) { 
      return Container(
            margin: EdgeInsets.only(top: 8.0),
            padding: const EdgeInsets.all(12.0),
            child: ListView.separated(
              itemBuilder: (context,index){
                return Container(
                  decoration: BoxDecoration(
                    color: lightGreen,
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(
                      color: Colors.black,
                      width: 2
                    )
                  ),
                  padding: EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Name: ${value.ages[index].name}', style: TextStyle(
                        fontSize: 18
                      ),),
                      SizedBox(height: 12,),

                      Text('From: ${value.ages[index].from}', style: TextStyle(
                        fontSize: 18
                      ),),

                      SizedBox(height: 12,),

                      Text('To: ${value.ages[index].to}', style: TextStyle(
                        fontSize: 18
                      ),),
                    ],
                  ),
                );
              }, 
              separatorBuilder: (context, index){
                return SizedBox(height: 12,);
              }, 
              itemCount: value.ages.length
            ),
          );
        },
      ),
    );
  }
}