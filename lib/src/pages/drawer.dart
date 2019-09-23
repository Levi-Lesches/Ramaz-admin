import "package:flutter/material.dart";

import "package:ramaz_admin/constants.dart";
import "package:ramaz_admin/data.dart";
import "package:ramaz_admin/services.dart";
import "package:ramaz_admin/widgets.dart";

class NavDrawer extends StatelessWidget {
	static VoidCallback pushRoute(BuildContext context, String route) => 
		() => Navigator.of(context).pushReplacementNamed(route);

	@override
	Widget build(BuildContext context) {
		final Admin admin = Services.of(context).admin.admin;
		return Drawer (
			child: ListView(
				children: [
					UserAccountsDrawerHeader(
						accountEmail: Text (admin.email),
						accountName: Text (admin.name),
						currentAccountPicture: CircleAvatar(
							child: Text (admin.name [0], textScaleFactor: 2)
						)
					),
					const SizedBox(height: 20),
					const Divider(),
					const SizedBox(height: 20),
					if (admin.scopes.contains(Scope.calendar)) ...[
						ListTile(
							title: const Text ("Edit calendar"),
							leading: Icon (Icons.today),
							onTap: pushRoute(context, Routes.calendar),
						),
						ListTile(
							title: const Text ("Manage custom schedules"),
							leading: Icon(Icons.schedule),
							onTap: pushRoute(context, Routes.specials),
						)
					],

					if (admin.scopes.contains(Scope.schedule))
						ListTile(
							title: const Text ("Edit student schedules"),
							leading: Icon (Icons.account_circle),
							onTap: pushRoute(context, Routes.schedule),
						),

					// if (admin.publication != null)
					// 	ListTile(
					// 		title: const Text("Manage publication"),
					// 		leading: Icon(Icons.new_releases),
					// 		onTap: () => Navigator.of(context).pushReplacement(
					// 			MaterialPageRoute(
					// 				builder: (_) => PublicationPage(admin.publication)
					// 			)
					// 		),
					// 	)
					/*else*/ if (admin.scopes.contains(Scope.publications))
						ListTile(
							title: const Text("Manage publications"),
							leading: Icon(Icons.new_releases),
							onTap: pushRoute(context, Routes.publications),
						),

					ListTile(
						title: const Text ("Logout"),
						leading: Icon (Icons.lock_outline),
						onTap: () async {
							await Auth.signOut();
							await Navigator.of(context).pushReplacementNamed(Routes.login);
						}
					)
				]
			)
		);
	}
}
