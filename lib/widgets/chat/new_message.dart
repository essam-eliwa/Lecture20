import 'dart:io';
import 'package:uuid/uuid.dart';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class NewMessage extends StatefulWidget {
  @override
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final _controller = new TextEditingController();
  var _enteredMessage = '';

  void _sendMessage() async {
    FocusScope.of(context).unfocus();
    final user = FirebaseAuth.instance.currentUser;
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();
    FirebaseFirestore.instance.collection('chat').add({
      'text': _enteredMessage,
      'createdAt': Timestamp.now(),
      'userId': user.uid,
      'username': userData.data()['username'],
      'userImage': userData.data()['image_url']
    });
    setState(() {
      _enteredMessage = '';
    });

    _controller.clear();
  }

  Future<void> _sendPicMessage() async {
    var uuid = Uuid();
    final picker = ImagePicker();
    final pickedImage = await picker.getImage(
      source: ImageSource.camera,
      imageQuality: 80,
      maxWidth: 200,
    );
    final pickedImageFile = File(pickedImage.path);
    final userId = FirebaseAuth.instance.currentUser.uid;
    final ref = FirebaseStorage.instance
        .ref()
        .child('${userId}_images')
        .child(userId + '_' + uuid.v1() + '.jpg');

    await ref.putFile(pickedImageFile).whenComplete(() => null);

    final url = await ref.getDownloadURL();

    final userData =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();

    FirebaseFirestore.instance.collection('chat').add({
      'text': _enteredMessage,
      'image': url,
      'createdAt': Timestamp.now(),
      'userId': userId,
      'username': userData.data()['username'],
      'userImage': userData.data()['image_url']
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 8),
      padding: EdgeInsets.all(8),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: _controller,
              textCapitalization: TextCapitalization.sentences,
              autocorrect: true,
              enableSuggestions: true,
              decoration: InputDecoration(labelText: 'Send a message...'),
              onChanged: (value) {
                setState(() {
                  _enteredMessage = value;
                });
              },
            ),
          ),
          IconButton(
            color: Theme.of(context).accentColor,
            icon: Icon(
              Icons.camera,
            ),
            onPressed: _sendPicMessage,
          ),
          IconButton(
            color: Theme.of(context).accentColor,
            icon: Icon(
              Icons.send,
            ),
            onPressed: _enteredMessage.trim().isEmpty ? null : _sendMessage,
          ),
        ],
      ),
    );
  }
}
