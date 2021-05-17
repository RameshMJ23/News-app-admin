import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class InputModel {
  String title;
  String description;
  String date;
  String day;
  String imageUrl;
  String tag;
  Timestamp time;
  int timePostedHours;
  int timePostedMinutes;

  InputModel(
      {this.title,
      this.description,
      this.date,
      this.imageUrl,
      this.day,
      this.tag,
      this.time,
      this.timePostedHours,
      this.timePostedMinutes});
}
