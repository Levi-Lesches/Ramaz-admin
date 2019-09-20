import "package:flutter/material.dart";

import "drawer.dart";

class HomePage extends StatelessWidget {
	@override
	Widget build(BuildContext context) => Scaffold(
		drawer: NavDrawer(),
		appBar: AppBar(title: const Text ("Home")),
		body: Center (
			child: Column(
				mainAxisSize: MainAxisSize.min,
				children: [
					const Text ("Open the menu for options", textScaleFactor: 1.3),
					const SizedBox(height: 10),
					Builder(
						builder: (BuildContext context) => FlatButton (
							onPressed: () => Scaffold.of(context).openDrawer(),
							child: const Text("⟵", textScaleFactor: 2),
						),
					)
				]
			),
		)
	);
}
