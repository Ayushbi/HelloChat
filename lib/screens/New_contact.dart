import 'package:flutter/material.dart';

class NewContact extends StatefulWidget {
  const NewContact({super.key});

  @override
  State<NewContact> createState() => _NewContactState();
}

class _NewContactState extends State<NewContact> {
  String Country = "+81";

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
              return [PopupMenuItem(child: Text("Discard"), value: "Discard")];
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
                    child: TextField(
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
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Last name",
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
                  Icon(Icons.phone),
                  SizedBox(width: width*0.02),

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
                        DropdownMenuItem(
                          value: "+81",
                          child: Text("+81"),
                        ),
                        DropdownMenuItem(
                          value: "+1",
                          child: Text("+1"),
                        ),
                        DropdownMenuItem(
                          value: "+44",
                          child: Text("+44"),
                        ),
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
                    child: TextField(
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
                  onPressed: () {},
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
