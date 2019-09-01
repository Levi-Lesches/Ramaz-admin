import "package:flutter/material.dart";
import "package:path_provider/path_provider.dart";

import "package:ramaz_admin/constants.dart";
import "package:ramaz_admin/pages.dart";
import "package:ramaz_admin/widgets.dart";
import "package:ramaz_admin/services.dart";
import "package:ramaz_admin/services_collection.dart";

const Color BLUE = Color(0xFF004B8D);  // (255, 0, 75, 140);
const Color GOLD = Color(0xFFF9CA15);
const Color BLUE_LIGHT = Color(0XFF4A76BE);
const Color BLUE_DARK = Color (0xFF00245F);
const Color GOLD_DARK = Color (0XFFC19A00);
const Color GOLD_LIGHT = Color (0XFFFFFD56);

void main({bool restart = false}) async {
	final String dir = (await getApplicationDocumentsDirectory()).path;
	final Reader reader = Reader(dir);
	if (restart) {
		await Auth.signOut();
		reader.deleteAll();
	}
	final bool ready = reader.ready && await Auth.ready;
	final ServicesCollection services = ServicesCollection(reader);
	try {
		if (ready) services.init();
	} catch (e) {
		if (!restart) 
			main(restart: true);
	}
	runApp(AdminConsole(services, ready));
}

class AdminConsole extends StatelessWidget {
	final ServicesCollection services;
	final bool ready;

	const AdminConsole(this.services, this.ready);

	@override
	Widget build(BuildContext context) => Services(
		services: services,
		child: MaterialApp(
			theme: ThemeData(
				brightness: Brightness.light,
				primarySwatch: Colors.blue,
				primaryColor: BLUE,
				primaryColorBrightness: Brightness.dark,
				primaryColorLight: BLUE_LIGHT,
				primaryColorDark: BLUE_DARK,
				accentColor: GOLD,
				accentColorBrightness: Brightness.light,
				cursorColor: BLUE_LIGHT,
				textSelectionHandleColor: BLUE_LIGHT,
				buttonColor: GOLD,
				buttonTheme: ButtonThemeData (
					buttonColor: GOLD,
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
			}
		)
	);
}

