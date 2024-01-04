import 'dart:io';

import 'package:tv_controller/socket_stream.dart';

class Client {
  final StreamSocket streamSocket = StreamSocket();
  int port = 8080;
  Socket? socket;
  Future<void> start({
    String address = "192.168.227.24",
  }) async {
    try {
      // Connect to the server
      socket = await Socket.connect(address, port);

      print('Connected to server at $socket');

      // Handle communication with the server
      handleCommunication(socket!);
    } catch (e) {
      print('Error connecting to the server: $e');
    }
  }

  Future<void> send(msg) async {
    if (socket == null) {
      await start();
    }
    assert(socket != null);
    if (socket != null) {
      socket!.write(msg);
    }
  }

  void handleCommunication(Socket socket) {
    print(
        "Client connected from: ${socket.remoteAddress.address}:${socket.remotePort}");

    // 監聽客戶端發送的資料
    socket.listen(
      (List<int> data) {
        String message = String.fromCharCodes(data);
        print(
            "Received from ${socket.remoteAddress.address}:${socket.remotePort}: $message");
        // 在這裡處理接收到的資料
        streamSocket.addResponse("Received from server $message ");
        socket.write("Hello, client! data $message");
      },
      onDone: () {
        // 客戶端斷開連線時的處理
        print(
            "Client disconnected: ${socket.remoteAddress.address}:${socket.remotePort}");
        socket.close();
      },
      onError: (error) {
        // 處理錯誤
        print(
            "Error with client: ${socket.remoteAddress.address}:${socket.remotePort}, Error: $error");
        socket.close();
      },
      cancelOnError: true,
    );
  }
}
