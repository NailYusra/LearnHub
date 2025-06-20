import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// Import model dan service yang relevan
import '../models/user_model.dart';
import '../models/tutor_model.dart';
import '../models/chat_message_model.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';
import '../widgets/custom_text_field.dart';

class ChatScreen extends StatefulWidget {
  final Tutor recipientTutor;
  final User currentUser; // Kita butuh info user yang login

  const ChatScreen({
    super.key,
    required this.recipientTutor,
    required this.currentUser,
  });

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ApiService _apiService = ApiService();
  final _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<ChatMessage> _messages = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  Future<void> _loadMessages() async {
    setState(() => _isLoading = true);
    try {
      final allMessages = await _apiService.getChats();
      // Filter pesan yang hanya relevan untuk chat ini
      _messages = allMessages
          .where((msg) =>
      (msg.userId == widget.currentUser.id && msg.tutorId == widget.recipientTutor.id))
          .toList()
        ..sort((a, b) => a.date.compareTo(b.date)); // Urutkan dari yang terlama
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memuat pesan: $e')),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
        _scrollToBottom();
      }
    }
  }

  void _sendMessage() async {
    if (_messageController.text.trim().isEmpty) return;

    final messageText = _messageController.text;
    _messageController.clear();

    try {
      await _apiService.createChat({
        'user_id': widget.currentUser.id,
        'tutor_id': widget.recipientTutor.id,
        'sender_id': widget.currentUser.id, // Pengirim adalah user yang login
        'text': messageText,
      });
      // Muat ulang pesan setelah berhasil mengirim
      _loadMessages();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengirim pesan: $e')),
      );
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.recipientTutor.nama ?? 'Chat'),
      ),
      body: Column(
        children: [
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(8.0),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                // Pesan dianggap "milikku" jika dikirim oleh user yang sedang login
                final isMe = message.senderId == widget.currentUser.id;
                return _buildMessageBubble(message, isMe);
              },
            ),
          ),
          _buildMessageComposer(),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message, bool isMe) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        decoration: BoxDecoration(
            color: isMe ? Theme.of(context).primaryColor : Colors.white,
            borderRadius: isMe
                ? const BorderRadius.only(
              topLeft: Radius.circular(16),
              bottomLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            )
                : const BorderRadius.only(
              topRight: Radius.circular(16),
              bottomRight: Radius.circular(16),
              topLeft: Radius.circular(16),
            ),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 5,
                  offset: Offset(0, 2)
              )
            ]
        ),
        child: Text(
          message.text,
          style: TextStyle(color: isMe ? Colors.white : Colors.black87),
        ),
      ),
    );
  }

  Widget _buildMessageComposer() {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)
          ]
      ),
      child: Row(
        children: [
          Expanded(
            child: CustomTextField(
              controller: _messageController,
              label: 'Ketik pesan...',
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: Icon(Icons.send, color: Theme.of(context).primaryColor),
            onPressed: _sendMessage,
          ),
        ],
      ),
    );
  }
}
