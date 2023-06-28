import 'package:flutter/material.dart';

class InfoPallet extends StatefulWidget{
  const InfoPallet({super.key});

  @override
  State<StatefulWidget> createState() => InfoPalletState();
}

class InfoPalletState extends State<InfoPallet>{

  @override
  Widget build(BuildContext context){
    return ListTile(
      leading: Icon(Icons.group),
      title: Text('New group'),
    );
  }
}