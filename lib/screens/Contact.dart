import 'package:demo_app/screens/main_chat.dart';
import 'package:demo_app/screens/setting.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Contacts extends StatefulWidget {
  const Contacts({super.key});

  @override
  State<Contacts> createState() => _ContactsState();
}

class _ContactsState extends State<Contacts> {
  List<String> names = ["ayush", "ankit", "rahul"];
  List<String> Filtername = ["ayush", "ankit", "rahul"];

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
            },

            itemBuilder: (context) => [
              PopupMenuItem(child: Text("Setting"), value: "setting"),
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
                            MaterialPageRoute(builder: (context) => chat_box()),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add,),backgroundColor: Colors.lightBlue.shade300,
      ),
    );
  }
}
