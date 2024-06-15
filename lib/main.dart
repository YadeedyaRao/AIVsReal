import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'results.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI_Image_Classifier',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'ML Image Classifier'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final ImagePicker _picker = ImagePicker();
  XFile? _image;

  Future<void> _showImageSourceActionSheet(BuildContext context) async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Files'),
                onTap: () {
                  Navigator.pop(context);
                  _getImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Camera'),
                onTap: () {
                  Navigator.pop(context);
                  _getImage(ImageSource.camera);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future _getImage(ImageSource src) async{
    final XFile? image =  await _picker.pickImage(source: src);
    setState(() {
      _image = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child:Center(
          child: Column(
            children: [
              AppBar(
                leading: IconButton(
                  onPressed: (){Navigator.pop(context);},
                  icon: const Icon(Icons.arrow_back),
                ),
                backgroundColor: Colors.indigo,
                title: const Text('About'),
              ),
              const Text('  This app classifies whether an image is Real or AI generated'),
              const Text('\n\n  To classify, upload the image from Files or camera and click on "PREDICT"'),
              const Text('\n\n  Note that it may not classify all images correctly. To calculate its experimental accuracy try classifying larger sample space of Images')
            ]
          ),
        )
      ),
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context){
            return IconButton(
              onPressed: (){Scaffold.of(context).openDrawer();},
              icon:const Icon(Icons.menu),
            );
          },
        ),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Center(child: Text(widget.title)),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 300,
              width: 300,
              child: Card(
                color: Colors.pinkAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                elevation: 10,
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child : _image == null ?
                            const Icon(
                                Icons.add_photo_alternate,
                                size: 200
                            ) :
                            Image.file(File(_image!.path)),
                )
              ),
            ),
            Container(
              child: _image == null ?
              TextButton(
                onPressed: (){_showImageSourceActionSheet(context);},
                style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.blue,
                      ),
                child:
                      const SizedBox(
                          width: 300,
                          child: Center(child: Text('UPLOAD A PHOTO TO CLASSIFY', style: TextStyle(fontWeight: FontWeight.bold)))
                      ),
              ) :
              Column(
                children : [
                  TextButton(
                    onPressed: (){_showImageSourceActionSheet(context);},
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.black,
                      backgroundColor: Colors.amber,
                    ),
                    child: const SizedBox(
                      width: 300,
                        child: Center(child: Text('CHANGE THE PHOTO', style: TextStyle(fontWeight: FontWeight.bold))),
                    ),
                  ),
                  TextButton(
                    onPressed : (){
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Results(image : _image))
                      );
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.teal,
                    ),
                    child: const SizedBox(
                      width: 300,
                        child: Center(child: Text('PREDICT', style: TextStyle(fontWeight: FontWeight.bold),)),
                    ),
                  ),
                ]
              ),
            )
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
