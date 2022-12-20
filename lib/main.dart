import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({
    super.key,
  });

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  PlatformFile? _platformFile;
  String _pickedFile = "No file picked";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Flutter File Picker"),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _platformFile != null
                  ? Container(
                      color: Colors.blue,
                      child: Column(
                        children: [
                          Text(_pickedFile),
                          Image.file(
                            File(_platformFile!.path!),
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ],
                      ),
                    )
                  : Text(
                      _pickedFile,
                    ),
              ElevatedButton(
                onPressed: () async => _selectFile(),
                child: const Text("Select image"),
              ),
              ElevatedButton(
                onPressed: () async => _uploadFile(),
                child: const Text("Upload image"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future _uploadFile() async {
    if (_platformFile == null) return;
    final path = 'files/${_platformFile?.name}';
    final file = File(_platformFile!.path!);
    final ref = FirebaseStorage.instance.ref().child(path);
    final uploaded = ref.putFile(file);
    log(uploaded.toString());
    setState(() {
      _platformFile = null;
      _pickedFile = 'No file picked';
    });
  }

  Future<void> _selectFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );
    if (result == null) return;
    setState(() {
      _platformFile = result.files.first;
      _pickedFile = result.files.first.name;
    });
    log(_platformFile!.path.toString());
    log(_platformFile.toString());
  }
}
