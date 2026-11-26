import 'package:demo_app/screens/Contact_list.dart';
import 'package:demo_app/screens/New_contact.dart';
import 'package:demo_app/screens/conversations.dart';

import 'package:demo_app/screens/setting.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class users extends StatefulWidget {
  const users({super.key});

  @override
  State<users> createState() => _usersState();
}

class _usersState extends State<users> {
  List<String> names = ["ayush", "ankit", "rahul"];
  List<String> Filtername = ["ayush", "ankit", "rahul"];
  bool isMenuOpen=false;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "Chat_section",
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),

        actions: [
          IconButton(
            onPressed: () async {
              final imagepick = ImagePicker();
              final XFile? image = await imagepick.pickImage(
                source: ImageSource.camera,
              );
              if (image != null) {
                print(image.path);
              }
            },
            icon: Icon(Icons.camera),
          ),
          PopupMenuButton(
            onSelected: (value) {
              if (value == "setting") {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Setting()),
                );
              }
              if (value == "Contacts") {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ContactList()),
                );
              }
            },

            itemBuilder: (context) => [
              PopupMenuItem(child: Text("Setting"), value: "setting"),
              PopupMenuItem(child: Text("Contacts"), value: "Contacts"),
            ],
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Column(
            children: [
              TextField(
                onChanged: (value) {
                  setState(() {
                    Filtername = names.where((name) {
                      return name.toLowerCase().contains(value.toLowerCase());
                    }).toList();
                  });
                },
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  hintText: "Search user",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 2),
                  ),
                ),
              ),
              SizedBox(height: height * 0.03),
              Expanded(
                child: ListView.builder(
                  itemCount: Filtername.length,
                  itemBuilder: (context, index) {
                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      elevation: 1,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),

                        leading: CircleAvatar(
                          radius: 25,
                          backgroundImage: AssetImage("assets/main_logo.jpg"),
                        ),

                        title: Text(
                          Filtername[index],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),

                        subtitle: const Text(
                          "Last message 2 hr ago",
                          style: TextStyle(color: Colors.grey),
                        ),

                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "5:25 PM",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 5),
                            CircleAvatar(
                              radius: 10,
                              backgroundColor: Colors.green,
                              child: Text(
                                "${index + 1}",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          ],
                        ),

                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Conversations()),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [

          if (isMenuOpen) ...[
            FloatingActionButton.small(
              onPressed: () {
                setState(() {
                  isMenuOpen = false;
                });
                // Navigate to NewGroup
              },
              child: Icon(Icons.group_add),
            ),

            SizedBox(height: 12),

            FloatingActionButton.small(
              onPressed: () {
                setState(() {
                  isMenuOpen = false;
                });

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NewContact(),
                  ),
                );
              },
              child: Icon(Icons.person_add),
            ),

            SizedBox(height: 12),
          ],

          FloatingActionButton(
            onPressed: () {
              setState(() {
                isMenuOpen = !isMenuOpen;
              });
            },
            child: AnimatedRotation(
              turns: isMenuOpen ? 0.125 : 0,
              duration: Duration(milliseconds: 250),
              child: Icon(Icons.add),
            ),
            backgroundColor: Colors.lightBlue.shade300,
          ),
        ],
      ),
    );
  }
}
