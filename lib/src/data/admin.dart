import "package:flutter/foundation.dart";

import "times.dart";

enum Scope {calendar, schedule}

const Map<String, Scope> stringToScope = <String, Scope>{
	"calendar": Scope.calendar,
	"schedule": Scope.schedule,
};

const Map<Scope, String> scopeToString = <Scope, String>{
	Scope.calendar: "calendar",
	Scope.schedule: "schedule",
};

@immutable
class Admin {
	final String email, name;
	final List<Scope> scopes;
	final List<Special> specials;

	const Admin ({
		this.email, 
		this.name, 
		this.scopes, 
		this.specials
	});

	Admin.fromJson(Map<String, dynamic> json) :
		email = json ["email"],
		name  = json ["name"],
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
