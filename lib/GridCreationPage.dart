import 'package:alphabet_grid_searcher/AlphabetCreationScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

BuildContext? contexts;
String columnInputString = "", rowInputString = "";

class GridCreationPage extends StatefulWidget {
  const GridCreationPage({super.key});

  @override
  State<GridCreationPage> createState() => _GridCreationPageState();
}

class _GridCreationPageState extends State<GridCreationPage> {
  var rowEditTextController = TextEditingController();
  var columnEditTextController = TextEditingController();
  final _rowFormKey = GlobalKey<FormState>();
  Color blue = Colors.blue;

  @override
  Widget build(BuildContext context) {
    contexts = context;

    return Scaffold(
      backgroundColor: blue, 
      body: _gridCreationBody());
  }

  Center _gridCreationBody() {

    return Center(
      child: Card(
        elevation: 5,
        margin: EdgeInsets.only(left: 20, right: 20),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 405,
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(10))),

          child: Column(
            children: [
              _welcomeTitle(),
              _createATableTitle(),

              //row textfield
              _rowTextField(),

              //column text field
              _columnTextField(),

              //create table button
              _createTableButton()
            ],
          ),
        ),
      ),
    );
  }

  Container _createTableButton(){
    return Container(
                width: double.infinity,
                height: 50,
                margin: EdgeInsets.only(left: 40, right: 40, top: 20),
                child: ElevatedButton(
                    style: ButtonStyle(
                        shape: MaterialStateProperty.all(
                            const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)))),
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.blue)),
                    onPressed: () {
                      createTable();
                    },
                    child: const Text(
                      'Create Table',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white),
                    )),
              );
  }

  Container _createATableTitle(){

    return Container(
                margin: EdgeInsets.only(top: 20, left: 20),
                width: MediaQuery.of(context).size.width,
                child: const Text(
                  'Create a table',
                  textAlign: TextAlign.start,
                  style: TextStyle(color: Colors.black),
                ),
              );
  }

  Padding _welcomeTitle(){
    return const Padding(
                padding: EdgeInsets.only(top: 10),
                child: Text(
                  'Welcome',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                      letterSpacing: 1),
                ),
              );
  }

  Container _columnTextField() {
    return Container(
      margin: EdgeInsets.only(right: 20, left: 20, top: 20),
      child: TextFormField(
        maxLength: 2,
        keyboardType: TextInputType.number,
        onChanged: (text) {
          columnInputString = text;
        },
        decoration: const InputDecoration(
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))),
            label: Text('Columns (min 5 and max 10)'),
            prefixIcon: Icon(Icons.view_column_outlined),
            focusColor: Colors.blue,
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(color: Colors.blue))),
      ),
    );
  }

  Container _rowTextField() {
    return Container(
      margin: const EdgeInsets.only(right: 20, left: 20, top: 20),
      child: TextFormField(
        key: _rowFormKey,
        maxLength: 2,
        controller: rowEditTextController,
        keyboardType: TextInputType.number,
        onChanged: (text) {
          rowInputString = text;
        },
        decoration: const InputDecoration(
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))),
            label: Text('Rows (min 5 and max 10)'),
            prefixIcon: Icon(Icons.table_rows_outlined),
            focusColor: Colors.blue,
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(color: Colors.blue))),
      ),
    );
  }

  void createTable() async {
    //pattern to accept only 1 to 0 digits
    RegExp regex = RegExp(r'^[1-9]\d*$');

  //check if user put wrong inputs
    if (rowInputString == "" ||
        rowInputString == "0" ||
        rowInputString == "00") {
      showErrorSnackBar('Enter rows');
      return;
    }

    if (columnInputString == "" ||
        columnInputString == "0" ||
        columnInputString == "00") {
      showErrorSnackBar('Enter columns');
      return;
    }

    if (!regex.hasMatch(rowInputString) || !regex.hasMatch(columnInputString)) {
      showErrorSnackBar('Only numbers are allowed in row and column');
      return;
    }

    int rows = int.parse(rowInputString);
    int columns = int.parse(columnInputString);

  //rows should be greter than 10 but less than 5
    if (rows > 10 || rows < 5) {
      showErrorSnackBar('Enter number between 5 to 10 for Row');
      return;
    }

  //columns should be greter than 10 but less than 5
    if (columns > 10 || columns < 5) {
      showErrorSnackBar('Enter number between 5 to 10 for Column');
      return;
    }

    //store the value of rows and columns to share preferences for later user
    var sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setInt("Rows", rows);
    sharedPreferences.setInt("Columns", columns);


    //start activity for alphabet creation
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => AlphabetCreationScreen(rows, columns),
        ));
  }
}

void showErrorSnackBar(String text) {
  ScaffoldMessenger.of(contexts!).showSnackBar(SnackBar(
    content: Text(text),
    backgroundColor: Colors.redAccent,
  ));
}
