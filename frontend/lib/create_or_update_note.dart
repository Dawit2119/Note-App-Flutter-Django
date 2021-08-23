import 'package:flutter/material.dart';
import 'package:frontend/main.dart';
import 'package:frontend/widgets/customButton.dart';
import 'package:http/http.dart' as http;

import 'note.dart';

class CreateOrUpdateNote extends StatelessWidget {
  CreateOrUpdateNote({this.note, this.isUpdate = false});
  final _formKey = GlobalKey<FormState>();
  final Note? note;
  final bool isUpdate;
  final bodyTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    if (isUpdate) {
      bodyTextController.text = note!.body;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(isUpdate ? 'Update Note' : 'Create your note'),
      ),
      body: Form(
        key: _formKey,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextFormField(
                validator: (String? valid) {
                  if (valid!.isEmpty) {
                    return "This field shouldn't be empty";
                  } else if (valid.length < 5) {
                    return "body text should be morethan 5 characters";
                  }
                  return null;
                },
                maxLines: 8,
                controller: bodyTextController,
                decoration: InputDecoration(
                  labelText: "body",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  fillColor: Color(0xfff3f3f4),
                  filled: true,
                ),
              ),
              CustomButton(
                onpressed: () async {
                  var form = _formKey.currentState;
                  if (form!.validate()) {
                    var response = isUpdate?
                     await http.put(
                       Uri.parse('http://localhost:8000/api/notes/${note!.id}/update/'),
                       body: {"body":bodyTextController.text},

                     ):
                     await http.post(
                        Uri.parse('http://localhost:8000/api/notes/create/'),
                        body: {"body": bodyTextController.text});
                    if (response.statusCode == 201 || response.statusCode==202) {
                      Navigator.pop(context);
                    } else {
                      print(
                          "Message: ${response.body}\nstatus code ${response.statusCode}");
                    }
                  }
                },
                lableText: "Submit",
                color: Colors.greenAccent,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
