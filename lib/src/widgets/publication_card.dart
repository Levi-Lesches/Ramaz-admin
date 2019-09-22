import "dart:io";
import "package:flutter/material.dart";

import "package:ramaz_admin/src/pages/publication_page.dart";
import "package:ramaz_admin/data.dart";

import "services.dart";

class PublicationCard extends StatefulWidget {
	final String publication;

	const PublicationCard(this.publication);

	@override
	PublicationCardState createState() => PublicationCardState();
}

class PublicationCardState extends State<PublicationCard> {
	Future<Map<String, dynamic>> metadata;

	@override 
	void didChangeDependencies() {
		super.didChangeDependencies();
		metadata = Services.of(context).storage.getMetadata(widget.publication);
	}

	@override
	Widget build(BuildContext context) => SizedBox(
		height: 300, 
		width: 300,
		child: Card(
			child: FutureBuilder(
				future: metadata,
				builder: (_, AsyncSnapshot<Map> snapshot) => !snapshot.hasData
					? const Center(child: CircularProgressIndicator())
					: InkWell(
							onTap: () => Navigator.of(context).push(
								MaterialPageRoute(
									builder: (_) => PublicationPage(
										Publication(
											name: widget.publication,
											// We want this to be mutable
											// ignore: prefer_const_literals_to_create_immutables
											downloadedIssues: {},
											metadata: PublicationMetadata.fromJson(snapshot.data)
										)
									),
								)
							),
							child: Column(
								children: [
									ListTile(title: Text (widget.publication)),
									Center(
										child: Image.file(
											File(
												Services
												.of(context)
												.storage
												.getImagePath(widget.publication)
											)
										)
									),
								]
							)
					)
			)
		)
	);
}
