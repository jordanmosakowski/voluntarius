import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voluntarius/classes/job.dart';
import 'package:voluntarius/pages/chat.dart';
import 'package:voluntarius/pages/request.dart';
import 'package:voluntarius/widgets/requests_tile.dart';

class JobsPage extends StatefulWidget {
  const JobsPage({Key? key}) : super(key: key);

  @override
  _JobsPageState createState() => _JobsPageState();
}

class _JobsPageState extends State<JobsPage> {
  @override
  Widget build(BuildContext context) {
    List<Job> jobs = Provider.of<List<Job>>(context); //my created
    print(jobs.length);
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
              MaterialPageRoute(builder: (context) => const ChatPage()),
            );
          },
        ),
        for (int i = 0; i < jobs.length; i++) ReqTile(c: 500, j: jobs[i])
        // Expanded(
        //       child: ListView(
        //     padding: const EdgeInsets.all(8),
        //     children: [
        //       for (int i = 0; i < jobs.length; i++)
        //       ReqTile(c: 500, j: jobs[i])
        //     ],
        //   )),
      ]),
    );
  }
}
