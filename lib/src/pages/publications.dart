import "package:flutter/material.dart";

import "package:ramaz_admin/data.dart";
import "package:ramaz_admin/widgets.dart";

class PublicationsManagerPage extends StatelessWidget {
	@override
	Widget build(BuildContext context) => Scaffold(
		appBar: AppBar(title: const Text("Manage publications")),
		body: ListView(
			children: [
				// for (final Publication publication in model.publications) 
				PublicationCard(
					Publication(
						name: "Rampage",
						downloadedIssues: const {},
						metadata: PublicationMetadata(
							issues: const {},
							description: "Some sort of description",
						)
					)
				)
			]
		)
	);
}
