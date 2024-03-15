import 'dart:async';

import 'package:alphabet_grid_searcher/GridCreationPage.dart';
import 'package:alphabet_grid_searcher/GridSearchPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget{
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>{
  
  @override
  void initState() {
    super.initState();
    switchActivity();
  }

  

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: _splashScreenAppBar(),
      body: _bodyContainer(),

    );
    }
    
    Container _bodyContainer(){
      return Container(
        color: Colors.blue,
        child: Center(child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 50, height: 50, margin: EdgeInsets.only(bottom: 15),
              child: Image.asset('assets/images/grid_icon.png', color: Colors.white,),
            )
          ],
        )));
    }

    AppBar _splashScreenAppBar(){
      return AppBar(
        backgroundColor: Colors.blue,
        toolbarHeight: 0,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.blue,
          systemNavigationBarColor: Colors.blue
        ),
      );
    }


    void switchActivity() async {

    var pref = await SharedPreferences.getInstance();
    List<String>? alphabetList = pref.getStringList('Alphabet List');

    //check if the first time user then provide option to create new table 
    Timer(const Duration(seconds: 2), () {
      if (alphabetList != null && alphabetList.isNotEmpty){

        //recent user
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
          return  GridSearchPage(alphabetList); 
        },));

      } else {
        //first time user
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
          return const GridCreationPage(); 
        },));
      }
     });
  }
    
}