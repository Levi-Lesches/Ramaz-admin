import "package:flutter/foundation.dart" show ChangeNotifier;

import "package:ramaz_admin/data.dart";
import "package:ramaz_admin/services.dart";

class AdminModel with ChangeNotifier {
	final Reader reader;

	final Admin admin;

	AdminModel(this.reader) :
		admin = Admin.fromJson(reader.adminData);

	void save() {
		Firestore.saveAdmin(admin.toJson());
		reader.adminData = admin.toJson();
	}

	void addSpecial(Special special) {
		if (special == null) return;
		admin.specials.add(special);
		notifyListeners();
		save();
	}

	void replaceSpecial(int index, Special special) {
		if (special == null) return;
		admin.specials [index] = special;
		notifyListeners();
		save();
	}

	void removeSpecial(int index) {
		admin.specials.removeAt(index);
		notifyListeners();
		save();
	}
}
