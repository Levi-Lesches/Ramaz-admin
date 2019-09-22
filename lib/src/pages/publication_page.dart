import "dart:async";
import "dart:io";
import "package:flutter/material.dart";
import "package:file_picker/file_picker.dart";
import "package:flutter_plugin_pdf_viewer/flutter_plugin_pdf_viewer.dart";

import "package:ramaz_admin/data.dart";
import "package:ramaz_admin/models.dart";
import "package:ramaz_admin/widgets.dart";

class PublicationPage extends StatelessWidget {
	final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
	final Publication publication;

	PublicationPage(this.publication);

	@override
	Widget build(BuildContext context) => ModelListener<PublicationModel>(
		model: () => PublicationModel(Services.of(context).services, publication),
		builder: (BuildContext context, PublicationModel model, Widget _) => Scaffold(
			key: scaffoldKey,
			appBar: AppBar(title: Text (model.publication.name)),
			floatingActionButton: FloatingActionButton(
				onPressed: () async {
					final File file = await FilePicker.getFile(
						type: FileType.CUSTOM,
						fileExtension: "pdf"
					);
					if (file == null) {
						return;
					}
					await model.upload(file);
				},
				child: Icon(Icons.add),
			),
			body: model.publication == null 
				? const Center (child: CircularProgressIndicator())
				: ListView(
					padding: const EdgeInsets.symmetric(horizontal: 10),
					children: [
						if (model.loading) 
							const LinearProgressIndicator(),
						ListTile (
							title: const Text ("Image"), 
							trailing: IconButton(
								icon: Icon (Icons.image),
								onPressed: () => replaceImage(model),
							),
						),
						Ink.image(
							image: MemoryImage(File(model.imagePath).readAsBytesSync()),
							fit: BoxFit.cover,
							child: AspectRatio(
								aspectRatio: 1,
								child: InkWell(
									onTap: () => replaceImage(model),
								)
							),
						),	
						const SizedBox(height: 20),

						ListTile(
							title: const Text ("Description"),
							trailing: IconButton(
								icon: Icon(Icons.edit),
								onPressed: () async => 
									model.replaceDescription(
										await DescriptionEditor.getDescription(
											context, 
											model.publication.metadata.description
										)
									),
							)
						),
						GestureDetector(
							onTap: () async => model.replaceDescription(
								await DescriptionEditor.getDescription(
									context, 
									model.publication.metadata.description
								)
							),
							child: Text(model.publication.metadata.description),
						),
						const SizedBox(height: 40),

						PublicationMonthsList(
							issues: model.publication.metadata.issuesByMonth,
							replaceIssue: (String issue) async => model.replaceIssue(
								issue, 
								await FilePicker.getFile(
									type: FileType.CUSTOM,
									fileExtension: "pdf",
								)
							),
							deleteIssue: (String issue) async {
								final bool confirmed = await showDialog<bool>(
									context: context,
									builder: (BuildContext context) => AlertDialog(
										title: const Text("Confirm"),
										content: const ListTile(
											title: Text("Are you sure you want to delete this issue?"),
										),
										actions: [
											FlatButton(
												onPressed: () => Navigator.of(context).pop(false),
												child: const Text("Cancel"),
											),
											RaisedButton(
												onPressed: () => Navigator.of(context).pop(true),
												child: const Text("Confirm"),
											)
										]
									)
								);
								if (confirmed != true) {  // can be null
									return;
								}
								final ScaffoldFeatureController<SnackBar, SnackBarClosedReason> 
									controller = scaffoldKey.currentState.showSnackBar(
										SnackBar(
											content: const Text ("Deleting issue"),
											action: SnackBarAction(
												label: "CANCEL",
												// Simply being dismissed is enough to cancel
												onPressed: () {},
											)
										)
									);
								// User cancelled the deletion
								if ((await controller.closed) == SnackBarClosedReason.action) {
									return;
								}
								await model.deleteIssue(issue);
								scaffoldKey.currentState.showSnackBar(
									const SnackBar(
										content: Text("Issue deleted"),
									)
								);
							},
							openIssue: (String issue) async {
								final PDFDocument doc = await PDFDocument.fromFile(
									File(await model.getIssue(issue))
								);
								await Navigator.of(context).push(
									MaterialPageRoute(
										builder: (_) => Scaffold(
											appBar: AppBar(title: const Text("View issue")),
											body: PDFViewer(document: doc)
										)
									)
								);
							}
						),
						const SizedBox(height: 70),
					]
				)
		)
	);

	Future<void> replaceImage(PublicationModel model) async {
		final File file = await FilePicker.getFile(
			type: FileType.IMAGE, 
			fileExtension: ".png"
		);
		if (file == null) {
			return;
		}
		await model.replaceImage(file);
	}
}
