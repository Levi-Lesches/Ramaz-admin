import "dart:convert";
import "dart:io";

class Reader {
	final File adminFile;

	Reader(String dir) :
		adminFile = File("$dir/admin.json");

	bool get ready => adminFile.existsSync();

	void deleteAll() {
		adminFile.deleteSync();
	}

	Map<String, dynamic> get adminData => jsonDecode(
		adminFile.readAsStringSync()
	);

	set adminData(Map<String, dynamic> json) => adminFile.writeAsStringSync(
		jsonEncode(json)
	);
}
