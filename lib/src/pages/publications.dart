import "dart:async";
import "dart:io";
import "package:flutter/material.dart";
import "package:image_picker/image_picker.dart";
import "package:file_picker/file_picker.dart";
import "package:flutter_plugin_pdf_viewer/flutter_plugin_pdf_viewer.dart";

import "package:ramaz_admin/models.dart";
import "package:ramaz_admin/widgets.dart";

class DescriptionEditor extends StatefulWidget{
	final String description;

	const DescriptionEditor({@required this.description});

	@override
	DescriptionEditorState createState() => DescriptionEditorState();
}

class DescriptionEditorState extends State<DescriptionEditor> {
	TextEditingController controller;
	bool ready = false;

	@override
	void initState() {
		super.initState();
		controller = TextEditingController(text: widget.description);
	}

	@override
	void dispose() {
		controller.dispose();
		super.dispose();
	}

	@override
	Widget build(BuildContext context) => AlertDialog(
		title: const Text ("Edit description"),
		content: TextField(
			onChanged: checkIfReady,
			controller: controller,
			textInputAction: TextInputAction.done,
			textCapitalization: TextCapitalization.sentences,
			autofocus: true,
			decoration: InputDecoration(
				icon: Icon(Icons.info),
				labelText: "Edit description",
				hintText: "Description",
			),
		),
		actions: [
			FlatButton(
				onPressed: () => Navigator.of(context).pop(),
				child: const Text ("Cancel"),
			),
			RaisedButton(
				onPressed: !ready ? null : 
					() => Navigator.of(context).pop(controller.text),
				child: const Text ("Save"),

			),
		]
	);

	void checkIfReady(String text) => setState(() => 
		ready = text != widget.description && text.isNotEmpty
	);
}

class PublicationsPage extends StatelessWidget {
	@override
	Widget build(BuildContext context) => ModelListener<PublicationModel>(
		model: () => PublicationModel(Services.of(context).services),
		builder: (BuildContext context, PublicationModel model, Widget _) => Scaffold(
			appBar: AppBar(title: Text (model.publication.name)),
			body: ListView(
				children: [
					ListTile (
						title: const Text ("Image"), 
						trailing: IconButton(
							icon: Icon (Icons.image),
							onPressed: () => replaceImage(model),
						),
					),
					Ink.image(
						image: FileImage(File(model.publication.metadata.imagePath)),
						fit: BoxFit.cover,
						child: InkWell(
							onTap: () => replaceImage(model),
						)
					),
					const SizedBox(height: 20),

					ListTile(
						title: const Text ("Description"),
						trailing: IconButton(
							icon: Icon(Icons.edit),
							onPressed: () async => 
								model.replaceDescription(
									await getDescription(
										context, 
										model.publication.metadata.description
									)
								),
						)
					),
					GestureDetector(
						onTap: () async => 
							model.replaceDescription(
								await getDescription(
									context, 
									model.publication.metadata.description
								)
							),
						child: Text(model.publication.metadata.description),
					),
					const SizedBox(height: 20),

					PublicationMonthsList(
						issues: model.publication.metadata.issuesByMonth,
						replaceIssue: (String issue) async => model.replaceIssue(
							issue, 
							await FilePicker.getFile(
								type: FileType.CUSTOM,
								fileExtension: ".pdf",
							)
						),
						deleteIssue: (String issue) async {
							final bool confirmed = await showDialog<bool>(
								context: context,
								builder: (BuildContext context) => AlertDialog(
									title: const Text("Confirm"),
									content: const ListTile(
										title: Text("Are you sure you want to delete this issue?"),
										subtitle: Text("This cannot be undone"),
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
							if (!confirmed) {
								return;
							}
							final ScaffoldFeatureController<SnackBar, SnackBarClosedReason> 
								controller = Scaffold.of(context).showSnackBar(
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
							Scaffold.of(context).showSnackBar(
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
					)
				]
			)
		)
	);

	Future<void> replaceImage(PublicationModel model) async => model.replaceImage(
		await ImagePicker.pickImage(
			source: ImageSource.gallery
		)
	);

	Future<String> getDescription(BuildContext context, String text) => 
		showDialog<String>(
			context: context, 
			builder: (_) => DescriptionEditor(description: text),
		);
}
