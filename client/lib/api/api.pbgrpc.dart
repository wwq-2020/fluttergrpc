///
//  Generated code. Do not modify.
//  source: api.proto
///
// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import

import 'dart:async' as $async;

import 'package:grpc/grpc.dart';

import 'api.pb.dart';
export 'api.pb.dart';

class ChatClient extends Client {
  static final _$send = new ClientMethod<Message, Empty>(
      '/api.Chat/Send',
      (Message value) => value.writeToBuffer(),
      (List<int> value) => new Empty.fromBuffer(value));
  static final _$subscribe = new ClientMethod<Empty, Message>(
      '/api.Chat/Subscribe',
      (Empty value) => value.writeToBuffer(),
      (List<int> value) => new Message.fromBuffer(value));

  ChatClient(ClientChannel channel, {CallOptions options})
      : super(channel, options: options);

  ResponseFuture<Empty> send(Message request, {CallOptions options}) {
    final call = $createCall(_$send, new $async.Stream.fromIterable([request]),
        options: options);
    return new ResponseFuture(call);
  }

  ResponseStream<Message> subscribe(Empty request, {CallOptions options}) {
    final call = $createCall(
        _$subscribe, new $async.Stream.fromIterable([request]),
        options: options);
    return new ResponseStream(call);
  }
}

abstract class ChatServiceBase extends Service {
  String get $name => 'api.Chat';

  ChatServiceBase() {
    $addMethod(new ServiceMethod<Message, Empty>(
        'Send',
        send_Pre,
        false,
        false,
        (List<int> value) => new Message.fromBuffer(value),
        (Empty value) => value.writeToBuffer()));
    $addMethod(new ServiceMethod<Empty, Message>(
        'Subscribe',
        subscribe_Pre,
        false,
        true,
        (List<int> value) => new Empty.fromBuffer(value),
        (Message value) => value.writeToBuffer()));
  }

  $async.Future<Empty> send_Pre(ServiceCall call, $async.Future request) async {
    return send(call, await request);
  }

  $async.Stream<Message> subscribe_Pre(
      ServiceCall call, $async.Future request) async* {
    yield* subscribe(call, (await request) as Empty);
  }

  $async.Future<Empty> send(ServiceCall call, Message request);
  $async.Stream<Message> subscribe(ServiceCall call, Empty request);
}
