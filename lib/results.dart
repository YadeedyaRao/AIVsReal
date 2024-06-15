import 'package:flutter/material.dart';
import 'dart:io';
import 'package:cross_file/cross_file.dart';
import 'package:flutter_tflite/flutter_tflite.dart';
class Results extends StatefulWidget{
  final XFile? image;
  Results({super.key, required this.image});
  @override
  State<Results> createState() => _ResultsState();
}

class _ResultsState extends State<Results>{
  bool _done = false;
  late List results;
  final List _cls = [Colors.greenAccent, Colors.redAccent];
  @override
  void dispose(){
    super.dispose();
    Tflite.close();
  }
  @override
  void initState(){
    super.initState();
    loadModel();
    predict();
  }
  Future loadModel() async{
    String? res = await Tflite.loadModel(
      model: "assets/model.tflite",
      labels: "assets/labels.txt",
      numThreads: 1,
    );
    print('status - $res');
  }
  Future predict() async{
    var recognitions = await Tflite.runModelOnImage(
        path: widget.image!.path,   // required
        imageMean: 0.0,   // defaults to 117.0
        imageStd: 255.0,  // defaults to 1.0
        numResults: 2,    // defaults to 5
        threshold: 0,   // defaults to 0.1
        asynch: true      // defaults to true
    );
    setState(() {
      //load predictions
      results = recognitions!;
      print(results);
      _done = true;
    });
  }
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        leading : IconButton(
          onPressed: (){Navigator.pop(context);},
          icon: const Icon(Icons.keyboard_backspace_sharp),
        ),
        title: const Text('Results'),
      ),
      body:Center(
        child : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children : [
            Text(
                "Classified as ${results[0]['label']}",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
            ),
            SizedBox(
              height: 300,
              width: 300,
              child: Card(
                  elevation: 10,
                  margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.file(File(widget.image!.path)),
                  )
              ),
            ),
            Container(
              child: _done ?
              Column(
                children : results.map((result){
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:[
                      const SizedBox(
                        height: 20,
                      ),
                      Text("${result['label']}"),
                      Container(
                        width: 300,
                        height : 25,
                        decoration: BoxDecoration(
                          color : Colors.blueGrey,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child : FractionallySizedBox(
                          alignment: Alignment.centerLeft,
                          widthFactor: result['confidence'],
                          child: Container(
                            alignment: Alignment.centerRight,
                            decoration: BoxDecoration(
                              color: _cls[(results[0]['label'] == result['label'] ? 0 : 1)],
                              borderRadius: BorderRadius.circular(25)
                            ),
                            child: Container(
                              margin : EdgeInsets.fromLTRB(0, 0, 8, 0),
                                child: Text("${(result['confidence'] * 100).toStringAsFixed(2)}%", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),)
                            ),
                          ),
                        ),
                      )
                    ]
                  );
                }).toList(),
              )
              :
              const Text('Loading...') // if not done
              ,
            )
          ]
        )
      ),
    );
  }
}