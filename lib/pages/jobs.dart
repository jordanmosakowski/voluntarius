import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voluntarius/classes/claim.dart';
import 'package:voluntarius/classes/job.dart';
import 'package:voluntarius/pages/chat.dart';
import 'package:voluntarius/pages/request.dart';
import 'package:voluntarius/widgets/requests_tile.dart';

import '../widgets/claimed_tile.dart';

class JobsPage extends StatefulWidget {
  const JobsPage({Key? key}) : super(key: key);

  @override
  _JobsPageState createState() => _JobsPageState();
}

class _JobsPageState extends State<JobsPage> {
  @override
  Widget build(BuildContext context) {
    List<Job> jobs = Provider.of<List<Job>>(context); 
    List<Claim> claims = Provider.of<List<Claim>>(context);
    for(Claim c in claims){
      if(c.job==null){
        c.getJob().then((a) => setState(() {}));
      }
    }
    print("Claims: ${claims.length}");
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
              MaterialPageRoute(builder: (context) => const ChatPage("test1")),
            );
          },
        ),
        const Divider(),
        const Center(child: Text("My Requested Jobs", style: TextStyle(fontWeight: FontWeight.bold,fontSize: 30))),
        for (int i = 0; i < jobs.length; i++) 
          ReqTile(c: 100, j: jobs[i]),
        const Divider(),
        const Center(child: Text("My Claimed Jobs", style: TextStyle(fontWeight: FontWeight.bold,fontSize: 30))),

        for (int i = 0; i < claims.length; i++)
          if(claims[i].job!=null)
            ClmTile(c: 100, j: claims[i].job!),
        

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
