import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:tflite/tflite.dart';
import 'Storage.dart';
import 'homepage.dart';
import 'package:geocoding/geocoding.dart';

class AddProfile extends StatefulWidget {
  const AddProfile({Key? key}) : super(key: key);

  @override
  _AddProfileState createState() => _AddProfileState();
}

class _AddProfileState extends State<AddProfile> {
  File? _image;
  final picker = ImagePicker();
  List? _outputs;

  // GetLocation location = GetLocation();
  late double start;
  late double end;

  final isSelected = <bool>[false, true];

  final Storage storage = Storage();
  final _name = TextEditingController();
  final _age = TextEditingController();
  final _sex = TextEditingController();
  final _weight = TextEditingController();
  final _desc = TextEditingController();
  late String _live = "";

 PickResult? selectedPlace;
  final ScrollController _scrollController = ScrollController();

  final _formKey = GlobalKey<FormState>(debugLabel: '_AddProfileState');
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

  @override
  Widget build(BuildContext context) {
    String? url = "late";
    return Scaffold(
      appBar: AppBar(
        title: Text('add profile'),
        actions: [
          TextButton(
              child: const Text(
                'Save',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              onPressed: () async {
                //location.marker(_live);
                storage.uploadFile(_image!.path, _name.text + ".png");

                FirebaseFirestore.instance
                    .collection('chat')
                    .doc(_name.text)
                    .set({
                  'list': [],
                });

                FirebaseFirestore.instance
                    .collection('animal')
                    .add(<String, dynamic>{
                  'Category': _outputs![0]['label'].toString().toUpperCase(),
                  'age': int.parse(_age.text),
                  'desc': _desc.text,
                  'eat': 0,
                  'image': _name.text + ".png",
                  'live': _live,
                  'live_start': start,
                  'live_end': end,
                  'like': false,
                  'name': _name.text,
                  'sex': _sex.text,
                  'weight': int.parse(_weight.text),
                  'imagelist': [],
                });
                _name.clear();
                _sex.clear();
                _desc.clear();
                _weight.clear();
                _age.clear();
                //}
                Navigator.pop(context);
              }),
        ],
      ),
      body: Scrollbar(
        controller: _scrollController,
        isAlwaysShown: false,
        thickness: 15,
        child: ListView(
          controller: _scrollController,
          children: <Widget>[
            Column(
              children: [
                Container(
                  color: const Color(0xffd0cece),
                  margin: EdgeInsets.only(left: 0, right: 0),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.width,
                  child: Center(
                    child: _image == null
                        ? Text('No image selected.')
                        : Image.file(File(_image!.path)),
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
            Row(
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return PlacePicker(
                            apiKey: 'AIzaSyDlI2BGIV4xn0H11J32EGLDVTMcE98Nbw8',
                            initialPosition:
                                LatLng(currentLatitude, currentLongitude),
                            useCurrentLocation: true,
                            selectInitialPosition: true,
                            //usePlaceDetailSearch: true
                            onPlacePicked: (result) async {
                              selectedPlace = result;
                              Navigator.of(context).pop();
                              _live = selectedPlace?.formattedAddress ?? "";

                              List<Location> locations =
                                  await locationFromAddress(_live);
                              var live_list =
                                  locations[0].toString().split(":");
                              var live_start = live_list[1].split(",");
                              start = double.parse(live_start[0].toString());
                              var live_end = live_list[2].split(",");
                             end = double.parse(live_end[0].toString());
                            },
                          );
                        },
                      ),
                    );
                  },
                  child: Text("사는 곳을 선택하세요"),
                ),
              ],
            ),
            SizedBox(
              height: 16,
            ),
            Text(
              _live,
              softWrap: true,
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
      ),
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
