import 'dart:io';
import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:newsapp/DataBaseServices.dart';
import 'package:newsapp/dataModel.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  GlobalKey<FormState> _formkey = GlobalKey();
  String title;
  String description;
  var image;
  DatabaseService databaseService = DatabaseService();
  DateTime now = DateTime.now();
  TextEditingController titleTextController = TextEditingController();
  TextEditingController descriptionTextController = TextEditingController();
  List tags = ['TECH', 'BUSSINESS', 'STARTUP', 'NEW ARRIVAL'];
  String tag;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text("Admin app"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Form(
            key: _formkey,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(20.0),
                  child: TextFormField(
                    controller: titleTextController,
                    decoration: InputDecoration(
                      hintText: "Enter tile",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        )
                    ),
                    onChanged: (val){
                      setState(() {
                        title = val;
                      });
                    },
                    validator: (val) => val.isEmpty ? "Enter Title" : null,
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Padding(
                  padding: EdgeInsets.all(20.0),
                  child: TextFormField(
                    controller: descriptionTextController,
                    decoration: InputDecoration(
                      hintText: "Enter description",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      )
                    ),
                    onChanged: (val){
                      setState(() {
                        description = val;
                      });
                    },
                    validator: (val) => val.isEmpty ? "Enter Description" : null,
                  ),
                ),
                SizedBox(
                  height: 30.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    RaisedButton(
                        child: Text("Pick Image"),
                        onPressed: (){
                          if(_formkey.currentState.validate()){
                            pickImage();
                          }
                        }
                    ),
                    DropdownButton(
                      value: tag,
                      items: tags.map(
                        (item) {
                          return DropdownMenuItem(
                            child: Text("$item"),
                            value: item.toString(),
                          );
                        }
                      ).toList(),
                      onChanged: (val){
                        setState(() {
                          tag = val;
                        });
                      }
                    )
                  ],
                ),
                SizedBox(
                  height: 15.0,
                ),
                Container(
                  height: 150.0,
                  width: 100.0,
                  child: image == null
                    ? Placeholder(fallbackHeight: 100.0,fallbackWidth: 100.0,)
                    : Image(image: FileImage(image),),
                )
              ],
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.send),
        onPressed: (){
          databaseService.addData(InputModel(
            title: title,
            description: description,
            date: "${now.day}/${now.month}/${now.year}",
            day: DateFormat('EEEE').format(now),
            tag: tag,
            time: Timestamp.now(),
            timePostedHours: now.hour,
            timePostedMinutes: now.minute
          ), image);
          setState(() {
            titleTextController.clear();
            descriptionTextController.clear();
            image = null;
          });
        },
      ),
    );
  }

  pickImage() async{
    var file;
    await Permission.photos.request();

    if(await Permission.photos.isGranted){
      final imagePicker = ImagePicker();
      PickedFile pickedImage = await imagePicker.getImage(source: ImageSource.gallery);
      file = File(pickedImage.path);
    }
    setState(() {
      image = file;
    });
  }
}
