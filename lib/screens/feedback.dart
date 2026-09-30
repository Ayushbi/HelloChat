import 'package:flutter/material.dart';

class feedback extends StatefulWidget {
  const feedback({super.key});

  @override
  State<feedback> createState() => _feedbackState();
}

class _feedbackState extends State<feedback> {
  int rating = 0;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text("Feedback", style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Center(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ShaderMask(
                  shaderCallback: (bounds) {
                    return LinearGradient(
                      colors: [Colors.lightBlue, Colors.blue.shade900],
                    ).createShader(bounds);
                  },
                  child: Text(
                    "Rate Our App",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Image.asset("assets/main_logo.jpg", width: 30, height: 30),
              ],
            ),
            SizedBox(height: height * 0.03),
            Center(
              child: Text(
                "How was you experience",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                ),
              ),
            ),
            SizedBox(height: height * 0.05),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ...List.generate(5, (index) {
                  return IconButton(
                    onPressed: () {
                      setState(() {
                        rating = index + 1;
                      });
                    },
                    icon: Icon(
                      Icons.star,
                      color: index < rating
                          ? Colors.amber
                          : Colors.grey.shade900,
                    ),
                  );
                }),
              ],
            ),
            SizedBox(height: height * 0.05),
            Text(
              "How can we improve",
              style: TextStyle(
                color: Colors.black,
                fontSize: 23,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: height * 0.01),
            Container(
              height: 250,
              child: Padding(
                padding: EdgeInsets.all(12),
                child: TextField(
                  maxLines: null,
                  expands: true,
                  textAlignVertical: TextAlignVertical.top,
                  decoration: InputDecoration(
                    helper: Text("Enter you feedback here"),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: height * 0.01),
            Container(
              width: 250,
              child: ElevatedButton(
                onPressed: () {},
                child: Text("Submit", style: TextStyle(color: Colors.black)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightBlue,
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.all(12),
              child: Text(
                "Don't include personal information like your name, address, or phone number.",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
