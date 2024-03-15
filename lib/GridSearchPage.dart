import 'package:alphabet_grid_searcher/GridCreationPage.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

List<String> charList = [];
String searchedText = '0';
List<int> positions = [];


class GridSearchPage extends StatefulWidget {
  List<String> alphabetList = [];
  GridSearchPage(this.alphabetList, {super.key}) {
    charList = alphabetList;
  }

  @override
  State<GridSearchPage> createState() => _GridSearchPageState();
}

class _GridSearchPageState extends State<GridSearchPage> {
  int totalRows = 0, totalColumns = 1;

  @override
  void initState() {
    super.initState();

    getRowsAndColumns();
    positions.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: _appBar(), body: _gridSearchPageBody());
  }

  SizedBox _gridSearchPageBody() {
    return SizedBox(
      height: double.infinity,
      child: Column(
        children: [
          _searchTextField(), 
          _gridViewForAlphabets()],
      ),
    );
  }

  Expanded _gridViewForAlphabets() {
    return Expanded(
      child: SizedBox(
          height: double.infinity,
          child: Container(
            margin: const EdgeInsets.all(20),
            child: GridView.builder(
              itemCount: charList.length,
              physics: const ScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: totalColumns,
                  mainAxisSpacing: 5,
                  crossAxisSpacing: 5),
              itemBuilder: (context, index) {
                Color color = Colors.blue;

                if (positions.isNotEmpty) {
                  for (int i = 0; i < positions.length; i++) {
                    if (positions[i] == index) {
                      color = Colors.amber;
                    }
                  }
                }

                return Container(
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Center(
                        child: AutoSizeText(
                      charList[index],
                      maxFontSize: 40,
                      minFontSize: 12,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 40,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    )),
                  ),
                );
              },
            ),
          )),
    );
  }

  Container _searchTextField() {
    return Container(
      margin: const EdgeInsets.only(top: 10, left: 20, right: 20),
      child: TextFormField(
        textInputAction: TextInputAction.search,
        onFieldSubmitted: (value) {
          setState(() {
            searchWord(value);
          });
        },
        onChanged: (value) {
          searchedText = value;
        },
        decoration: InputDecoration(
            suffixIcon: IconButton(
              icon: const Icon(
                Icons.search_rounded,
                color: Colors.blue,
              ),
              onPressed: () {
                setState(() {
                  //check if keyboard is visible
                  // ignore: deprecated_member_use
                  if (WidgetsBinding.instance.window.viewInsets.bottom > 0.0) {
                    // Keyboard is visible.
                    FocusScope.of(context).unfocus();
                  } else {
                    // Keyboard is not visible.
                  }
                  searchWord(searchedText);
                });
              },
            ),
            labelText: 'Search words in grid',
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            focusedBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(color: Colors.blue))),
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      backgroundColor: Colors.blue,
      centerTitle: true,
      title: const Text(
        'Grid Searcher',
        style: TextStyle(color: Colors.white),
      ),
      actions: [
        PopupMenuButton(
          iconColor: Colors.white,
          itemBuilder: (ctx) => [
            _buildPopupMenuItem('Create New Table'),
          ],
        )
      ],
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Colors.blue,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Colors.white,
      ),
    );
  }

  PopupMenuItem _buildPopupMenuItem(String title) {
    return PopupMenuItem(
      child: Text(title),
      onTap: () {
        createNewTable();
      },
    );
  }

//create new table for reset the setup
  void createNewTable() {
    Navigator.pushReplacement(context, MaterialPageRoute(
      builder: (context) {
        return GridCreationPage();
      },
    ));
  }

  void getRowsAndColumns() async {
    //get the inputed rows and columns by user from shared preferences
    var sharedPreferences = await SharedPreferences.getInstance();
    totalRows = sharedPreferences.getInt('Rows')!;
    totalColumns = sharedPreferences.getInt('Columns')!;

    setState(() {});
  }

  void searchWord(String word) {
    
    List gridElements = List.generate(totalRows, (index) => List.filled(totalColumns, '0'),
        growable: false);

    int counter = 0;
    for (int i = 0; i < gridElements.length; i++) {
      for (int j = 0; j < gridElements[i].length; j++) {
        gridElements[i][j] = charList[counter];
        counter++;
      }
    }

    var p = searchWordIn2DArray(gridElements, word);

    if (p.isEmpty) {
      Fluttertoast.showToast(
          msg: 'No match found',
          backgroundColor: Colors.red,
          textColor: Colors.white,
          toastLength: Toast.LENGTH_SHORT);
    }
  }

  List<int> searchWordIn2DArray(List grid, String word) {
    positions.clear();
    int m = grid.length;
    if (m == 0) return positions; // If grid is empty, return empty positions

    int n = grid[0].length;
    if (n == 0) {
      return positions; // If grid rows are empty, return empty positions
    }

    word = word.toLowerCase(); // Convert the search word to lowercase

    // Define directions for search (right, down, diagonal)
    List<List<int>> directions = [
      [0, 1], // right
      [1, 0], // down
      [1, 1] // diagonal
    ];

    for (int i = 0; i < m; i++) {
      for (int j = 0; j < n; j++) {
        for (var direction in directions) {
          int dx = direction[0];
          int dy = direction[1];
          int x = i;
          int y = j;
          int k;

          // Check if word can fit in the current direction
          for (k = 0; k < word.length; k++) {
            int newX = x + dx * k;
            int newY = y + dy * k;

            // Check if indices are within the grid
            if (newX < 0 || newX >= m || newY < 0 || newY >= n) break;

            // Convert grid letter to lowercase for comparison
            String gridLetter = grid[newX][newY].toLowerCase();

            // Check if current letter matches with the word (case insensitive)
            if (gridLetter != word[k]) break;
          }

          // If the entire word is found, store its positions
          if (k == word.length) {
            // Store the positions in 1D list
            for (int l = 0; l < word.length; l++) {
              int pos = x * n + y + l * (dx * n + dy);
              positions.add(pos);
            }
            return positions;
          }
        }
      }
    }
    return positions; // Return empty positions if word not found
  }
}
