import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      const Flexible(child: FractionallySizedBox(heightFactor: 0.05)),
      Container(
        width: 100,
        height: 100,
        //color: Colors.green,

        decoration: BoxDecoration(
          color: Colors.amber,
          shape: BoxShape.circle,
          // borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
            //mainAxisAlignment: MainAxisAlignment.center,
            //crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              //Container(height: 75, width:100, color: Colors.red),

              IconButton(
                  icon: const Icon(Icons.add, size: 50.0),
                  padding: const EdgeInsets.all(0),
                  onPressed: () {}),
              IconButton(
                  icon: const Icon(Icons.person_outline, size: 50.0),
                  padding: const EdgeInsets.all(0),
                  onPressed: () {}),
            ]),
      ),
      const Flexible(child: FractionallySizedBox(heightFactor: 0.05)),
      const Flexible(
          child: FractionallySizedBox(
              widthFactor: 0.7,
              child:
                  TextField(decoration: InputDecoration(label: Text('Name'))))),
      //const TextField(decoration: InputDecoration(label: Text('Name'))),
      const Flexible(child: FractionallySizedBox(heightFactor: 0.05)),
      //const TextField(decoration: InputDecoration(label: Text('Email Id'))),
      const Flexible(
          child: FractionallySizedBox(
              widthFactor: 0.7,
              child: TextField(
                  decoration: InputDecoration(label: Text('Email Id'))))),
    ]);
  }
}
