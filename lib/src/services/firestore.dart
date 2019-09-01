import "package:cloud_firestore/cloud_firestore.dart" as FB;

import "auth.dart";

class Firestore {
	static final FB.Firestore firestore = FB.Firestore.instance;

	static const String ADMINS = "admin";
	static const String CALENDAR = "calendar";

	static final FB.CollectionReference admins = firestore.collection(ADMINS);
	static final FB.CollectionReference calendar = firestore.collection(CALENDAR);


	static Future<Map<String, dynamic>> get admin async => 
		(await admins.document(await Auth.email).get()).data;

	static Future<void> saveAdmin(Map<String, dynamic> json) async => 
		(await admins.document(await Auth.email).setData(json));

	static Future<void> saveCalendar(int month, Map<String, dynamic> json) async =>
		(await calendar.document(month.toString()).setData(json));

	static Stream<FB.DocumentSnapshot> getCalendar(int month) => 
		calendar.document(month.toString()).snapshots();
}
