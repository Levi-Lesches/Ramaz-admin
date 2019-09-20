import "package:flutter/material.dart";

import "package:ramaz_admin/constants.dart";
import "package:ramaz_admin/data.dart";
import "package:ramaz_admin/services.dart";
import "package:ramaz_admin/widgets.dart";

class NavDrawer extends StatelessWidget {
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
							onTap: () => Navigator.of(context).pushReplacementNamed(Routes.calendar),
						),
						ListTile(
							title: const Text ("Manage custom schedules"),
							leading: Icon(Icons.schedule),
							onTap: () => Navigator.of(context).pushReplacementNamed(Routes.specials),
						)
					],

					if (admin.scopes.contains(Scope.schedule))
						ListTile(
							title: const Text ("Edit student schedules"),
							leading: Icon (Icons.account_circle),
							onTap: () => Navigator.of(context).pushReplacementNamed(Routes.schedule),
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
