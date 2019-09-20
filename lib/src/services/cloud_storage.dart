import "dart:io";
import "package:flutter/foundation.dart";
import "package:firebase_storage/firebase_storage.dart";

class CloudStorage {
	static final StorageReference root = FirebaseStorage().ref();

	final Directory dir, publicationDir;
	final String publication;

	CloudStorage({
		@required String path, 
		@required this.publication
	}) : 
		dir = Directory("$path/publications")
			..createSync(recursive: true),
		publicationDir = Directory("$path/publications/$publication")
			..createSync(recursive: true);

	String getPath(String path) => "${dir.path}/$path";

	Future<Map<String, String>> get metadata async => 
		(await root.child("$publication/issues.txt").getMetadata()).customMetadata;

	Future<void> getImage() => root
		.child("$publication/$publication.png")
		.writeToFile(File(imagePath))
		.future;

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

	String get imagePath => getPath("$publication.png");

	void deleteLocal() => dir.deleteSync(recursive: true);
}
