//fromJson takes Map data, picks keys, and fills constructor variables."
import 'package:flutter/material.dart';
class MessageModel {
  final int id;
  final String sender;
  final String receiver;
  final DateTime time;
  final String text;

  MessageModel({
    required this.id,
    required this.sender,
    required this.receiver,
    required this.time,
    required this.text,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {

    return MessageModel(

      id: json['id'],
      sender: json['sender_id'].toString(),
      receiver: json['reciver_id'].toString(),
      text: json['message'].toString(),
      time: DateTime.parse(json['created_at']).toLocal(),
    );
  }
}
