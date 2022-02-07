// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

//import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:matcher/matcher.dart';
import 'package:todo_app/shared/cubit/cubit.dart';

Widget buildTaskItem(Map model,BuildContext context) => Dismissible(
  key: Key(model['id'].toString()),
  child:   Padding(
  
        padding: const EdgeInsets.all(5.0),
  
        child: Container(
  
          decoration: BoxDecoration(
  
            color: Colors.blue[100],
  
            borderRadius: BorderRadius.circular(12),
  
          ),
  
          child: Row(
  
            ///mainAxisSize: MainAxisSize.min,
  
            children: [
  
              CircleAvatar(
  
                backgroundColor: Colors.blue,
  
                radius: 32,
  
                child: Text('${model['time']}',style:TextStyle(fontSize: 14,color: Colors.white)),
  
              ),
  
              SizedBox(
  
                width: 20,
  
              ),
  
              Expanded(
  
                child: Column(
  
                  //mainAxisSize: MainAxisSize.min,
  
                  children: [
  
                    Text('${model['title']}',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.blue),),
  
                    Text('${model['date']}',style: TextStyle(fontSize: 16,color: Colors.grey),),
  
                  ],
  
                ),
  
              ),
  
              SizedBox(
  
                width: 50,
  
              ), 
  
              Row(
  
                mainAxisAlignment: MainAxisAlignment.end,
  
                //mainAxisSize:double.infinity,
  
                crossAxisAlignment: CrossAxisAlignment.end,
  
                children: [
  
                  IconButton(onPressed: (){AppCubit.get(context).updateData(status:'done', id: model['id']);} ,icon:Icon(Icons.check_box),color: Colors.green,),
  
                  SizedBox(
  
                width: 20,
  
              ),
  
                  IconButton(onPressed: (){AppCubit.get(context).updateData(status:'archived', id: model['id']);} ,icon: Icon(Icons.archive),color: Colors.grey,),
  
                ],
  
              ), 
  
            ],
  
              
  
          ),
  
        ),
  
      ),
  onDismissed: (direction) {
    AppCubit.get(context).deleteData(id:model['id'] );
  },
);
    /* Widget tasksWithConditionalBuilder(List<Map<dynamic, dynamic>> tasks) =>ConditionalBuilder(
      condition: tasks.isNotEmpty,
      builder: (context) => ListView.separated(
        itemBuilder: (context,index) => buildTaskItem(tasks[index]),
       separatorBuilder: (context,index) => Container(
         width: double.infinity,
         height: 2,
         color: Colors.grey[300],
       ) ,
        itemCount: tasks.length,
        ),
        fallback: (context) => Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.menu),
            Text('There is no Tasks Yet')
          ],
        ),
    );
 */ 
 Widget tasksBuilder(List<Map<dynamic, dynamic>> tasks,contex){
   if(tasks.isNotEmpty){
     return ListView.separated(
        itemBuilder: (context,index) => buildTaskItem(tasks[index],contex),
       separatorBuilder: (context,index) => Container(
         width: double.infinity,
         height: 2,
         color: Colors.grey[300],
       ) ,
        itemCount: tasks.length,
        ); 
   }
   else{
     return Center(
       child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(icon: Icon(Icons.menu),onPressed: (){},iconSize: 50,color: Colors.grey[500],),
              Text('There is no Tasks Yet',style: TextStyle(fontSize: 20,color: Colors.grey[500],fontWeight: FontWeight.bold))
            ],
          ),
     );
   }
 }
  
  