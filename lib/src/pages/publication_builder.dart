import "dart:io";
import "package:flutter/material.dart";
import "package:file_picker/file_picker.dart";

import "package:ramaz_admin/data.dart";
import "package:ramaz_admin/widgets.dart";

class PublicationBuilder extends StatefulWidget {
	static Future<String> getPublication(BuildContext context) => showDialog(
		context: context,
		builder: (_) => PublicationBuilder(),
	);

	@override
	PublicationBuilderState createState() => PublicationBuilderState();
}

class PublicationBuilderState extends State<PublicationBuilder> {
	final TextEditingController nameController = TextEditingController();
	final TextEditingController descriptionController = TextEditingController();
	final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
	final FocusNode focusNode1 = FocusNode(), focusNode2 = FocusNode();

	File image;
	int _currentStep = 0;

	int get currentStep => _currentStep;
	set currentStep(int value) {
		_currentStep = value;
		setState(() {});
	}

	
	@override
	Widget build(BuildContext context) => Scaffold(
		key: scaffoldKey,
		appBar: AppBar(title: const Text("Make a new publication")),
		body: Stepper(
			currentStep: currentStep,
			onStepTapped: (int index) => currentStep = index,
			onStepContinue: () {
				focusNode1.unfocus();
				focusNode2.unfocus();
				if (currentStep != 2) {
					currentStep++;
				}
				else {
					String missing;
					if (nameController.text.isEmpty) {
						missing = "name";
					} else if (image == null) {
						missing = "cover image";
					} else if (descriptionController.text.isEmpty) {
						missing = "description";
					} 
					if (missing != null) {
						scaffoldKey.currentState.showSnackBar(
							SnackBar(
								content: Text("You need to specify the $missing before continuing.")
							)
						);
					} else {
						createPublication();
					}
				}
			},
			onStepCancel: () => Navigator.of(context).pop(),
			steps: [
				Step(
					isActive: currentStep == 0,
					state: getStepState(0),
					title: const Text("Create a name"),
					subtitle: const Text ("This will be visible to all users"),
					content: TextField(
						controller: nameController,
						focusNode: focusNode1,
						autofocus: true,
						textCapitalization: TextCapitalization.words,
						textInputAction: TextInputAction.next,
						onEditingComplete: () {
							focusNode1.unfocus();
							currentStep++;
						},
						decoration: InputDecoration(
							hintText: "Name",
						)
					),
				),
				Step(
					isActive: currentStep == 1,
					state: getStepState(1),
					title: const Text ("Select cover image"),
					subtitle: const Text ("This image will represent the publication"),
					content: SizedBox(
						height: 300, 
						width: 300,
						child: image == null 
							? InkWell(
								onTap: selectImage,
								child: const Placeholder()
							)
							: Card(  // image by itself won't collapse
								child: Ink.image(
									image: FileImage(image),
									fit: BoxFit.cover,
									child: InkWell(
										onTap: selectImage
									)
								)
							)
					),
				),
				Step(
					isActive: currentStep == 2,
					state:  getStepState(2),
					title: const Text("Describe the publication"),
					subtitle: const Text("This will be visible to all users"),
					content: TextField(
						controller: descriptionController,
						focusNode: focusNode2,
						textInputAction: TextInputAction.done,
						textCapitalization: TextCapitalization.sentences,
						onEditingComplete: focusNode2.unfocus,
						decoration: InputDecoration(
							hintText: "Description",
						)
					)
				)
			]
		)
	);

	StepState getStepState(int targetIndex) {
		if (currentStep == targetIndex) {
			return StepState.editing;
		} else if (currentStep < targetIndex) {
			return StepState.indexed;
		} else if (currentStep > targetIndex) {
			return StepState.complete;
		} else {
			throw RangeError("Current index cannot be $currentStep.");
		}
	}

	Future<void> selectImage() async {
		final File file = await FilePicker.getFile(type: FileType.IMAGE);
		if (file == null) {
			return;
		}
		image = file;
		setState(() {});
	}

	Future<void> createPublication() async {
		final String name = nameController.text;
		final String description = descriptionController.text;
		final Publication publication = Publication(
			name: name,
			downloadedIssues: const {},
			metadata: PublicationMetadata(
				issues: const {},
				description: description,
			)
		);
		final Services services = Services.of(context);
		await services.storage.createPublication(name);
		await services.storage.uploadImage(name, image);
		await services.storage.uploadMetadata(name, publication.metadata.toJson());
		Navigator.of(context).pop(name);
	}
}
