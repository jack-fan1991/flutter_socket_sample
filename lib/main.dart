import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tv_controller/client.dart';
import 'dart:io';

import 'package:tv_controller/server.dart';

final server = Server();
final client = Client();

void main() {
  runApp(Home());
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          ElevatedButton(
            onPressed: () {
              server.start();
            },
            child: Column(
              children: [
                Text('start socket'),
                BuildWithSocketStream(
                  streamSocket: server.streamSocket.getResponse,
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              // client.send("test");
            },
            child: Column(
              children: [
                Text('connect socket'),
                TextField(
                  onSubmitted: (value) {
                    client.send(value);
                  },
                ),
                BuildWithSocketStream(
                  streamSocket: client.streamSocket.getResponse,
                ),
              ],
            ),
          )
        ],
      ),
    ));
  }
}

class BuildWithSocketStream extends StatelessWidget {
  final Stream<String> streamSocket;
  const BuildWithSocketStream({required this.streamSocket, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder(
        stream: streamSocket,
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          return Container(
            child: Text(snapshot.data ?? "no data"),
          );
        },
      ),
    );
  }
}
