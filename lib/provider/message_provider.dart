import 'package:demo_app/model/message_model.dart';
import 'package:demo_app/services/Message_Api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final message = FutureProvider<List<MessageModel>>((ref) async {
  final user_id = await ref.watch(id.future);
  return messageApi().getmessage(user_id);
});

final id = FutureProvider<String>((ref) async {
  final login_id = await SharedPreferences.getInstance();
  return login_id.getString("id") ?? '';
});

// StateNotifier is to update your stored data
// and notify the UI that new data has arrived.
class live_msg extends StateNotifier<List<MessageModel>> {
  live_msg() : super([]);

  void addmsg(MessageModel message) {
    state = [...state, message];
  }
}

//
// live_msg → the StateNotifier class that manages the state.
// List<MessageModel> → the type of state/data that class manages.
final newMsg = StateNotifierProvider<live_msg, List<MessageModel>>((ref) {
  return live_msg();
});
