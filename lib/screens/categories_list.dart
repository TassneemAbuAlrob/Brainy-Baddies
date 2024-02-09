import 'package:alaa_admin/helpers/scheme.dart';
import 'package:alaa_admin/providers/category_provider.dart';
import 'package:alaa_admin/screens/create_category.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategoriesList extends StatefulWidget {
  const CategoriesList({super.key});

  @override
  State<CategoriesList> createState() => _CategoriesListState();
}

class _CategoriesListState extends State<CategoriesList> {

  @override
  void initState() {
    super.initState();
    initializeCategories();
  }

  void initializeCategories() async{
    await Provider.of<CategoryProvider>(context, listen: false).fetchCategories();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: screenBackgroundColor,
        title: Text('Categories'),
      ),
      backgroundColor: screenBackgroundColor,
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => CreateCategory())
          );
        },
        shape: CircleBorder(),
        elevation: 0,
        backgroundColor: heavyGreen,
        child: Icon(Icons.add, size: 30, color: Colors.white,)  ,
      ),
      body: Consumer<CategoryProvider>(
      builder: (BuildContext context, CategoryProvider value, Widget? child) { 
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
                alignment: Alignment.center,
                padding: EdgeInsets.all(12.0),
                child: Text(value.categories[index].name, style: TextStyle(
                  fontSize: 18
                ),),
              );
            }, 
            separatorBuilder: (context, index){
              return SizedBox(height: 12,);
            }, 
            itemCount: value.categories.length
          ),
        );
      },
    ),
    );
  }
}