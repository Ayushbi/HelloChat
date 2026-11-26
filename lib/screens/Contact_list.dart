import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:share_plus/share_plus.dart';

class ContactList extends StatefulWidget {
  const ContactList({super.key});

  @override
  State<ContactList> createState() => _ContactListState();
}

class _ContactListState extends State<ContactList> {
  List<Contact> contacts = [];
  bool Loading = true;
  bool processing=false;

  @override
  void initState() {
    super.initState();
    getContacts();
  }

  Future<void> getContacts() async {
    try {
      final permission = await FlutterContacts.permissions.request(
        PermissionType.read,
      );

      if (permission != PermissionStatus.granted) {
        if (mounted) {
          setState(() => Loading = false);
        }
        return;
      }

      final fetchedContacts = await FlutterContacts.getAll(
        properties: {ContactProperty.phone},
      );

      if (!mounted) return;

      setState(() {
        contacts = fetchedContacts;
        Loading = false;
      });
    } catch (e) {
      debugPrint('Error loading contacts: $e');
      if (mounted) {
        setState(() => Loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Contacts",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(12),
                child: ListView.builder(
                  itemCount: contacts.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: CircleAvatar(
                        child: Icon(Icons.contacts_outlined),
                      ),
                      title: Text(
                        (contacts[index].displayName ?? '').isNotEmpty
                            ? contacts[index].displayName ?? ''
                            : 'No name',
                      ),
                      subtitle: Text(
                        contacts[index].phones.isNotEmpty
                            ? contacts[index].phones.first.number
                            : 'No phone number',
                      ),

                      trailing: processing
                          ? SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      )
                          : Icon(Icons.sim_card),
                      onTap: () async {
                        if (contacts[index].phones.isNotEmpty) {
                          setState(() {
                            processing = true;
                          });
                          await Future.delayed(Duration(seconds: 3),);
                          SharePlus.instance.share(
                            ShareParams(
                              title: "Contact is not registered. Share this app!",
                              text: 'Hey! Try my chat app.',
                            ),

                          );
                          setState(() {
                            processing = false;
                          });
                        } else {}
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
