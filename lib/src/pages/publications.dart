import "package:flutter/material.dart";

import "package:ramaz_admin/models.dart";
import "package:ramaz_admin/widgets.dart";

import "drawer.dart";
import "publication_builder.dart";

class PublicationsManagerPage extends StatelessWidget {
	@override
	Widget build(BuildContext context) => ModelListener<PublicationsManager>(
		model: () => PublicationsManager(Services.of(context).services),
		builder: (BuildContext context, PublicationsManager model, _) => Scaffold(
			appBar: AppBar(title: const Text("Manage publications")),
			drawer: NavDrawer(),
			floatingActionButton: FloatingActionButton.extended(
				icon: const Icon(Icons.add),
				label: const Text("Add a publication"),
				onPressed: () async {
					await PublicationBuilder.getPublication(context);
					model.refresh();
				},
			),
			body: FutureBuilder(
				future: model.publications,
				builder: (_, AsyncSnapshot<List<String>> snapshot) => !snapshot.hasData 
					? const Center(child: CircularProgressIndicator())
					: ListView(
						padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
						children: [
							for (final String publication in snapshot.data)
								PublicationCard(publication)
						]
					)
			)
		)
	);
}
