import "package:flutter/material.dart";

import "package:ramaz_admin/services.dart";
import "package:ramaz_admin/models.dart";
import "package:ramaz_admin/services_collection.dart";

class Services extends InheritedWidget {
	static Services of(BuildContext context) => 
		context.inheritFromWidgetOfExactType(Services);

	final Reader reader;
	final ServicesCollection services;

	Services({@required this.services, @required Widget child}) : 
		reader = services.reader,
		super (child: child);

	AdminModel get admin => services.admin;

	@override
	bool updateShouldNotify(_) => false;
}
