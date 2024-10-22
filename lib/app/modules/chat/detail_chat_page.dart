import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DetailChatPage extends StatefulWidget {
  final int conversationId;

  DetailChatPage({required this.conversationId});

  @override
  _DetailChatPageState createState() => _DetailChatPageState();
}

class _DetailChatPageState extends State<DetailChatPage> {
  List<Message> messages = [];
  bool isLoading = true;
  String currentUserId = "CUST98273"; // ID user yang sedang login
  TextEditingController messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchMessages();
  }

  Future<void> fetchMessages() async {
    final response = await http.get(Uri.parse('http://10.10.179.170:8000/api/getallmessage/${widget.conversationId}'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['Message'] == 'Success') {
        setState(() {
          messages = (data['data'] as List).map((message) => Message.fromJson(message)).toList();
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat'),
      ),
      body: Column(
        children: [
          Expanded(
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : messages.isEmpty
                    ? Center(
                        child: Text(
                          'Tidak ada pesan',
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                      )
                    : ListView.builder(
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          final message = messages[index];
                          bool isSender = message.idPengirim == currentUserId;
                          return Align(
                            alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
                            child: Container(
                              margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: isSender ? Colors.blue[100] : Colors.grey[300],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                crossAxisAlignment: isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    message.pesan,
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    message.createdAt,
                                    style: TextStyle(fontSize: 12, color: Colors.grey),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
          ),
          // Form untuk mengirim pesan
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: InputDecoration(
                      hintText: 'Tulis pesan...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    // Proses kirim pesan akan ditambahkan di sini
                    // Saat ini hanya tampilan saja
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Message {
  final int id;
  final int conversationId;
  final String idPengirim;
  final String tipePengirim;
  final String pesan;
  final String createdAt;

  Message({
    required this.id,
    required this.conversationId,
    required this.idPengirim,
    required this.tipePengirim,
    required this.pesan,
    required this.createdAt,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      conversationId: json['conversation_id'],
      idPengirim: json['id_pengirim'],
      tipePengirim: json['tipe_pengirim'],
      pesan: json['pesan'],
      createdAt: json['created_at'],
    );
  }
}
