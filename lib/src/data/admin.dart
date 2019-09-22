import "package:flutter/foundation.dart";

import "times.dart";

enum Scope {calendar, schedule, publications}

const Map<String, Scope> stringToScope = <String, Scope>{
	"calendar": Scope.calendar,
	"schedule": Scope.schedule,
	"publications": Scope.publications,
};

const Map<Scope, String> scopeToString = <Scope, String>{
	Scope.calendar: "calendar",
	Scope.schedule: "schedule",
	Scope.publications: "publications",
};

@immutable
class Admin {
	final String email, name, publication;
	final List<Scope> scopes;
	final List<Special> specials;

	const Admin ({
		@required this.email, 
		@required this.name, 
		@required this.scopes, 
		@required this.specials,
		@required this.publication,
	});

	Admin.fromJson(Map<String, dynamic> json) :
		email = json ["email"],
		name  = json ["name"],
		publication = json ["publication"],
		scopes = <Scope>[
			for (dynamic scope in json ["scopes"])
				stringToScope [scope]
		],
		specials = <Special>[
			for (dynamic special in json ["specials"])
				Special.fromJson (Map<String, dynamic>.from(special))
		];

	Map<String, dynamic> toJson() => <String, dynamic>{
		"email": email,
		"name": name,
		"publication": publication,
		"scopes": <String>[
			for (final Scope scope in scopes)
				scopeToString [scope]
		],
		"specials": <Map<String, dynamic>>[
			for (final Special special in specials)
				special.toJson(),
		]
	};
}
