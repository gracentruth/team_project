import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';
import 'Storage.dart';

class UpdateProfile extends StatefulWidget {
  const UpdateProfile({Key? key, required this.docId}) : super(key: key);

  final docId;

  @override
  _UpdateProfileState createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  File? _image;
  final picker = ImagePicker();
  List? _outputs;

  final isSelected = <bool>[false, true];

  final Storage storage = Storage();
  final _name = TextEditingController();
  final _age = TextEditingController();
  final _sex = TextEditingController();
  final _weight = TextEditingController();
  final _desc = TextEditingController();
  final _live = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final _formKey = GlobalKey<FormState>(debugLabel: '_UpdateProfileState');
  FirebaseAuth _auth = FirebaseAuth.instance;
  String _fileName = 'logo.png';

  @override
  void initState() {
    super.initState();
    loadModel().then((value) {
      setState(() {});
    });
  }

  // 모델과 label.txt를 가져온다.
  loadModel() async {
    await Tflite.loadModel(
      model: "assets/model_unquant.tflite",
      labels: "assets/testlabel.txt",
    ).then((value) {
      setState(() {
        //_loading = false;
      });
    });
  }

  Future updateProduct(BuildContext context) async {
    try {
      Map<String, dynamic> data = <String, dynamic>{
        'Category': _outputs![0]['label'].toString().toUpperCase(),
        'age': int.parse(_age.text),
        'desc': _desc.text,
        'eat': 0,
        'image': _name.text + "change.png",
        'live': _live.text,
        'like': 0,
        'name': _name.text,
        'sex': _sex.text,
        'weight': int.parse(_weight.text),
      };

      print("file");
      print(_fileName);

      return FirebaseFirestore.instance
          .collection('animal')
          .doc(widget.docId)
          .update(data)
          .whenComplete(() => print("update completed"))
          .catchError((e) => print(e));
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    String? url = "late";
    Stream<DocumentSnapshot> _stream = FirebaseFirestore.instance
        .collection('update')
        .doc(widget.docId)
        .snapshots();
    return Scaffold(
      appBar: AppBar(
        title: Text('update profile'),
        actions: [
          TextButton(
              child: const Text(
                'Save',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              onPressed: () async {
                storage.uploadFile(_image!.path, _name.text + "change.png");
                updateProduct(context);
                _name.clear();
                _sex.clear();
                _live.clear();
                _desc.clear();
                _weight.clear();
                _age.clear();
                Navigator.pop(context);
              }),
        ],
      ),
      body: StreamBuilder<DocumentSnapshot>(
          stream: _stream,
          builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasData) {
              var data = snapshot.data!;
              if (_fileName == 'logo.png') _fileName = data["image"];
              if (data["Category"] == "DOG") {
                isSelected[0] = true;
                isSelected[1] = false;
              } else {
                isSelected[0] = false;
                isSelected[1] = true;
              }

              _name.text = data["name"];
              _age.text = data["age"].toString();
              _sex.text = data["sex"];
              _live.text = data["live"];
              _desc.text = data["desc"];
              _weight.text = data["weight"].toString();

              return Scrollbar(
                controller: _scrollController,
                isAlwaysShown: false,
                thickness: 15,
                child: ListView(
                  controller: _scrollController,
                  children: <Widget>[
                    Column(
                      children: [
                        Container(
                          child: FutureBuilder(
                            future: storage.downloadURL(_fileName),
                            builder: (BuildContext context,
                                AsyncSnapshot<String> snapshot) {
                              if (snapshot.connectionState ==
                                      ConnectionState.done &&
                                  snapshot.hasData) {
                                print("file = ");
                                print(_fileName);
                                url = snapshot.data;
                                return Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: MediaQuery.of(context).size.width,
                                    child: Image.network(
                                      url!,
                                      fit: BoxFit.fill,
                                    ));
                              }

                              if (snapshot.connectionState ==
                                      ConnectionState.waiting ||
                                  !snapshot.hasData) {
                                return CircularProgressIndicator();
                              }

                              return Container();
                            },
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 10, 10, 0),
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: IconButton(
                                  icon: const Icon(Icons.add_a_photo),
                                  onPressed: () async {
                                    await getImage(ImageSource.camera);
                                  },
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 10, 10, 0),
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: IconButton(
                                  icon: const Icon(Icons.collections_rounded),
                                  onPressed: () async {
                                    await getImage(ImageSource.gallery);
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                        ToggleButtons(
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: Text("DOG"),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: Text("CAT"),
                            ),
                          ],
                          isSelected: isSelected,
                          onPressed: (index) {
                            // Respond to button selection
                            setState(
                              () {
                                isSelected[index] = !isSelected[index];
                                if (index == 0) {
                                  isSelected[1] = !isSelected[1];
                                } else {
                                  isSelected[0] = !isSelected[0];
                                }
                              },
                            );
                          },
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    TextFormField(
                      controller: _name,
                      decoration: const InputDecoration(
                        filled: false,
                        labelText: "이름을 입력하세요",
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    TextFormField(
                      controller: _age,
                      decoration: const InputDecoration(
                        filled: false,
                        labelText: "나이를 입력하세요",
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    TextFormField(
                      controller: _sex,
                      decoration: const InputDecoration(
                        filled: false,
                        labelText: "성별 입력하세요",
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    TextFormField(
                      controller: _live,
                      decoration: const InputDecoration(
                        filled: false,
                        labelText: "사는 곳을 입력하세요",
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    TextFormField(
                      controller: _weight,
                      decoration: const InputDecoration(
                        filled: false,
                        labelText: "몸무게 입력하세요",
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    TextFormField(
                      controller: _desc,
                      decoration: const InputDecoration(
                        filled: false,
                        labelText: "특이사항을 입력하세요",
                      ),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                  ],
                ),
              );
            }
            return Container();
          }),
    );
  }

  Future getImage(ImageSource imageSource) async {
    final image = await picker.pickImage(source: imageSource);

    setState(() {
      _image = File(image!.path);
      _fileName = _image!.path; // 가져온 이미지를 _image에 저장
    });
    await classifyImage(File(image!.path)); // 가져온 이미지를 분류 하기 위해 await을 사용
  }

  // 이미지 분류
  Future classifyImage(File image) async {
    print("$image");
    var output = await Tflite.runModelOnImage(
        path: image.path,
        imageMean: 0.0,
        // defaults to 117.0
        imageStd: 255.0,
        // defaults to 1.0
        numResults: 2,
        // defaults to 5
        threshold: 0.2,
        // defaults to 0.1
        asynch: true // defaults to true
        );
    setState(() {
      _outputs = output;
      print(_outputs![0]['label'].toString().toUpperCase());
      if (_outputs![0]['label'].toString().toUpperCase() == "CAT") {
        isSelected[0] = false;
        isSelected[1] = true;
      } else {
        print(_outputs![0]['label'].toString().toUpperCase());
        isSelected[0] = true;
        isSelected[1] = false;
      }
    });
  }
}
