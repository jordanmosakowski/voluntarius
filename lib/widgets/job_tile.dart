import 'package:flutter/material.dart';
import 'package:voluntarius/classes/job.dart';

class JobTile extends StatelessWidget {
  const JobTile({ Key? key,
  required this.c,
  required this.j,
  required this .dist,
   }) : super(key: key);
  final int c;
  final Job j;
  final double dist;
  @override
  Widget build(BuildContext context) {
    
    
    return ListTile(
      tileColor: Colors.green[c],
      title: Text(j.title),
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
    return  AlertDialog(
      title: Text(j.title),
      content:  Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
           Text("Description: "+j.description),
           Text("Hours Required: "+ j.hoursRequired.toString()),
           Text("People Required: "+j.peopleRequired.toString()),
           Text("Appointment Time: "+j.appointmentTime.toString())
        ],
      ),
      actions: [
         TextButton(onPressed: (){
          Navigator.of(context).pop();
        },
         child: const Text("Done")
         )
      ],
    );

  }
}