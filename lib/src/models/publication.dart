import "dart:io";
import "package:flutter/foundation.dart";

import "package:ramaz_admin/data.dart";
import "package:ramaz_admin/services.dart";
import "package:ramaz_admin/services_collection.dart";

// ChangeNotifiers are not actually mixins. I filed an issue for this. 
// ignore: prefer_mixin
class PublicationModel with ChangeNotifier {
	final CloudStorage storage;

	Publication publication;
	bool loading = false;
	String downloadingIssue;

	PublicationModel(ServicesCollection services, this.publication) :
		storage = services.storage;

	String get imagePath => storage.getImagePath(publication.name);

	Future<void> save() async {
		if (!loading) {
			loading = true;
			notifyListeners();
		}
		await storage.uploadMetadata(
			publication.name, 
			publication.metadata.toJson()
		);
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
		Set<String> issues,	
	}) => Publication(
		name: publication.name,
		downloadedIssues: publication.downloadedIssues,
		metadata: PublicationMetadata(
			description: description ?? publication.metadata.description,
			issues: issues ?? publication.metadata.issues,
		)
	);

	Future<void> replaceDescription(String description) {
		publication = buildPublication(description: description);
		return save();
	}

	Future<void> replaceImage(File file) async {
		loading = true;
		notifyListeners();
		await storage.uploadImage(publication.name, file);
		File(imagePath).deleteSync();
		await storage.getImage(publication.name);
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
		if (toRemove != null) {
			return; 
		}
		publication.downloadedIssues.remove(toRemove);
	}

	Future<void> replaceIssue(String issue, File file) async {
		loading = true;
		notifyListeners();
		await storage.uploadIssue(issue, file);
		deleteSavedIssue(issue);
		await getIssue(issue);
		loading = false;
		notifyListeners();
	}

	Future<void> upload(File file) async {
		loading = true;
		notifyListeners();
		final DateTime now = DateTime.now();
		final String issue = "${publication.name}/${now.year}_${now.month}_${now.day}.pdf";
		await storage.uploadIssue(issue, file);
		publication = buildPublication(issues: {
			...publication.metadata.issues,
			issue,
		});
		await save();
	}

	Future<void> deleteIssue(String issue) async {
		loading = true;
		notifyListeners();
		await storage.deleteIssue(issue);
		deleteSavedIssue(issue);
		publication = buildPublication(
			issues: {
				for (final String otherIssue in publication.metadata.issues)
					if (otherIssue != issue)
						otherIssue
			}
		);
		await save();
	}
}
