import "dart:io";
import "package:flutter/foundation.dart";
import "package:firebase_storage/firebase_storage.dart";

class CloudStorage {
	static final StorageReference root = FirebaseStorage().ref();

	final Directory dir;
	final String publication;

	CloudStorage({
		@required String path, 
		@required this.publication
	}) : 
		dir = Directory("$path/publications");

	String getPath(String path) => "${dir.path}/$path";

	Future<Map<String, String>> get metadata async => 
		(await root.child(publication).getMetadata()).customMetadata;

	Future<void> getImage() async {
		final File file = File(getPath("$publication.png"));
		if (!file.existsSync()) {
			await root.child("$publication/$publication.png").writeToFile(file).future;
		}
	}

	Future<void> getIssue(String issue) => 
		root.child(issue).writeToFile(File(getPath(issue))).future;

	Future<void> uploadImage(File file) => 
		root.child("$publication/$publication.png").putFile(file).onComplete;

	Future<void> uploadIssue(String issue, File file) => 
		root.child(issue).putFile(file).onComplete;

	Future<void> uploadMetadata(Map<String, String> metadata) =>
		root.child("$publication/issues.txt").updateMetadata(
			StorageMetadata(customMetadata: metadata)
		);

	Future<void> deleteIssue(String issue) => root.child(issue).delete();

	void deleteLocal() => dir.deleteSync(recursive: true);
}
