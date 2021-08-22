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
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
    var uri = Uri.parse('http://192.168.56.1:8080/test');
    var request = http.MultipartRequest('POST', uri);
    request.files.add(await http.MultipartFile.fromPath(
        'file', _files!.first.path.toString()));
    var response = await request.send();
    if (response.statusCode == 200) {
      print('Uploaded ...');
    } else {
      print('Something went wrong!');
    }
  }

  void _showSnackBar(String msg) {
    final snackBar = SnackBar(
      content: Text(msg),
      backgroundColor: Colors.green[800],
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 2),
      action: SnackBarAction(
          label: 'Done',
          textColor: Colors.white,
          onPressed: () {
            print('Done pressed!');
          }),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter a search term',
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: TextFormField(
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Enter your Name',
              ),
            ),
          ),
          const SizedBox(height: 30),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: style,
                    onPressed: _openFileExplorer,
                    child: Text('Upload'),
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                Expanded(
                  child: ElevatedButton(
                    style: style,
                    onPressed: () {},
                    child: Text('Search '),
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          // Padding(
          //   padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          //   child: Expanded(
          //     child: ElevatedButton(
          //       style: style,
          //       onPressed: _openFileExplorer,
          //       child: Text('Upload File'),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
