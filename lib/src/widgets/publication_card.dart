import "dart:io";
import "package:flutter/material.dart";

import "package:ramaz_admin/data.dart";
import "package:ramaz_admin/services.dart";
import "package:ramaz_admin/src/pages/publication_page.dart";

import "services.dart";

class PublicationCard extends StatefulWidget {
	final String publication;

	const PublicationCard(this.publication);

	@override
	PublicationCardState createState() => PublicationCardState();
}

class PublicationCardState extends State<PublicationCard> {
	static const double cardSize = 250;
	static const double imageSize = 175;

	Future<Map<String, dynamic>> metadata;

	@override 
	void didChangeDependencies() {
		super.didChangeDependencies();
		metadata = getMetadata(Services.of(context).storage);
	}

	@override
	Widget build(BuildContext context) => Card(
		child: SizedBox(
			height: cardSize,
			width: cardSize,
			child: FutureBuilder(
				future: metadata,
				builder: (_, AsyncSnapshot<Map> snapshot) => !snapshot.hasData
					? const Center(child: CircularProgressIndicator())
					: InkWell(
						onTap: () => Navigator.of(context).push(
							MaterialPageRoute(
								builder: (_) => PublicationPage(
									publication: Publication(
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
								SizedBox(
									width: imageSize,
									height: imageSize,
									child: Image.file(
										File(
											Services.of(context).storage.getImagePath(widget.publication)
										),
										fit: BoxFit.cover,
									)
								)
							]
						)
					)
			)
		)
	);

	Future<Map<String, dynamic>> getMetadata(CloudStorage storage) async {
		await storage.getImage(widget.publication);
		return storage.getMetadata(widget.publication);
	}
}
