import 'package:flutter/material.dart';

class JobTile extends StatelessWidget {
  const JobTile({ Key? key,
  required this.c,
  required this.Job,
  required this.dist,
  required this.desc,
   }) : super(key: key);
  final int c;
  final String Job;
  final int dist;
  final String desc;
  @override
  Widget build(BuildContext context) {
    
    
    return ListTile(
      tileColor: Colors.green[c],
      title: Text(Job),
      subtitle: Text("Distance: "+dist.toString()),
      trailing: ElevatedButton(
        
        onPressed: (){
          showDialog(context: context,
           builder: (BuildContext)=> _buildPopupDialog(context),);
        },
         
        child: Text("More Info") 
      ),
    );
  }
  Widget _buildPopupDialog(BuildContext context){
    return new AlertDialog(
      title: Text(Job),
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
           Text(desc),
        ],
      ),
      actions: [
        new TextButton(onPressed: (){
          Navigator.of(context).pop();
        },
         child: const Text("Done")
         )
      ],
    );

  }
}