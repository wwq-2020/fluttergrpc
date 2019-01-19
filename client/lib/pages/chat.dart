import "package:flutter/material.dart";
import "dart:async";
import "buffer.dart";
import 'chatservice.dart';
import 'chatmessage.dart';

class Chat extends StatefulWidget {
  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {

  ChatService _service;
  Buffer _buffer;
  StreamController _streamController= StreamController<List<Message>>();
  TextEditingController _textController = TextEditingController();

  List<Text> _messages=<Text>[];

  @override
  void initState() {
    super.initState();
    _buffer = Buffer<Message>(period:Duration(milliseconds: 100),onReceive:onMessageFromBuffer);
    _buffer.start();
    _service=ChatService(onMessageReceive);
    _service.subscribe();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: Text("my chat app")),
      body: Column(
        children: <Widget>[
          Flexible(
            child: StreamBuilder<List<Message>>(
              stream: _streamController.stream,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasError) {
                  return Text("Error: ${snapshot.error}");
                }
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    break;
                  case ConnectionState.active:
                  case ConnectionState.done:
                    _addMessages(snapshot.data);
                }
                return ListView.builder(
                    padding: EdgeInsets.all(8.0),
                    itemBuilder: (_, int index) => _messages[index],
                    itemCount: _messages.length);
              },
            ),
          ),
          Divider(height: 1.0),
          Container(
            decoration: BoxDecoration(color: Theme.of(context).cardColor),
            child: _buildTextComposer(),
          ),
        ],
      ),
    );
  }
  @override
  Widget _buildTextComposer() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: <Widget>[
          Flexible(
            child: TextField(
              maxLines: null,
              textInputAction: TextInputAction.send,
              controller: _textController,
              decoration: InputDecoration.collapsed(hintText: "Send a message"),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 4.0),
            child: IconButton(
                icon: Icon(Icons.send),
                onPressed: ()=>onSubmitted(_textController.text),

    ))],
      ),
    );
  }

  onMessageFromBuffer(List<Message> messages){
    _streamController.add(messages);
  }

  onMessageReceive(Message message){
  _buffer.add(message);
  }

  onSubmitted(String text){

    _textController.clear();
    _service.send(Message( text));

  }

  void _addMessages(List<Message> messages) {
    messages.forEach((message) {
      _messages.add(Text(message.text));
    });
  }
}
