import 'package:flutter/material.dart';
import 'package:voluntarius/pages/chat.dart';
import 'package:voluntarius/pages/request.dart';

class JobsPage extends StatefulWidget {
  const JobsPage({Key? key}) : super(key: key);

  @override
  _JobsPageState createState() => _JobsPageState();
}

class _JobsPageState extends State<JobsPage> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView(children: [
        ElevatedButton(
          child: const Text("Make new request"),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const RequestPage()),
            );
          },
        ),
        Divider(),
        ElevatedButton(
          child: const Text("Chat"),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ChatPage("test1")),
            );
          },
        ),
      ]),
    );
  }
}
