import "package:flutter/material.dart";

import "model_listener.dart";
import "period_tile.dart";
import "services.dart";

import "package:ramaz_admin/data.dart";
import "package:ramaz_admin/models.dart";

class TextModel {
	final String preload;

	TextModel([this.preload]) :
		controller = TextEditingController(text: preload);

	final TextEditingController controller;
}

class SpecialBuilder extends StatelessWidget {
	static Future<Special> buildSpecial(
		BuildContext context,
		[Special preload]
	) => showDialog(
		context: context, 
		builder: (_) => SpecialBuilder(preload: preload),
	);

	final Special preload;

	SpecialBuilder({this.preload});

	@override 
	Widget build(BuildContext context) => ModelListener<SpecialBuilderModel, TextModel>(
		uiModel: () => TextModel(preload?.name),
		model: () => SpecialBuilderModel()..usePreset(preload),
		builder: (SpecialBuilderModel model, Widget cancel, TextModel textModel) => Scaffold(
			appBar: AppBar (
				title: Text ("Make new schedule"),
				actions: [
					IconButton(
						icon: Icon (Icons.sync),
						tooltip: "Use preset",
						onPressed: () async {
							final Special special = await showModalBottomSheet<Special>(
								context: context,
								builder: (BuildContext context) => ListView(
									children: [
										SizedBox(
											width: double.infinity,
											height: 60,
											child: Center(
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
										Divider(),
										for (final Special special in Services.of(context).admin.admin.specials) 
											ListTile(
												title: Text (special.name),
												onTap: () => Navigator.of(context).pop(special),
											),
									]
								)
							);
							textModel.controller.text = special.name;
							model.usePreset(special);
						}
					),
				]
			),
			floatingActionButton: FloatingActionButton.extended(
				label: Text ("Save"),
				icon: Icon (Icons.done),
				onPressed: !model.ready ? null : 
					() => Navigator.of(context).pop(model.special),
				backgroundColor: model.ready
					? Theme.of(context).accentColor
					: Theme.of(context).disabledColor,
			),
			body: ListView(
				padding: EdgeInsets.all(15),
				children: [
					Padding(
						padding: EdgeInsets.symmetric(horizontal: 10),
						child: TextField(
							controller: textModel.controller,
							onChanged: (String value) => model.name = value,
							textInputAction: TextInputAction.done,
							textCapitalization: TextCapitalization.sentences,
							decoration: InputDecoration(
								labelText: "Name",
								hintText: "Name of the schedule",
							),
						),
					),
					SizedBox(height: 20),
					ListTile(
						title: Text ("Homeroom"),
						trailing: DropdownButton<int>(
							value: model.homeroom,
							onChanged: (int index) => model.homeroom = index,
							items: [
								DropdownMenuItem(
									value: null,
									child: const Text ("None")
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
						title: Text ("Mincha"),
						trailing: DropdownButton<int>(
							value: model.mincha,
							onChanged: (int index) => model.mincha = index,
							items: [
								DropdownMenuItem(
									value: null,
									child: const Text ("None")
								),
								for (int index = 0; index < model.numPeriods; index++) 
									DropdownMenuItem(
										value: index,
										child: Text ("${index + 1}"),
									)
							]
						)
					),
					SizedBox(height: 20),
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
						label: Text ("Add period"),
						onPressed: () => model.numPeriods++,
					),
					if (model.numPeriods == 0) 
						Text(
							"You can also select a preset by clicking the button on top",
							textScaleFactor: 1.5,
							textAlign: TextAlign.center,
						),
				]
			)
		)
	);
}
