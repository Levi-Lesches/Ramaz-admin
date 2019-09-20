// ignore_for_file: avoid_classes_with_only_static_members

import "package:cloud_firestore/cloud_firestore.dart" as cloud_firestore;

import "auth.dart";

class Firestore {
	static final cloud_firestore.Firestore firestore = 
		cloud_firestore.Firestore.instance;

	static const String adminsCollectionName = "admin";
	static const String calendarCollectionName = "calendar";

	static final cloud_firestore.CollectionReference admins = 
		firestore.collection(adminsCollectionName);

	static final cloud_firestore.CollectionReference calendar = 
		firestore.collection(calendarCollectionName);


	static Future<Map<String, dynamic>> get admin async => 
		(await admins.document(await Auth.email).get()).data;

	static Future<void> saveAdmin(Map<String, dynamic> json) async => 
		admins.document(await Auth.email).setData(json);

	static Future<void> saveCalendar(int month, Map<String, dynamic> json) =>
		calendar.document(month.toString()).setData(json);

	static Stream<cloud_firestore.DocumentSnapshot> getCalendar(int month) => 
		calendar.document(month.toString()).snapshots();
}
