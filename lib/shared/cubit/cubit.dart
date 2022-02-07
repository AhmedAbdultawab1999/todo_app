import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/modules/archived_task_screen.dart';
import 'package:todo_app/modules/done_tasks_screen.dart';
import 'package:todo_app/modules/new_tasks_screen.dart';
import 'package:todo_app/shared/components/constants.dart';
import 'package:todo_app/shared/cubit/states.dart';

class AppCubit extends Cubit<AppStates>{
  AppCubit(): super(AppInitialState());
  static AppCubit get(BuildContext context) => BlocProvider.of(context);
  int currentIndex = 0;
  List<Widget> screens = [
    NewTasksScreen(),
    DoneTasksScreen(),
    ArchivedTasksScreen(),
  ];
  List<String> titles = [
    'New Task',
    'Done Task',
    'Arcived Task',
  ];
  void ChangeIndex(int index){
    currentIndex=index;
    emit(AppChangeBottomNaveBarState());
  }
  //_______________floating Action Button
  bool isBottomSheet = false;
  IconData fabIcon=Icons.edit;
  void changeFloatingActionButton(bool isBottomSheetShown,IconData icon){
    isBottomSheet=isBottomSheetShown;
    fabIcon=icon;
   emit(AppChangeFloatingActionBottomState()); 
  }
  //___________________Database___________

  late Database database;
  List<Map> newTasks=[];
   List<Map> doneTasks=[];
    List<Map> archivedTasks=[];

  Future<void> createDatabase() async {
    openDatabase(
      'todo.db',
      version: 1,
      onCreate: (database, version) {
        print('database created');
        database
            .execute(
                'CREATE TABLE tasks (id INTEGER PRIMARY KEY ,title TEXT,date TEXT,time TEXT,status TEXT)')
            .then((value) {
          print('tables Created succefully');
        }).catchError((error) {
          print('error ${error.toString()}');
        });
      },
      onOpen: (database) {
         print('$database database opened');
         //getdatafromDB(database); 
      },
    ).then((value)
    {
      database=value;
      emit(AppCreateDatabaseState());
      getdatafromDB(database);
    });
  }
  void updateData({required String status,required int id}){
    database.rawUpdate(
    'UPDATE tasks SET status = ? WHERE id = ?',
    ['$status',id]).then((value){
      emit(AppUpdateDataState());
      getdatafromDB(database);

    });
  }
  void deleteData({required int id}){
    database.rawDelete(
    'DELETE FROM tasks WHERE id = ?',
    [id]).then((value){
      emit(AppDeleteDataState());
      getdatafromDB(database);

    });
  }
  Future insertToDatabase({
    required String title,
    required String date,
    required String time,
  }) async {
    database.transaction((txn) async {
      return await txn.rawInsert(
          'INSERT INTO tasks(title,date,time,status) VALUES("$title","$date","$time","new")');
    }).then((value) {
      print('$value inserted succefully');
      emit(AppInsertDatabaseState());
      getdatafromDB(database);
    }).catchError((error) {
      print('error when inserting data ${error.toString()} ');
    });
  }

  void getdatafromDB(database) {
    newTasks=[];
   doneTasks=[];
   archivedTasks=[];
     database.rawQuery('SELECT * FROM tasks').then((List<Map<dynamic, dynamic>> value){
       value.forEach((element) { 
         if(element['status']=='new'){
           newTasks.add(element);
         }
         else if(element['status']=='done'){
           doneTasks.add(element);
         }
         else{
           archivedTasks.add(element);
           }
       });
       emit(AppGetDatabaseState());
       print(newTasks);
     });
    //print(tasks);
  }
}