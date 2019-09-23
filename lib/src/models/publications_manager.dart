import "package:flutter/foundation.dart";

import "package:ramaz_admin/services_collection.dart";
import "package:ramaz_admin/services.dart";

// ignore: prefer_mixin
class PublicationsManager with ChangeNotifier {
	Future<List<String>> publications;

	final CloudStorage storage;

	PublicationsManager(ServicesCollection services) : 
		publications = services.storage.publications,
		storage = services.storage;

	void refresh() {
		publications = storage.publications;
		notifyListeners();
	}
}
