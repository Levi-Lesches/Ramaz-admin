import "package:ramaz_admin/models.dart";
import "package:ramaz_admin/services.dart";

class ServicesCollection {
	final Reader reader;
	final String path;

	AdminModel admin;
	CloudStorage storage;

	ServicesCollection(this.path, this.reader);

	Future<void> init() async {
		admin = AdminModel(reader);
		storage = CloudStorage(
			path: path, 
		);
	}

	Future<void> login() async {
		reader.adminData = await Firestore.admin;
		await init();
	}
}
