import "package:ramaz_admin/models.dart";
import "package:ramaz_admin/services.dart";

class ServicesCollection {
	final Reader reader;

	AdminModel admin;

	ServicesCollection(this.reader);

	void init() => admin = AdminModel(reader);

	Future<void> login() async {
		reader
			..adminData = await Firestore.admin;
		init();
	}
}
