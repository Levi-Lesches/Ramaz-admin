import "package:flutter/material.dart";
import "package:path_provider/path_provider.dart";

import "package:ramaz_admin/constants.dart";
import "package:ramaz_admin/pages.dart";
import "package:ramaz_admin/widgets.dart";
import "package:ramaz_admin/services.dart";
import "package:ramaz_admin/services_collection.dart";

Future<void> main({bool restart = false}) async {
	final String dir = (await getApplicationDocumentsDirectory()).path;
	final Reader reader = Reader(dir);
	if (restart) {
		await Auth.signOut();
		reader.deleteAll();
	}
	final bool ready = reader.ready && await Auth.ready;
	final ServicesCollection services = ServicesCollection(dir, reader);
	try {
		if (ready) {
			await services.init();
		}
	} on Exception {
		if (!restart) {
			return main(restart: true);
		}
	}
	runApp(AdminConsole(services, ready: ready));
}

class AdminConsole extends StatelessWidget {
	final ServicesCollection services;
	final bool ready;

	const AdminConsole(this.services, {@required this.ready});

	@override
	Widget build(BuildContext context) => Services(
		services: services,
		child: MaterialApp(
			theme: ThemeData(
				brightness: Brightness.light,
				primarySwatch: Colors.blue,
				primaryColor: RamazColors.blue,
				primaryColorBrightness: Brightness.dark,
				primaryColorLight: RamazColors.blueLight,
				primaryColorDark: RamazColors.blueDark,
				accentColor: RamazColors.gold,
				accentColorBrightness: Brightness.light,
				cursorColor: RamazColors.blueLight,
				textSelectionHandleColor: RamazColors.blueLight,
				buttonColor: RamazColors.gold,
				buttonTheme: const ButtonThemeData (
					buttonColor: RamazColors.gold,
					textTheme: ButtonTextTheme.normal,
				),
			),
			home: ready ? HomePage() : LoginPage(),
			routes: {
				Routes.calendar: (_) => CalendarPage(),
				Routes.schedule: (_) => SchedulePage(),
				Routes.login: (_) => LoginPage(),
				Routes.home: (_) => HomePage(),
				Routes.specials: (_) => SpecialPage(),
				Routes.publications: (_) => PublicationsPage(),
			}
		)
	);
}

