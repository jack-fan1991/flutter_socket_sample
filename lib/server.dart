import 'dart:io';

import 'package:tv_controller/socket_stream.dart';

class Server {
  final StreamSocket streamSocket = StreamSocket();
  int port = 8080;
  Future<void> start() async {
    var serverSocket = await ServerSocket.bind(InternetAddress.anyIPv4, port);
    print(
        "Server running on IP: ${serverSocket.address} Port: ${serverSocket.port}");

    streamSocket.addResponse(
        "Server running on IP: ${serverSocket.address} Port: ${serverSocket.port}");
    await for (var socket in serverSocket) {
      handleClient(socket);
    }
  }

  void handleClient(Socket socket) {
    print(
        "Client connected from: ${socket.remoteAddress.address}:${socket.remotePort}");
    // 監聽客戶端發送的資料
    socket.listen(
      (List<int> data) {
        String message = String.fromCharCodes(data);
        print(
            "Received from ${socket.remoteAddress.address}:${socket.remotePort}: $message");

        // 在這裡處理接收到的資料
        streamSocket.addResponse(
            "Received from ${socket.remoteAddress.address}:${socket.remotePort}: $message");
        // 例如，回傳一個訊息給客戶端

        socket.write("Hello, client!");
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
