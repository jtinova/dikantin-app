import 'package:dikantin/app/data/providers/services.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:async';

class DetailChatPageKurir extends StatefulWidget {
  final int conversationId;
  final String kantinnn;
  final String idkurirr; // current user id (kurir)

  DetailChatPageKurir({
    required this.conversationId,
    required this.kantinnn,
    required this.idkurirr,
  });

  @override
  _DetailChatPageState createState() => _DetailChatPageState();
}

class _DetailChatPageState extends State<DetailChatPageKurir> {
  List<dynamic> _messages = [];
  String? _token;
  final _messageController = TextEditingController();
  late WebSocketChannel _channel;
  Timer? _pingTimer;
  bool _isLoading = false; // Loading hanya untuk fetching data

  @override
  void initState() {
    super.initState();
    _loadToken();
    _fetchMessages();
    _connectToWebSocket();
  }

  Future<void> _loadToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('tokenkurir');

    if (token != null) {
      setState(() {
        _token = token;
      });
    } else {
      print('Token tidak ditemukan');
    }
  }

  Future<void> _fetchMessages() async {
    setState(() {
      _isLoading = true; // Aktifkan loading hanya saat fetch messages
    });

    try {
      final response = await http.get(
        Uri.parse('${Api.getMessage}${widget.conversationId}'),
        headers: {
          'Authorization': 'Bearer $_token',
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          _messages = jsonDecode(response.body)['data'];
        });
      } else {
        print('Gagal mengambil pesan. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Terjadi kesalahan saat mengambil pesan: $error');
    } finally {
      setState(() {
        _isLoading = false; // Nonaktifkan loading setelah fetch selesai
      });
    }
  }

  void _connectToWebSocket() {
    _channel = WebSocketChannel.connect(
      Uri.parse('${Api.socketUrl}'),
    );

    _channel.sink.add(jsonEncode({
      "event": "pusher:subscribe",
      "data": {
        "channel": "conversation.${widget.conversationId}",
      },
    }));

    _channel.stream.listen((message) {
      final data = jsonDecode(message);

      if (data['event'] == 'message.sent') {
        final msgData = jsonDecode(data['data']);

        if (msgData['id_pengirim'] != widget.idkurirr) { // Ambil dari constructor
          _addMessage(msgData);
        }
      }
    });

    _startPingTimer();
  }

  void _startPingTimer() {
    const pingInterval = Duration(seconds: 15);
    _pingTimer = Timer.periodic(pingInterval, (timer) {
      _sendPing();
    });
  }

  void _sendPing() {
    _channel.sink.add(jsonEncode({
      "event": "ping",
    }));
    print('Ping sent');
  }

  Future<void> _sendMessage() async {
    if (_messageController.text.isEmpty) {
      return;
    }

    final String messageText = _messageController.text;

    try {
      final response = await http.post(
        Uri.parse('${Api.sendMessage}'),
        headers: {
          'Authorization': 'Bearer $_token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'conversation_id': widget.conversationId,
          'id_pengirim': widget.idkurirr, // Ambil dari constructor
          'tipe_pengirim': 'kurir',
          'pesan': messageText,
        }),
      );

      if (response.statusCode == 200) {
        _addMessage({
          'pesan': messageText,
          'id_pengirim': widget.idkurirr, // Ambil dari constructor
          'created_at': DateTime.now().toString(),
        });
        _messageController.clear();
      } else {
        print('Gagal mengirim pesan. Status code: ${response.body}');
      }
    } catch (error) {
      print('Terjadi kesalahan saat mengirim pesan: $error');
    }
  }

  void _addMessage(Map<String, dynamic> msgData) {
    setState(() {
      _messages.insert(0, {
        'pesan': msgData['pesan'],
        'id_pengirim': msgData['id_pengirim'],
        'created_at': msgData['created_at'],
      });
    });
  }

  @override
  void dispose() {
    _pingTimer?.cancel();
    _channel.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Customer ${widget.kantinnn}'),
      ),
      body: Column(
        children: [
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator()) // Loading saat fetch messages
                : _messages.isEmpty
                    ? Center(child: Text('Tidak ada pesan'))
                    : ListView.builder(
                        reverse: true,
                        itemCount: _messages.length,
                        itemBuilder: (context, index) {
                          final message = _messages[index];
                          final isMe = message['id_pengirim'] == widget.idkurirr; // Check dengan idkurirr dari constructor

                          return Align(
                            alignment: isMe
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: Container(
                              margin: EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 10),
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: isMe ? Colors.blue[100] : Colors.grey[300],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                crossAxisAlignment: isMe
                                    ? CrossAxisAlignment.end
                                    : CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    message['pesan'],
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    message['created_at'],
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.black54),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Tulis pesan...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _sendMessage, // Tidak menggunakan loading untuk send message
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
