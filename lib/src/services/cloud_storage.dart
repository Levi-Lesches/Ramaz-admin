import "dart:io";
import "dart:typed_data" show Uint8List;
import "package:flutter/foundation.dart";
import "package:firebase_storage/firebase_storage.dart";

class CloudStorage {
	static final StorageReference root = FirebaseStorage().ref();

	final Directory dir;

	CloudStorage({
		@required String path, 
	}) : 
		dir = Directory("$path/publications")
			..createSync(recursive: true);

	String getPath(String path) => "${dir.path}/$path";

	Future<List<String>> get publications async => 
		(await root.child("issues.txt").getMetadata())
		.customMetadata ["names"].split(", ");

	Future<Map<String, String>> getMetadata(String publication) async {
		final Directory publicationDir = Directory(getPath(publication));
		if (!publicationDir.existsSync()) {
			publicationDir.createSync(recursive: true);
		}
		await getImage(publication);
		return (await root.child("$publication/issues.txt").getMetadata()).customMetadata;
	}

	Future<void> createPublication(String publication) async {
		final List<String> publicationsList = await publications;
		if (publicationsList.contains(publication)) {
			return;  // no further work needed
		}
		await root.child("issues.txt").updateMetadata(
			StorageMetadata(
				customMetadata: {
					"names": [
						...await publications,
						publication
					].join(", ")
				}
			)
		);
		final String metadataPath = "$publication/issues.txt";
		await root
			.child(metadataPath)
			.putData(Uint8List.fromList([]))
			.onComplete;
	}

	Future<void> getImage(String publication) => root
		.child("$publication/$publication.png")
		.writeToFile(File(getImagePath(publication)))
		.future;

	Future<void> getIssue(String issue) => 
		root.child(issue).writeToFile(File(getPath(issue))).future;

	Future<void> uploadImage(String publication, File file) => 
		root.child("$publication/$publication.png").putFile(file).onComplete;

	Future<void> uploadIssue(String issue, File file) => 
		root.child(issue).putFile(file).onComplete;

	Future<void> uploadMetadata(
		String publication, 
		Map<String, String> metadata
	) => root.child("$publication/issues.txt").updateMetadata(
		StorageMetadata(customMetadata: metadata)
	);

	Future<void> deleteIssue(String issue) => root.child(issue).delete();

	String getImagePath(String publication) => getPath("$publication/$publication.png");

	void deleteLocal() => dir.deleteSync(recursive: true);
}
