import 'package:alphabet_grid_searcher/GridSearchPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

String titleText = "";
int totalGrids = 0;

class AlphabetCreationScreen extends StatefulWidget {
  final int rows, columns;

  AlphabetCreationScreen(this.rows, this.columns) {
    totalGrids = rows * columns;
    titleText = "Enter  $totalGrids Alphabets";
  }

  @override
  State<AlphabetCreationScreen> createState() => _AlphabetCreationScreenState();
}

class _AlphabetCreationScreenState extends State<AlphabetCreationScreen> {
  Color blue = Colors.blue;
  var errorMessage = null;
  List<String> charList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: blue,
        appBar: _appBar(),
        body: _alphabetCreationBody());
  }

  Container _alphabetCreationBody() {
    return Container(
      margin: EdgeInsets.only(top: 100),
      height: double.infinity,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _userInputWindowForAcceptionAlphabets(),
            _gridForDisplayingTypedAlphabetsByUser()
          ],
        ),
      ),
    );
  }

  Container _gridForDisplayingTypedAlphabetsByUser() {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.all(25),
      height: 300,
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 10, mainAxisSpacing: 2, crossAxisSpacing: 2),
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(5),
            child: Text(
              charList[index],
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 17),
            ),
          );
        },
        itemCount: charList.length,
      ),
    );
  }

  Card _userInputWindowForAcceptionAlphabets() {
    return Card(
      elevation: 5,
      margin: EdgeInsets.only(left: 20, right: 20),
      child: Container(
        width: double.infinity,
        height: 270,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            color: Colors.white),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _enterAlphabetsTitle(),
            _userInputTextFieldForAlphabets(),
            _submitButton()
          ],
        ),
      ),
    );
  }

  Container _submitButton() {
    return Container(
      width: double.infinity,
      height: 50,
      margin: EdgeInsets.only(left: 40, right: 40, top: 20),
      child: ElevatedButton(
          style: ButtonStyle(
              shape: MaterialStateProperty.all(const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)))),
              backgroundColor: MaterialStateProperty.all<Color>(Colors.blue)),
          onPressed: () {
            submit(charList);
          },
          child: const Text(
            'Submit',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white),
          )),
    );
  }

  Container _userInputTextFieldForAlphabets() {
    return Container(
      height: 85,
      margin: EdgeInsets.only(top: 20, left: 20, right: 20),
      child: TextFormField(
        maxLength: totalGrids,
        inputFormatters: [
          FilteringTextInputFormatter.allow(
              RegExp(r'^[a-zA-Z]+')), // Allow only one comma and alphabets
        ],
        onChanged: (text) {
          setState(() {
            createGridFromText(text);
          });
        },
        keyboardType: TextInputType.name,
        decoration: InputDecoration(
          labelText: 'Enter Alphabets',
          errorText: errorMessage,
          helperText: 'Total Alphabets: $totalGrids | Example: ABCDE',
          prefixIcon: Icon(Icons.abc_rounded),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blue),
              borderRadius: BorderRadius.all(Radius.circular(10))),
        ),
      ),
    );
  }

  Text _enterAlphabetsTitle() {
    return Text(
      'Enter Alphabets',
      textAlign: TextAlign.center,
      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
    );
  }

  AppBar _appBar() {
    return AppBar(
      toolbarHeight: 0,
      systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.blue,
          statusBarIconBrightness: Brightness.light,
          systemNavigationBarColor: Colors.blue),
    );
  }

  //submit button click for displaying grid
  void submit(List<String> alphabetList) async {
    if (alphabetList.length != totalGrids) {
      showErrorSnackBar('Please enter exactly $totalGrids characters');
      return;
    }

    //start activity for displaying grid
    Navigator.pushReplacement(context, MaterialPageRoute(
      builder: (context) {
        return GridSearchPage(alphabetList);
      },
    ));

    //store the alphabet list entered by user for later use
    var pref = await SharedPreferences.getInstance();
    pref.setStringList("Alphabet List", alphabetList);
  }

  void showErrorSnackBar(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(text),
      backgroundColor: Colors.redAccent,
    ));
  }

  void createGridFromText(String input) {
    charList = input.toUpperCase().split('');
  }
}
