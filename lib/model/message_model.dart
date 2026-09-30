
//fromJson takes Map data, picks keys, and fills constructor variables."
class MessageModel {
  final int id;
  final int sender;
 final String receiver;
 final String time;
 final String text;
 MessageModel({
   required this.id,
   required this.sender,
   required this.receiver,
   required this.time,
   required this.text

});
 factory MessageModel.fromJson(Map<String,dynamic>json){
return MessageModel
  (  id: json['id'],
    sender: json['sender'],
    receiver: json['receiver'].toString(),
    text: json['text'].toString(),
    time: json['time']
);
 }
}