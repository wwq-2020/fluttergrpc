import 'package:flutter/material.dart';
import "../api/api.pbgrpc.dart" as api;
import "package:grpc/grpc.dart";
import "chatmessage.dart";

class ChatService {
  ClientChannel _client;
  static String host = "127.0.0.1";
  static int port = 8081;
  void Function(Message) onMessageReceive;

  ChatService(this.onMessageReceive){
    _client= ClientChannel(host,port:port, options: ChannelOptions(credentials: ChannelCredentials.insecure()));
  }
  void send(Message message){
    var req = api.Message();
    req.text= message.text;
    api.ChatClient(_client).send(req).catchError((err){
    });
  }


  void subscribe() {
    var stream = api.ChatClient(_client).subscribe(api.Empty());
    stream.forEach(( api.Message message){
      onMessageReceive(Message(message.text));

    }).then((_){
      throw Exception("stream has been closed");
    }).catchError((err){
    });
  }


  void shutdown() {
    _client.shutdown();
  }

}
