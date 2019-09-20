import "package:flutter/foundation.dart";

import "package:ramaz_admin/data.dart";
import "package:ramaz_admin/services.dart";
import "package:ramaz_admin/services_collection.dart";

// ChangeNotifiers are not actually mixins. I filed an issue for this. 
// ignore: prefer_mixin
class PublicationModel with ChangeNotifier {
	final CloudStorage storage;

	Publication publication;
	bool loading = true;
	String downloadingIssue;

	PublicationModel(ServicesCollection services) :
		storage = services.storage 
	{
		setup();
	}

	Future<void> setup() async {
		publication = Publication(
			name: await Auth.publicationName, 
			// We want to augment the set occasionally
			// ignore: prefer_const_literals_to_create_immutables
			downloadedIssues: <String>{},
			metadata: PublicationMetadata.fromJson(
				Map<String, String>.from(await storage.metadata),
			)
		);
	}

	Future<void> save() async {
		if (!loading) {
			loading = true;
			notifyListeners();
		}
		await storage.uploadMetadata(publication.metadata.toJson());
		loading = false;
		notifyListeners();
	}

	Future<String> getIssue(String issue) async {
		downloadingIssue = issue;
		notifyListeners();
		if (!publication.downloadedIssues.contains(issue)) {
			await storage.getIssue(issue);
		}
		downloadingIssue = null;
		notifyListeners();
		return storage.getPath(issue);
	}

	Publication buildPublication({
		String description,
		String imagePath,
		List<String> issues,	
	}) => Publication(
		name: publication.name,
		downloadedIssues: publication.downloadedIssues,
		metadata: PublicationMetadata(
			description: description ?? publication.metadata.description,
			imagePath: imagePath ?? publication.metadata.imagePath,
			issues: issues ?? publication.metadata.issues,
		)
	);

	Future<void> replaceDescription(String description) {
		publication = buildPublication(description: description);
		return save();
	}

	Future<void> replaceImage(String path) async {
		loading = true;
		notifyListeners();
		await storage.uploadImage(path);
		await save();
		await storage.getImage();
		loading = false;
		notifyListeners();
	}

	void deleteSavedIssue(String issue) {
		String toRemove;
		for (final String issue in publication.downloadedIssues) {
			if (issue.endsWith(issue)) {
				toRemove = issue;
				break;
			}
		}
		assert (
			toRemove != null, 
			"Cannot find $issue to remove. Saved issues: ${publication.downloadedIssues}"
		);
		publication.downloadedIssues.remove(toRemove);
	}

	Future<void> replaceIssue(String issue, String path) async {
		loading = true;
		notifyListeners();
		await storage.uploadIssue(issue, path);
		deleteSavedIssue(issue);
		await getIssue(issue);
		loading = false;
		notifyListeners();
	}

	Future<void> upload(String path) async {
		loading = true;
		notifyListeners();
		final DateTime now = DateTime.now();
		final String issue = "${publication.name}/${now.year}_${now.month}_${now.day}.pdf";
		await storage.uploadIssue(issue, path);
		publication.metadata.issues.add(issue);
		await save();
	}

	Future<void> deleteIssue(String issue) async {
		loading = true;
		notifyListeners();
		await storage.deleteIssue(issue);
		deleteSavedIssue(issue);
		publication.metadata.issues.remove(issue);
		await save();
	}
}
