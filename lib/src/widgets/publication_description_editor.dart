import "package:flutter/material.dart";

class DescriptionEditor extends StatefulWidget{
	static Future<String> getDescription(BuildContext context, String text) => 
		showDialog<String>(
			context: context, 
			builder: (_) => DescriptionEditor(description: text),
		);


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
