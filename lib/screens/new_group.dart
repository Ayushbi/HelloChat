import 'package:demo_app/model/contact_model.dart';
import 'package:demo_app/screens/GroupScreen.dart';
import 'package:demo_app/services/Contact.dart';

import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

class NewGroup extends StatefulWidget {
  const NewGroup({super.key});

  @override
  State<NewGroup> createState() => _NewGroupState();
}

class _NewGroupState extends State<NewGroup> {
  List contacts = [];
  List<ContactModel> register_users = [];
  Set<int> Selected = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getContacts();
    RegisterUser();

  }

  Future<void> getContacts() async {
    try {
      final permission = await FlutterContacts.permissions.request(
        PermissionType.read,
      );

      if (permission != PermissionStatus.granted) {
        if (mounted) {
          setState(() => isLoading = false);
        }
        return;
      }

      final fetchedContacts = await FlutterContacts.getAll(
        properties: {ContactProperty.phone},
      );

      if (!mounted) return;

      setState(() {
        contacts = fetchedContacts;
        isLoading = false;
      });
    } catch (e) {
      print('Error loading contacts: $e');
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }
  Future<void>RegisterUser()async{
    var data= await  ContactService.getRegisteredUsers();
    if (!mounted) return;

    setState(() {
    register_users = data;
    });
  }
  bool is_register(String phone) {
    for (var user in register_users) {
      print('Phone from database API: "${user.phone}"');
    }
    print('Phone from contact: "$phone"');
    final result= register_users.any(
          (user) => user.phone.trim() == phone.trim(),
    );
    print('Is registered: $result');

    return result;


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Group", style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: SafeArea(
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: "Search Contact",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            SizedBox(height: 4),

            Expanded(
              child: Padding(
                padding: EdgeInsets.all(12),
                child: ListView.builder(
                  itemCount: contacts.length,
                  itemBuilder: (context, index) {
                    final phone = contacts[index].phones.isNotEmpty
                        ? contacts[index].phones.first.number
                        : '';
                    final validate = phone.isNotEmpty && is_register(phone);
                    return Card(

                      color: Colors.blueGrey.shade50,
                      child: ListTile(
                        title: Text(contacts[index].displayName ?? 'No name'),
                        subtitle: Text(
                          phone.isEmpty
                              ? 'No phone number'
                              : validate
                              ? phone
                              : 'Not registered',
                        ),
                        trailing: CircleAvatar(
                          child: IconButton(
                            onPressed: () {
                              setState(() {
                                if (Selected.contains(index)) {
                                  Selected.remove(index);
                                } else {
                                  Selected.add(index);
                                }
                              });
                            },
                            icon: Icon(
                              Selected.contains(index)
                                  ? Icons.radio_button_checked_rounded
                                  : Icons.radio_button_off_rounded,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            if (Selected.length != 0)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 150,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      padding: const EdgeInsets.symmetric(vertical: 9),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        "  ${Selected.length} Contact Selected",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.blue.shade700,
                        ),
                      ),
                    ),

                    IconButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(
                            builder: (context)=>Groupscreen()));
                      },
                      icon: const Icon(Icons.arrow_forward_ios_outlined),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
