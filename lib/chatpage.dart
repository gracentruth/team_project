import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:text_to_speech/text_to_speech.dart';

String docid = '';
String petname = '';
String username = '';

class ChatPage extends StatefulWidget {
  final String doc;
  final String name;

  ChatPage({required this.doc, required this.name});

  @override
  _ChatPageState createState() {
    docid = doc;
    petname = name;
    return _ChatPageState();
  }
}

class _ChatPageState extends State<ChatPage> {

  User user = FirebaseAuth.instance.currentUser!;
  final _controller = TextEditingController();
  String message = "";
  TextToSpeech tts = TextToSpeech();

  void send() async {
    FocusScope.of(context).unfocus();
    final user = FirebaseAuth.instance.currentUser;
    final userData = await FirebaseFirestore.instance.collection('chat')
        .doc(petname).get();
    final userName = await FirebaseFirestore.instance.collection('user')
        .doc(user!.uid).get();
    if(userData.data()!['List'] == null) {
      Map<String, dynamic> data = <String, dynamic>{
        'name' : userName.data()!['name'],
        'text' : message,
        'time' : DateTime.now(),
      };
      FirebaseFirestore.instance.collection('chat').doc(petname).set({
        'list' : FieldValue.arrayUnion([data])
      }, SetOptions(merge: true));
    }
    else {
      final temp = userData.data()!['list'];
      List<Map> tempList = temp as List<Map>;
      tempList.add({'name' : userData.data()!['name'], 'text' : message, 'time' : DateTime.now()});
      Map<String, dynamic> data = <String, dynamic>{
        'list' : tempList,
      };
      FirebaseFirestore.instance.collection('chat').doc(petname).set({
        'list' : FieldValue.arrayUnion([data])
      }, SetOptions(merge: true));
    }
    _controller.clear();
  }

  void getname() async {
    final ref = await FirebaseFirestore.instance.collection('user').doc(user.uid).get();
    username = ref.data()!['name'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(petname)
        ),
        backgroundColor: Colors.grey,
        body: Container(
          child: Column(
            children: [
              Expanded(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                    child: StreamBuilder<DocumentSnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('chat')
                          .doc(petname)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if(snapshot.connectionState == ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        List<dynamic> list = snapshot.data!.get('list') as List<dynamic>;
                        getname();
                        return ListView.builder(
                            itemCount : list.length,
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  Container(
                                    width: 300,
                                    color: Colors.yellow[100],
                                    child: Padding(
                                      padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${list[index]['name']}',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(width: 30),
                                          Text(
                                            '${DateFormat('yy-MM-dd HH:mm:ss').format(list[index]['time'].toDate())}',
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: 300,
                                    color: Colors.white,
                                    child: Padding(
                                      padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                                      child: Text(
                                          '${list[index]['text']}'
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 15),
                                ],
                              );
                            });
                      },
                    ),
                  )
              ),
              Container(
                color: Colors.white,
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        tts.setVolume(100.0);
                        tts.speak(_controller.text);
                      },
                      icon: Icon(Icons.volume_up),
                      color: Colors.blue,
                    ),
                    Expanded(
                      child: TextField(
                        maxLines: null,
                        controller: _controller,
                        decoration: InputDecoration(labelText: 'Send a message...'),
                        onChanged: (value) {
                          setState(() {
                            message = value;
                          });
                        },
                      ),
                    ),
                    IconButton(
                      onPressed: message.trim().isEmpty ? null : send,
                      icon: Icon(Icons.send),
                      color: Colors.blue,
                    ),
                  ],
                ),
              )
            ],
          ),
        )

      //title: Text(docid)
    );



  }
}


