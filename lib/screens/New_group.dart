import 'package:flutter/material.dart';

class NewGroup extends StatefulWidget {
  const NewGroup({super.key});

  @override
  State<NewGroup> createState() => _NewGroupState();
}

class _NewGroupState extends State<NewGroup> {
  List names = [
    {"id": 1, "name": "ayush"},
    {"id": 2, "name": "aman"},
    {"id": 3, "name": "anuj"},
    {"id": 4, "name": "anujj"},
    {"id": 1, "name": "ayush"},
    {"id": 2, "name": "aman"},
    {"id": 3, "name": "anuj"},
    {"id": 4, "name": "anujj"},

  ];
  bool select = false;
  Set Selected = {};
  List FilterList = [];
  @override
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FilterList = names;
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
              onChanged: (values) {
                setState(() {
                  FilterList = names.where((contact) {
                    return contact["name"].toLowerCase().contains(
                      values.toLowerCase(),
                    );
                  }).toList();
                });
              },
              decoration: InputDecoration(
                hintText: "Search Contact",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            SizedBox(height: 4),

            Expanded(
              child: ListView.builder(
                itemCount: FilterList.length,
                itemBuilder: (context, index) {
                  return Card(
                    color: Colors.white70,
                    child: ListTile(
                      title: Text(FilterList[index]["name"]),
                      subtitle: Text(FilterList[index]["id"].toString()),
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
                          icon: Selected.contains(index)
                              ? Icon(Icons.radio_button_checked_rounded)
                              : Icon(Icons.radio_button_off_rounded),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            if(Selected.length!=0)
            Center(
              child: Container(
                width: 150,
                margin: const EdgeInsets.symmetric(vertical: 8),
                padding: const EdgeInsets.symmetric(
                  vertical: 9,
                ),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(10),
                ),
                child:
                Text(
                  "  ${Selected.length} Contact Selected",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.blue.shade700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
