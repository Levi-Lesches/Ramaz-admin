import "package:flutter/material.dart";

import "package:ramaz_admin/data.dart";

class PublicationCard extends StatelessWidget {
	final Publication publication;

	const PublicationCard(this.publication);

	@override
	Widget build(BuildContext context) => Card(
		child: InkWell(
			onTap: () {},
			child: Column(
				children: [
					ListTile(title: Text (publication.name)),
					Image.asset("images/google.png"),
					SizedBox(height: 20),
				]
			)
		)
	);
}
