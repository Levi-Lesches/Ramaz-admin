import "package:flutter/material.dart";

import "package:ramaz_admin/data.dart";
import "package:ramaz_admin/models.dart";
import "package:ramaz_admin/widgets.dart";

class PublicationsPage extends StatelessWidget {
	@override
	Widget build(BuildContext context) => ModelListener<PublicationModel>(
		model: () => PublicationModel(Services.of(context).services),
		builder: (BuildContext context, PublicationModel model, Widget _) => Scaffold(
			appBar: AppBar(title: Text (model.publication.name)),
			body: ListView(
				children: [
					ListTile (
						title: Text ("Image"), 
						trailing: IconButton(
							icon: Icon (Icons.image),
							onPressed: () {
							},
						),
					),


				]
			)
		)
	);
}
