import "package:flutter/material.dart";

import "package:ramaz_admin/data.dart";
import "package:ramaz_admin/models.dart";

import "model_listener.dart";
import "period_tile.dart";
import "services.dart";

class SpecialBuilder extends StatefulWidget {
	static Future<Special> buildSpecial(
		BuildContext context,
		[Special preload]
	) => showDialog(
		context: context, 
		builder: (_) => SpecialBuilder(preload: preload),
	);

	final Special preload;

	const SpecialBuilder({this.preload});

	@override 
	SpecialBuilderState createState() => SpecialBuilderState();
}

class SpecialBuilderState extends State<SpecialBuilder> {
	TextEditingController controller;

	@override
	void initState() {
		super.initState();
		controller = TextEditingController(text: widget.preload.name);
	}

	@override 
	void dispose() {
		controller.dispose();
		super.dispose();
	}

	@override 
	Widget build(BuildContext context) => ModelListener<SpecialBuilderModel>(
		model: () => SpecialBuilderModel()..usePreset(widget.preload),
		builder: (_, SpecialBuilderModel model, Widget cancel) => Scaffold(
			appBar: AppBar (
				title: const Text ("Make new schedule"),
				actions: [
					IconButton(
						icon: const Icon (Icons.sync),
						tooltip: "Use preset",
						onPressed: () async {
							final Special special = await showModalBottomSheet<Special>(
								context: context,
								builder: (BuildContext context) => ListView(
									children: [
										SizedBox(
											width: double.infinity,
											height: 60,
											child: const Center(
												child: Text(
													"Use a preset",
													textScaleFactor: 1.5
												),
											),
										),
										for (final Special special in Special.specialList) 
											ListTile(
												title: Text (special.name),
												onTap: () => Navigator.of(context).pop(special),
											),
										const Divider(),
										for (
											final Special special in 
											Services.of(context).admin.admin.specials
										) ListTile(
											title: Text (special.name),
											onTap: () => Navigator.of(context).pop(special),
										),
									]
								)
							);
							controller.text = special.name;
							model.usePreset(special);
						}
					),
				]
			),
			floatingActionButton: FloatingActionButton.extended(
				label: const Text ("Save"),
				icon: const Icon (Icons.done),
				onPressed: !model.ready ? null : 
					() => Navigator.of(context).pop(model.special),
				backgroundColor: model.ready
					? Theme.of(context).accentColor
					: Theme.of(context).disabledColor,
			),
			body: ListView(
				padding: const EdgeInsets.all(15),
				children: [
					Padding(
						padding: const EdgeInsets.symmetric(horizontal: 10),
						child: TextField(
							controller: controller,
							onChanged: (String value) => model.name = value,
							textInputAction: TextInputAction.done,
							textCapitalization: TextCapitalization.sentences,
							decoration: InputDecoration(
								labelText: "Name",
								hintText: "Name of the schedule",
							),
						),
					),
					const SizedBox(height: 20),
					ListTile(
						title: const Text ("Homeroom"),
						trailing: DropdownButton<int>(
							value: model.homeroom,
							onChanged: (int index) => model.homeroom = index,
							items: [
								const DropdownMenuItem(
									value: null,
									child: Text ("None")
								),
								for (int index = 0; index < model.numPeriods; index++) 
									DropdownMenuItem(
										value: index,
										child: Text ("${index + 1}"),
									)
							]
						)
					),
					ListTile(
						title: const Text ("Mincha"),
						trailing: DropdownButton<int>(
							value: model.mincha,
							onChanged: (int index) => model.mincha = index,
							items: [
								const DropdownMenuItem(
									value: null,
									child: Text ("None")
								),
								for (int index = 0; index < model.numPeriods; index++) 
									DropdownMenuItem(
										value: index,
										child: Text ("${index + 1}"),
									)
							]
						)
					),
					const SizedBox(height: 20),
					for (int index = 0; index < model.numPeriods; index++)
						PeriodTile(
							range: model.times [index],
							skipped: model.skips.contains(index),
							onChanged: (Range range) => model.replaceTime(index, range),
							onRemoved: () => model.numPeriods--,
							toggleSkip: () => model.toggleSkip(index),
							isHomeroom: index == model.homeroom,
							isMincha: index == model.mincha,
							index: model.indices [index],
						),
					FlatButton.icon(
						icon: Icon (Icons.add),
						label: const Text ("Add period"),
						onPressed: () => model.numPeriods++,
					),
					if (model.numPeriods == 0) 
						const Text(
							"You can also select a preset by clicking the button on top",
							textScaleFactor: 1.5,
							textAlign: TextAlign.center,
						),
				]
			)
		)
	);
}
