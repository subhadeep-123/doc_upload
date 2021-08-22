import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Page(),
  ));
}

class Page extends StatelessWidget {
  const Page({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[100],
      appBar: AppBar(
        title: Text("DocApp"),
        backgroundColor: Colors.blue[600],
        centerTitle: true,
      ),
      body: HomePage(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SecondRoute()),
          );
        },
        label: const Text('Search'),
        icon: const Icon(Icons.search),
        backgroundColor: Colors.blue[700],
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // String _name;

  final ButtonStyle style =
      ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20));

  final GlobalKey<ScaffoldState> _scaffoldstate =
      new GlobalKey<ScaffoldState>();

  List<PlatformFile>? _files;

  void _openFileExplorer() async {
    _files = (await FilePicker.platform.pickFiles(
            type: FileType.custom,
            allowMultiple: false,
            allowedExtensions: ['pdf', 'doc', 'docx', 'txt']))!
        .files;

    print('Loaded file path is : ${_files!.first.path}');
    _showSnackBar("File Uploaded");
    //   var uri = Uri.parse('http://192.168.56.1:8080/test');
    //   var request = http.MultipartRequest('POST', uri);
    //   request.files.add(await http.MultipartFile.fromPath(
    //       'file', _files!.first.path.toString()));
    //   var response = await request.send();
    //   if (response.statusCode == 200) {
    //     print('Uploaded ...');
    //   } else {
    //     print('Something went wrong!');
    //   }
  }

  void _showSnackBar(String msg) {
    final snackBar = SnackBar(
      content: Text(
        msg,
        style: TextStyle(color: Colors.black),
      ),
      backgroundColor: Colors.blue[300],
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 2),
      action: SnackBarAction(
          label: 'Done',
          textColor: Colors.black,
          onPressed: () {
            print('Done pressed!');
          }),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Widget userNameParam() {
    return TextFormField(
      decoration: InputDecoration(
        border: UnderlineInputBorder(),
        labelText: 'Enter your Name',
      ),
      validator: (String? value) {
        if (value == null || value.isEmpty) {
          return 'Entered Name is None';
        }

        return null;
      },
      onSaved: (String? value) {
        // _name = value;
        print(value);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: userNameParam()),
          const SizedBox(height: 30),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
            child: Expanded(
              child: ElevatedButton(
                style: style,
                onPressed: _openFileExplorer,
                child: Text('Upload File'),
              ),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: style,
                    onPressed: _openFileExplorer,
                    child: Text('Save Data'),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}

class SecondRoute extends StatelessWidget {
  const SecondRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blue[100],
        appBar: AppBar(
          title: Text("DocApp"),
          backgroundColor: Colors.blue[600],
          centerTitle: true,
        ),
        body: SecondPage(),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Page()),
            );
          },
          label: const Text('Go Back'),
          icon: const Icon(Icons.arrow_left),
          backgroundColor: Colors.blue[700],
        ));
  }
}

class SecondPage extends StatefulWidget {
  const SecondPage({Key? key}) : super(key: key);

  @override
  _SecondPageState createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  final ButtonStyle style =
      ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20));
  List<String> colorList = [
    'Orange',
    'Yellow',
    'Pink',
    'White',
    'Red',
    'Black',
    'Green'
  ];

  final myController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  Widget searchParams() {
    return TextFormField(
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        hintText: 'Enter a search term',
      ),
      controller: myController,
      validator: (String? value) {
        if (value == null || value.isEmpty) {
          return 'Search Parameter is None';
        }

        return null;
      },
      onSaved: (String? value) {
        // _name = value;
        print(value);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: searchParams()),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: ElevatedButton(
              style: style,
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text(myController.text),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, 'OK'),
                          child: const Text('OK'),
                        ),
                      ],
                      content: Container(
                        width: double.minPositive,
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: colorList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return ListTile(
                              title: Text(colorList[index]),
                              onTap: () {
                                Navigator.pop(context, colorList[index]);
                              },
                            );
                          },
                        ),
                      ),
                    );
                  },
                );
              },
              child: Text('Search'),
            ),
          )
        ],
      ),
    );
  }
}
