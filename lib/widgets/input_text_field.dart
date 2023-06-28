import 'package:flutter/material.dart';

class CustomInputFormField extends StatefulWidget{
  const CustomInputFormField({Key? key, required this.controller, required this.label, this.obsecure = false}) : super(key: key);

  final TextEditingController controller;
  final String label;
  final bool obsecure;

  @override
  State<StatefulWidget> createState() => CustomInputFormFieldState();
}


class CustomInputFormFieldState extends State<CustomInputFormField>{


  late bool _passwordVisible;
  

  @override
  void initState() {
    super.initState();
    _passwordVisible = false;
  }

  @override
  Widget build( context){
    return FractionallySizedBox(
    widthFactor: 0.9,
    child: Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: Colors.blueAccent),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: TextFormField(
          obscureText: widget.obsecure && _passwordVisible,
          controller: widget.controller,
          decoration:
              InputDecoration(
                label: Text(widget.label), 
                border: InputBorder.none,
                suffixIcon: widget.obsecure ? IconButton(
                  icon: Icon( _passwordVisible ?
                      Icons.visibility_off : Icons.visibility
                  ),
                  onPressed: (){
                    setState(() {
                      _passwordVisible = !_passwordVisible;
                    });
                  },
                ) : const SizedBox(width: 0.0, height: 0.0),
                ),
        ),
      ),
    ),
  );
  }
}


// Widget CustomInputFormField(TextEditingController controller, String label,
//     {bool obsecure = false}) {
//   return 
// }
