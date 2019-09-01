import "package:flutter/material.dart";

import "drawer.dart";

class HomePage extends StatelessWidget {
	@override
	Widget build(BuildContext context) => Scaffold(
		drawer: NavDrawer(),
		appBar: AppBar(title: Text ("Home")),
		body: Center (
			child: Column(
				mainAxisSize: MainAxisSize.min,
				children: [
					Text ("Swipe from the left for options", textScaleFactor: 1.3),
					SizedBox(height: 10),
					Text ("⟵", textScaleFactor: 2)
				]
			),
		)
	);
}
