import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';

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
  TextEditingController nameController = TextEditingController();

  final ButtonStyle style =
      ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20));

  final GlobalKey<ScaffoldState> _scaffoldstate =
      new GlobalKey<ScaffoldState>();

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

  List<PlatformFile>? _files;

  Future uploadFile() async {
    var filename = (_files!.first.path.toString().split('/').last);
    print(filename);
    var uri = Uri.parse(
        'http://192.168.0.101/upload?uname=${nameController.text}&fname=${filename}');
    var request = http.MultipartRequest('POST', uri);
    request.files.add(await http.MultipartFile.fromPath(
        'file', _files!.first.path.toString()));
    var response = await request.send();
    if (response.statusCode == 200) {
      _showSnackBar("Image Uploaded ${nameController.text}");
    } else {
      _showSnackBar('Something went wrong! ${nameController.text}');
    }
    setState(() {});
  }

  Future _openFileExplorer() async {
    _files = (await FilePicker.platform.pickFiles(
            type: FileType.any, allowMultiple: false, allowedExtensions: null))!
        .files;

    print('Loaded file path is : ${_files!.first.path}');
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: TextFormField(
              controller: nameController,
              decoration: InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Enter your Name',
              ),
            ),
          ),
          SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
            child: IconButton(
              icon: Icon(Icons.document_scanner),
              onPressed: _openFileExplorer,
            ),
          ),
          SizedBox(height: 30),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: style,
                    child: Text('Save Data'),
                    onPressed: () {
                      uploadFile();
                    },
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

  TextEditingController SearchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: TextFormField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter a search term',
              ),
              controller: SearchController,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: ElevatedButton(
              style: style,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ListDataPage(SearchController.text),
                  ),
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

class ListDataPage extends StatefulWidget {
  final String previousPageValue;
  const ListDataPage(this.previousPageValue);

  @override
  _ListDataPageState createState() =>
      _ListDataPageState(this.previousPageValue);
}

class _ListDataPageState extends State<ListDataPage> {
  String previousPageValue;
  _ListDataPageState(this.previousPageValue);

  List listResponse = [];

  Future fetchData() async {
    var url = "http://192.168.0.101/fetch?uname=$previousPageValue";
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      setState(() {
        listResponse = json.decode(response.body);
      });
    }
  }

  @override
  void initState() {
    fetchData();
    super.initState();
    print(listResponse);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blue[100],
        appBar: AppBar(
          title: Text("DocApp - Search Data"),
          backgroundColor: Colors.blue[600],
          centerTitle: true,
        ),
        body: SafeArea(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: listResponse.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                title: Text(listResponse[index]),
                onTap: () {
                  Navigator.pop(context, listResponse[index]);
                },
              );
            },
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SecondRoute()),
            );
          },
          label: const Text('Go Back'),
          icon: const Icon(Icons.arrow_left),
          backgroundColor: Colors.blue[700],
        ));
  }
}
