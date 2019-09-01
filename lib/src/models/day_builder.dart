import "package:flutter/foundation.dart" show ChangeNotifier;

import "admin.dart";

import "package:ramaz_admin/data.dart";
import "package:ramaz_admin/services.dart";

class DayBuilderModel with ChangeNotifier {
	final AdminModel admin;
	Letter _letter;
	Special _special;

	DayBuilderModel(this.admin) {
		admin.addListener(notifyListeners);
	}

	@override 
	void dispose() {
		admin.removeListener(notifyListeners);
		super.dispose();
	}

	Letter get letter => _letter;
	set letter (Letter value) {
		_letter = value;
		notifyListeners();
	}

	Special get special => _special;
	set special (Special value) {
		if (value == null) return;
		_special = value;
		if(
			!presetSpecials.any(
				(Special preset) => preset.name == value.name
			) && !userSpecials.any(
				(Special preset) => preset.name == value.name
			)
		) saveSpecial(value);

		notifyListeners();
	}

	void saveSpecial(Special value) {
		userSpecials.add(value);
		Firestore.saveAdmin(admin.admin.toJson());
	}
	
	Day get day => Day (letter, special);
	List<Special> get presetSpecials => Special.specialList;
	List<Special> get userSpecials => admin.admin.specials;

	bool get ready => letter != null && special != null;
}
