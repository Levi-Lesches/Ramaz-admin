import "package:flutter/material.dart";

import "package:ramaz_admin/data.dart";
import "package:ramaz_admin/models.dart";

import "model_listener.dart";
import "services.dart";
import "special_builder.dart";

class DayBuilder extends StatelessWidget {
	static Future<Day> getDay({
		@required BuildContext context, 
		@required String month, 
		@required int date
	}) => showDialog<Day>(
		context: context, 
		builder: (_) => DayBuilder(month: month, date: date),
	);

	final String month;
	final int date;
	const DayBuilder({
		@required this.month, 
		@required this.date
	});

	@override
	Widget build (BuildContext context) => ModelListener<DayBuilderModel>(
		model: () => DayBuilderModel(Services.of(context).admin),
		// Here, the builder is like the child property. 
		// ignore: sort_child_properties_last
		child: FlatButton(
			onPressed: () => Navigator.of(context).pop(),
			child: const Text ("Cancel"),
		),
		builder: (_, DayBuilderModel model, Widget cancel) => AlertDialog(
			title: const Text ("Edit day"),
			content: Column (
				mainAxisSize: MainAxisSize.min,
				children: [
					Text ("Date: $month $date"),
					const SizedBox(height: 20),
					Container(
						width: double.infinity,
						child: Wrap (
							alignment: WrapAlignment.spaceBetween,
							crossAxisAlignment: WrapCrossAlignment.center,
							children: [
								const Text(
									"Select letter", 
									textAlign: TextAlign.center
								),
								DropdownButton<Letter>(
									value: model.letter,
									hint: const Text ("Letter"),
									onChanged: (Letter letter) => model.letter = letter,
									items: [
										for (final Letter letter in Letter.values)
											DropdownMenuItem<Letter>(
												value: letter,
												child: Text (letterToString [letter]),
											)
									],
								)
							]
						),
					),
					const SizedBox(height: 20),
					Container(
						width: double.infinity,
						child: Wrap (
							runSpacing: 3,
							children: [
								const Text ("Select schedule"),
								DropdownButton<Special>(
									value: model.special,
									hint: const Text ("Schedule"),
									onChanged: (Special special) async {
										if (identical (special, Special.none)) {
											special = await SpecialBuilder.buildSpecial(context);
										}
										model.special = special;
									},
									items: [
										for (
											final Special special in 
											model.presetSpecials + model.userSpecials
										) DropdownMenuItem<Special>(
											value: special,
											child: Text (special.name),
										),

										DropdownMenuItem<Special>(
											value: Special.none,
											child: SizedBox(
												child: Row(
													children: [
														const Text ("Make new schedule"),
														Icon(Icons.add_circle_outline)
													]
												)
											)
										)
									],
								)
							]
						)
					)
				]
			),
			actions: [
				cancel,
				RaisedButton(
					onPressed: !model.ready ? null :() => 
						Navigator.of(context).pop(model.day),
					child: Text ("Save", style: TextStyle(color: Colors.white)),
				)
			]
		),
	);
}
