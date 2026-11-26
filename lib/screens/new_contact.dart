import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

class NewContact extends StatefulWidget {
  const NewContact({super.key});

  @override
  State<NewContact> createState() => _NewContactState();
}

class _NewContactState extends State<NewContact> {
  String Country = "+81";
  TextEditingController name = TextEditingController();

  TextEditingController lastname = TextEditingController();
  TextEditingController PhoneNumber = TextEditingController();

  Future<bool> SaveContact(String Names, String? last, String phone) async {
    try {
      final permission = await FlutterContacts.permissions.request(
        PermissionType.write,
      );

      if (permission != PermissionStatus.granted) {
        print('Contacts permission not granted');
        return false;
      }

      final newContact = Contact(
        name: Name(first: Names, last: (last ?? '').isNotEmpty ? last! : ''),
        phones: [Phone(number: phone)],
      );

      final id = await FlutterContacts.create(newContact);

      return true;
    } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("$e"))
    );
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(

      appBar: AppBar(
        title: Text(
          "Add Contact",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          PopupMenuButton(
            onSelected: (value) {
              if (value == "Discard") {
                Navigator.pop(context);
              }
            },
            itemBuilder: (context) {
              return [
                PopupMenuItem(child: Text("Discard"), value: "Discard"),
                PopupMenuItem(child: Text("Contacts"), value: "Contacts"),
              ];
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(30),
          child: Column(
            children: [
              Row(
                children: [
                  Icon(Icons.person),
                  SizedBox(width: 8),
                  Expanded(
                    child: TextFormField(
                      controller: name,
                      decoration: InputDecoration(
                        hintText: "Name",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: height * 0.02),

              Row(
                children: [
                  Icon(Icons.person),
                  SizedBox(width: 8),
                  Expanded(
                    child: TextFormField(
                      controller: lastname,
                      decoration: InputDecoration(
                        hintText: "Last name",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: height * 0.02),

              Row(
                children: [
                  Icon(Icons.phone),
                  SizedBox(width: width * 0.02),

                  Expanded(
                    flex: 2,
                    child: DropdownButtonFormField<String>(
                      initialValue: Country,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),

                      items: const [
                        DropdownMenuItem(value: "+81", child: Text("+81")),
                        DropdownMenuItem(value: "+1", child: Text("+1")),
                        DropdownMenuItem(value: "+44", child: Text("+44")),
                        DropdownMenuItem(value: "+91", child: Text("+91")),
                      ],
                      onChanged: (value) {
                        setState(() {
                          Country = value!;
                        });
                      },
                    ),
                  ),

                  SizedBox(width: 7),

                  Expanded(
                    flex: 3,
                    child: TextFormField(
                      controller: PhoneNumber,
                      maxLength: 10,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        counterText: "",
                        hintText: "Contact",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: height * 0.07),
              Container(
                width: width * 0.7,
                child: FloatingActionButton(
                  onPressed: () async {
                    final success = await SaveContact(
                      name.text,
                      lastname.text,
                      PhoneNumber.text,
                    );

                    if (success) {
                      name.clear();
                      lastname.clear();
                      PhoneNumber.clear();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Contact Saved"),
                          duration: Duration(seconds: 1),
                        ),
                      );
                    }
                  },
                  child: Text("Save"),
                  backgroundColor: Colors.blue.shade700,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
